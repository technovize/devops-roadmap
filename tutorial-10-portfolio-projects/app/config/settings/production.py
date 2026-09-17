import os
import boto3
import json
from .base import *

# -- Secrets from AWS Secrets Manager ---------------------------------------
def get_secret(secret_name):
    client = boto3.client("secretsmanager", region_name=os.environ["AWS_REGION"])
    return json.loads(client.get_secret_value(SecretId=secret_name)["SecretString"])

_db_secret = get_secret(f"{os.environ['PROJECT_NAME']}/production/database")
_app_secret = get_secret(f"{os.environ['PROJECT_NAME']}/production/app")

# -- Core settings -----------------------------------------------------------
DEBUG = False
SECRET_KEY = _app_secret["secret_key"]
ALLOWED_HOSTS = os.environ["ALLOWED_HOSTS"].split(",")

# -- Database ----------------------------------------------------------------
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": _db_secret["dbname"],
        "USER": _db_secret["username"],
        "PASSWORD": _db_secret["password"],
        "HOST": _db_secret["host"],
        "PORT": _db_secret["port"],
        "CONN_MAX_AGE": 60,
        "OPTIONS": {"sslmode": "require"},
    }
}

# -- Cache (Redis) -----------------------------------------------------------
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": os.environ["REDIS_URL"],
        "OPTIONS": {"CLIENT_CLASS": "django_redis.client.DefaultClient"},
        "TIMEOUT": 300,
    }
}

# -- Celery ------------------------------------------------------------------
CELERY_BROKER_URL = os.environ["REDIS_URL"]
CELERY_RESULT_BACKEND = os.environ["REDIS_URL"]
CELERY_TASK_SERIALIZER = "json"
CELERY_ACCEPT_CONTENT = ["json"]

# -- Static files (S3 + CloudFront) -----------------------------------------
STORAGES = {
    "default": {"BACKEND": "storages.backends.s3boto3.S3Boto3Storage"},
    "staticfiles": {"BACKEND": "storages.backends.s3boto3.S3StaticStorage"},
}
AWS_STORAGE_BUCKET_NAME = os.environ["S3_BUCKET_NAME"]
AWS_S3_CUSTOM_DOMAIN = os.environ["CLOUDFRONT_DOMAIN"]

# -- Security headers --------------------------------------------------------
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True
SECURE_CONTENT_TYPE_NOSNIFF = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
X_FRAME_OPTIONS = "DENY"

# -- Logging (structured JSON) -----------------------------------------------
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "json": {
            "()": "structlog.stdlib.ProcessorFormatter",
            "processor": structlog.processors.JSONRenderer(),
        }
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "json",
        }
    },
    "root": {"handlers": ["console"], "level": "INFO"},
    "loggers": {
        "django": {"handlers": ["console"], "level": "WARNING", "propagate": False},
        "app": {"handlers": ["console"], "level": "INFO", "propagate": False},
    },
}
