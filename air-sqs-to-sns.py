import pprint
import boto3
from datetime import datetime

#
# N.B.:
#
# *each* boto3.client incurs a ~200ms runtime penalty (wtf.)
#

def checkdev(device, quality, record):
	if quality >= 13:
		sns = boto3.client('sns')
		sts = boto3.client('sts')

		ts = int(record["attributes"]["SentTimestamp"]) / 1000
		ts_pretty = datetime.utcfromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S') + ' GMT'
		rawdata = pprint.pformat(record)

		sns.publish(
			TopicArn = 'arn:aws:sns:eu-central-1:%s:air-notify' % sts.get_caller_identity()["Account"],
			Subject = 'Air quality warning: %d (%s, %s)' % (quality, device, ts_pretty),
			Message = rawdata
		)

def lambda_handler(event, context):
	for record in event['Records']:
		payload=record["body"]
		print("SQS Message received: %s" % str(payload))

		att = record["messageAttributes"]
		device = att["device"]["stringValue"]
		quality = int(att["quality"]["stringValue"])

		print("Quality for device %s: %d" % (device, quality))
		checkdev(device, quality, record)

