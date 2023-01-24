#!/usr/bin/env python3

from flask import jsonify #replace with json dumps/loads?
import paho.mqtt.subscribe as mqtt
import json
import requests
import io
import base64
from PIL import Image, PngImagePlugin
import uuid
import random

host = "68.183.44.212"
topic = "$share/img_gen_workers/img_gen_requests"

def getServerURL(dmodel, speed):
    url = "http://einstein:7860"
    return url
    if dmodel == 'sd':
        instance_no = random(5)
        if instance_no == 0:
            url = "http://einstein:7860"
        if instance_no == 0:
            url = "http://einstein:7861"
        if instance_no == 0:
            url = "http://einstein:7862"
        if instance_no == 0:
            url = "http://einstein:7863"
        if instance_no == 0:
            url = "http://einstein:7864"

    if dmodel == 'sd':
        instance_no = random(5)
        if instance_no == 0:
            url = "http://einstein:7860"
        if instance_no == 0:
            url = "http://einstein:7861"
        if instance_no == 0:
            url = "http://einstein:7862"
        if instance_no == 0:
            url = "http://einstein:7863"
        if instance_no == 0:
            url = "http://einstein:7864"


    if dmodel == 'sd':
        instance_no = random(5)
        if instance_no == 0:
            url = "http://einstein:7860"
        if instance_no == 0:
            url = "http://einstein:7861"
        if instance_no == 0:
            url = "http://einstein:7862"
        if instance_no == 0:
            url = "http://einstein:7863"
        if instance_no == 0:
            url = "http://einstein:7864"


    if dmodel == 'sd':
        instance_no = random(5)
        if instance_no == 0:
            url = "http://einstein:7860"
        if instance_no == 0:
            url = "http://einstein:7861"
        if instance_no == 0:
            url = "http://einstein:7862"
        if instance_no == 0:
            url = "http://einstein:7863"
        if instance_no == 0:
            url = "http://einstein:7864"

    return url


def generate_image(prompt, negprompt, steps, guidance, width, height, batch_size, batch_count=1, dmodel='sd', speed=0):

    url = getServerURL(dmodel, speed)

    payload = {
        "prompt": prompt,
        "negative_prompt": negprompt,
        "steps": steps,
        "cfg_scale": guidance,
        "width": width,
        "height": height,
        "batch_size": batch_count, #batch_size,
        "n_iter": batch_size, #batch_count,

        "enable_hr": False,
        "denoising_strength": 0,
        "firstphase_width": 0,
        "firstphase_height": 0,
        "hr_scale": 2,
        "hr_upscaler": "string",
        "styles": [
            "string"
        ],
        "seed": -1,
        "subseed": -1,
        "subseed_strength": 0,
        "seed_resize_from_h": -1,
        "seed_resize_from_w": -1,
        "restore_faces": False,
        "tiling": False,
        "eta": 0,
        "s_churn": 0,
        "s_tmax": 0,
        "s_tmin": 0,
        "s_noise": 1,
        "override_settings": {},
        "override_settings_restore_afterwards": True,
        "sampler_index": "Euler"
    }
        # "sampler_name": "string", #??

    #Functions too chained.... needs inprovement #RAPID PROTOTYPING FTW ;-)
    #if URL is down we need a faster way to detect and use different url, not just except the try
    response = requests.post(url=f'{url}/sdapi/v1/txt2img', json=payload)

    print(response)
    r = response.json()
    print(r)

    filenames = []
    for i in r['images']:
        image = Image.open(io.BytesIO(base64.b64decode(i.split(",",1)[0])))

        png_payload = {
            "image": "data:image/png;base64," + i
        }
        response2 = requests.post(url=f'{url}/sdapi/v1/png-info', json=png_payload)
        print(response2)

        pnginfo = PngImagePlugin.PngInfo()
        pnginfo.add_text("parameters", response2.json().get("info"))

        filename = 'output/' + str(uuid.uuid1()) + '.png'
        print("Filename:", filename)
        image.save(filename, pnginfo=pnginfo)

        filenames.append(filename)
        print(filenames)
    return filenames


def gen_img(request):
    prompt = request['prompt']
    negprompt = request['negprompt']
    steps = request['steps']
    guidance = request['guidance']
    width = request['width']
    height = request['height']
    batch_size = request['batch_size']

    filenames = generate_image(prompt, negprompt, steps, guidance, width, height, batch_size)
    image_data = {'images': filenames}
    return jsonify(image_data)



# Define a callback function to handle incoming messages
def on_message(client, userdata, message):
    try:
        msg = json.loads(message.payload.decode('utf-8'))
        print("Received message", msg)
    #    print("Received message", str(message.payload))
        print("Topic:", message.topic)
        print("QoS:" + str(message.qos))
        #client.publish(msg['response_topic'], "Thank you for your request", qos=1)
        #client.publish('response_topic', "Thank you for your request", qos=1)
    except:
        print("Error parsing message");
        client.publish('response_topic', "Errrorrr.....1", qos=1)
        return

    try:
        gen_img(msg) 
    except:
        #Add retry mechanism with a limit
        print("Error generating img")
        client.publish('response_topic', "Errrorrr.....2", qos=1)

mqtt.callback(on_message, topic, hostname=host, qos=1, transport='websockets')
mqtt.loop()


