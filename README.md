
for details, see the sqs-lambda-sns project page.

TODO:
- make aws account-id configurable (especially in the lambda func)

CAVEATS:
- subscriptions by e-mail CANNOT be provisioned by terraform, therefore
  you'll need to subscribe to SNS air-notify manually
- destroying SNS air-notify will leave those manual subscriptions hanging
  around, manual cleanup is required.

