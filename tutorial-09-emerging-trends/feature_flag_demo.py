# pip install openfeature-sdk

from openfeature import api
from openfeature.provider.in_memory import InMemoryFlag, InMemoryProvider

# Configure flags
flags = {
    "new-checkout-flow": InMemoryFlag(
        default_variant="off",
        variants={"on": True, "off": False}
    ),
    "payment-provider": InMemoryFlag(
        default_variant="stripe",
        variants={"stripe": "stripe", "braintree": "braintree"}
    ),
    "api-rate-limit": InMemoryFlag(
        default_variant="standard",
        variants={"standard": 100, "premium": 1000, "trial": 10}
    ),
}

api.set_provider(InMemoryProvider(flags))
client = api.get_client()

def checkout(user_id: str, plan: str = "standard"):
    context = {"targetingKey": user_id, "plan": plan}

    # Boolean flag
    use_new_flow = client.get_boolean_value("new-checkout-flow", False, context)
    print(f"User {user_id}: new checkout flow = {use_new_flow}")

    # String flag
    provider = client.get_string_value("payment-provider", "stripe", context)
    print(f"User {user_id}: payment provider = {provider}")

    # Integer flag
    rate_limit = client.get_integer_value("api-rate-limit", 100, context)
    print(f"User {user_id}: rate limit = {rate_limit} req/min")

# Test with different users
checkout("user-001", "standard")
checkout("user-002", "premium")

# Exercise: Modify the InMemoryProvider to enable the new checkout flow
# for 50% of users based on a hash of their user ID
