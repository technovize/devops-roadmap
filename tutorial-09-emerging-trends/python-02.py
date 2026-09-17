# Using OpenFeature — the CNCF standard for feature flag SDKs
# pip install openfeature-sdk

from openfeature import api
from openfeature.provider.in_memory import InMemoryProvider

# Configure the provider (LaunchDarkly, Split, Unleash, Flagsmith, etc.)
api.set_provider(InMemoryProvider({
    "new-checkout-flow": {
        "defaultVariant": "off",
        "variants": {
            "on": True,
            "off": False
        },
        "enabled": True
    },
    "payment-provider": {
        "defaultVariant": "stripe",
        "variants": {
            "stripe": "stripe",
            "braintree": "braintree"
        },
        "enabled": True
    }
}))

client = api.get_client()


# In your application code
def checkout(request):
    user_context = {"targetingKey": request.user.id, "plan": request.user.plan}

    # Boolean flag — is the new flow enabled for this user?
    if client.get_boolean_value("new-checkout-flow", False, user_context):
        return new_checkout_flow(request)
    else:
        return legacy_checkout_flow(request)


def select_payment_provider():
    # String flag — which provider to use (A/B test or gradual migration)
    provider = client.get_string_value("payment-provider", "stripe", {})
    return payment_providers[provider]
