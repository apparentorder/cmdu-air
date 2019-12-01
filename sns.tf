resource aws_sns_topic air-notify {
	name = "air-notify"
	tags = var.airtag
}

###
### e-mail subscriptions via terraform are NOT supported
###
### see also: https://apparentorder.atlassian.net/wiki/spaces/FOO/pages/5701921/sns
###

