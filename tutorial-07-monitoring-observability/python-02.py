# pip install structlog
import structlog
import logging

# Configure structlog to output JSON in production
structlog.configure(
    processors=[
        structlog.contextvars.merge_contextvars,
        structlog.processors.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.JSONRenderer()        # Output as JSON
    ],
    logger_factory=structlog.PrintLoggerFactory(),
)

log = structlog.get_logger()


# -- Usage in Application Code -----------------------------------------------

def process_payment(user_id: str, amount: float, currency: str):
    # Bind context fields that appear in all subsequent log calls
    logger = log.bind(
        user_id=user_id,
        amount=amount,
        currency=currency,
        operation="process_payment"
    )

    logger.info("Payment processing started")

    try:
        result = stripe_client.charge(amount=amount, currency=currency)
        logger.info(
            "Payment processed successfully",
            charge_id=result.id,
            duration_ms=result.duration_ms
        )
        return result

    except stripe.error.CardError as e:
        logger.warning(
            "Card declined",
            error_code=e.code,
            decline_code=e.decline_code
        )
        raise

    except stripe.error.APIError as e:
        logger.error(
            "Stripe API error",
            error=str(e),
            status_code=e.http_status
        )
        raise
