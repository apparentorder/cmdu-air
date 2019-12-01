
for details, see the sqs-lambda-sns project page.

CAVEATS:
- subscriptions by e-mail CANNOT be provisioned by terraform, therefore
  you'll need to subscribe to SNS air-notify manually
- destroying SNS air-notify will leave those manual subscriptions hanging
  around, manual cleanup is required.

