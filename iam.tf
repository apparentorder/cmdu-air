
resource aws_iam_group air-device {
	name = "air-device"
}

resource aws_iam_policy air-sns-publish {
	name = "air-sns-publish"
	policy = jsonencode({
	    "Version": "2012-10-17",
	    "Statement": [
		{
		    "Effect": "Allow",
		    "Action": "sns:Publish",
		    "Resource": "arn:aws:sns:eu-central-1:329261680777:air-notify"
		}
	    ]
	})
}

resource aws_iam_policy air-sqs-receive {
	name = "air-sqs-receive"
	policy = jsonencode({
	    "Version": "2012-10-17",
	    "Statement": [
		{
		    "Effect": "Allow",
		    "Action": [
			"sqs:DeleteMessage",
			"sqs:ReceiveMessage",
			"sqs:GetQueueAttributes"
		    ],
		    "Resource": "arn:aws:sqs:eu-central-1:329261680777:airdata"
		}
	    ]
	})
}

resource aws_iam_policy air-sqs-send {
	name = "air-sqs-send"
	policy = jsonencode({
	    "Version": "2012-10-17",
	    "Statement": [
		{
		    "Effect": "Allow",
		    "Action": "sqs:SendMessage",
		    "Resource": "arn:aws:sqs:eu-central-1:329261680777:airdata"
		}
	    ]
	})
}

resource aws_iam_role air-lambda {
	name = "air-lambda"
	assume_role_policy = jsonencode({
		"Version": "2012-10-17",
		"Statement": [{
			"Action": "sts:AssumeRole",
			"Principal": {
				"Service": "lambda.amazonaws.com"
			},
			"Effect": "Allow",
			"Sid": ""
		}]
	})
	tags = var.airtag
}

resource aws_iam_role_policy_attachment air-lambda-sns-publish {
	role = "${aws_iam_role.air-lambda.name}"
	policy_arn = "${aws_iam_policy.air-sns-publish.arn}"
}

resource aws_iam_role_policy_attachment air-lambda-sqs-receive {
	role = "${aws_iam_role.air-lambda.name}"
	policy_arn = "${aws_iam_policy.air-sqs-receive.arn}"
}

resource aws_iam_role_policy_attachment air-lambda-basic {
	role = "${aws_iam_role.air-lambda.name}"
	policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource aws_iam_group_policy_attachment air-device-send {
	group = "${aws_iam_group.air-device.name}"
	policy_arn = "${aws_iam_policy.air-sqs-send.arn}"
}

resource aws_iam_user air-pooch {
	name = "air-pooch"
	tags = var.airtag
	force_destroy = true
}

resource aws_iam_access_key air-pooch-key {
	user = "${aws_iam_user.air-pooch.name}"
}

output air-pooch-key-id {
	value = "${aws_iam_access_key.air-pooch-key.id}"
}

output air-pooch-key-secret {
	value = "${aws_iam_access_key.air-pooch-key.secret}"
}

resource aws_iam_group_membership air-device {
	name = "air-device-memberships"
	users = [
		"${aws_iam_user.air-pooch.name}",
	]
	group = "${aws_iam_group.air-device.name}"
}

