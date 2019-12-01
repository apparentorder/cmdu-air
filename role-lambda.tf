
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

# ----------------------------------------------------------------------

resource aws_iam_policy air-sns-publish {
	name = "air-sns-publish"
	policy = jsonencode({
	    "Version": "2012-10-17",
	    "Statement": [
		{
		    "Effect": "Allow",
		    "Action": "sns:Publish",
		    "Resource": "arn:aws:sns:eu-central-1:${data.aws_caller_identity.current.account_id}:air-notify"
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
		    "Resource": "arn:aws:sqs:eu-central-1:${data.aws_caller_identity.current.account_id}:airdata"
		}
	    ]
	})
}

# ----------------------------------------------------------------------

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

