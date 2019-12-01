resource aws_lambda_function air-sqs-to-sns {
	function_name = "air-sqs-to-sns"
	runtime = "python3.8"
	role = aws_iam_role.air-lambda.arn
	handler = "air-sqs-to-sns.lambda_handler"
	filename = "air-sqs-to-sns.zip"
	source_code_hash = filebase64sha256("air-sqs-to-sns.zip")
	tags = var.airtag
}

resource aws_lambda_event_source_mapping air-sqs-trigger {
	event_source_arn = aws_sqs_queue.airdata.arn
	function_name = aws_lambda_function.air-sqs-to-sns.arn
}

