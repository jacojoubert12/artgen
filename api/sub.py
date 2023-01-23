#!/usr/bin/env python3

import paho.mqtt.subscribe as mqtt
import json

host = "68.183.44.212"
topic = "$share/img_gen_workers/img_gen_requests"
# Define a callback function to handle incoming messages
def on_message(client, userdata, message):
    msg = json.loads(message.payload.decode('utf-8'))
    print("Received message", msg)
#    print("Received message", str(message.payload))
    print("Topic:", message.topic)
    print("QoS:" + str(message.qos))
    #client.publish(msg['response_topic'], "Thank you for your request", qos=1)
    client.publish('response_topic', "Thank you for your request", qos=1)

mqtt.callback(on_message, topic, hostname=host, qos=1)
mqtt.loop()

