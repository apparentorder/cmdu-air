provider "aws" {
	region = "eu-central-1"
}

data aws_caller_identity current {}
output account_id {
	value = data.aws_caller_identity.current.account_id
}

