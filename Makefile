all: air-sqs-to-sns.zip

air-sqs-to-sns.zip: air-sqs-to-sns.py
	zip air-sqs-to-sns.zip air-sqs-to-sns.py

