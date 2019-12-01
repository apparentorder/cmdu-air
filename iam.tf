
resource aws_iam_user air-pooch {
	name = "air-pooch"
	tags = var.airtag
	force_destroy = true
}

resource aws_iam_access_key air-pooch-key {
	user = aws_iam_user.air-pooch.name
}

output air-pooch-key-id {
	value = aws_iam_access_key.air-pooch-key.id
}

output air-pooch-key-secret {
	value = aws_iam_access_key.air-pooch-key.secret
}

# ----------------------------------------------------------------------

resource aws_iam_group air-device {
	name = "air-device"
}

resource aws_iam_group_membership air-device {
	name = "air-device-memberships"
	users = [
		aws_iam_user.air-pooch.name,
	]
	group = aws_iam_group.air-device.name
}

# ----------------------------------------------------------------------

resource aws_iam_policy air-sqs-send {
	name = "air-sqs-send"
	policy = jsonencode({
	    Version: "2012-10-17",
	    Statement: [
		{
		    Effect: "Allow",
		    Action: "sqs:SendMessage",
		    Resource: "arn:aws:sqs:eu-central-1:${data.aws_caller_identity.current.account_id}:airdata"
		}
	    ]
	})
}

resource aws_iam_group_policy_attachment air-device-send {
	group = aws_iam_group.air-device.name
	policy_arn = aws_iam_policy.air-sqs-send.arn
}

