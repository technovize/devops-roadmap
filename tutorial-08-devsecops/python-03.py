# Redact PII from logs using structlog processor
import structlog

def redact_pii(logger, method, event_dict):
    """Remove PII fields before they reach the log sink."""
    PII_FIELDS = {"email", "phone", "ip_address", "full_name",
                  "date_of_birth", "ssn", "credit_card"}

    for field in PII_FIELDS:
        if field in event_dict:
            event_dict[field] = "[REDACTED]"

    return event_dict

structlog.configure(
    processors=[
        redact_pii,   # Run before any output processor
        structlog.processors.JSONRenderer()
    ]
)
