#!/usr/bin/env python3

import paho.mqtt.client as mqtt
import paho.mqtt.subscribe as mqtt_sub
import time
import json
import uuid

mqttv=mqtt.MQTTv5

host = '68.183.44.212'
port = 1883
topic = "img_gen_requests"
client_id = str(uuid.uuid4())
response_topic = 'response_topic'# topic + '/' + client_id
message = {"prompt" : "My Prompt", "response_topic" : response_topic}
json_message = json.dumps(message)


#def on_message(client, userdata, message):
#    msg = json.loads(message.payload.decode('utf-8'))
#    print("Received message", msg)
##    print("Received message", str(message.payload))
#    print("Topic:", message.topic)
#    print("QoS:" + str(message.qos))


#time.sleep(3)

pub_client = mqtt.Client("pub_client", protocol=mqttv, transport='websockets')
pub_client.connect(host, port)
pub_client.publish(topic, json_message, qos=1)

pub_client.loop()

#mqtt_sub.callback(on_message, response_topic, hostname=host, qos=1)
#mqtt_sub.loop()
