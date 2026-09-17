import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("deployment.log"),
        logging.StreamHandler()  # Also print to console
    ]
)

log = logging.getLogger(__name__)

log.info("Starting deployment...")
log.warning("Deprecated API version detected")
log.error("Health check failed after 30 retries")
