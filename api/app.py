from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import requests
import io
import base64
from PIL import Image, PngImagePlugin
import uuid
import random


def getServerURL(dmodel, speed):
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
            # "sampler_name": "string",

    response = requests.post(url=f'{url}/sdapi/v1/txt2img', json=payload)

    print(response)
    r = response.json()
    # print(r)

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
    return filenames

app = Flask(__name__, static_folder='output')
cors = CORS(app, resources={r"/*": {"origins": "*"}})

@app.route('/', methods=['POST'])
def gen_img():
    data = request.get_json()
    prompt = data['prompt']
    negprompt = data['negprompt']
    steps = data['steps']
    guidance = data['guidance']
    width = data['width']
    height = data['height']
    batch_size = data['batch_size']

    filenames = generate_image(prompt, negprompt, steps, guidance, width, height, batch_size)
    image_data = {'images': filenames}
    return jsonify(image_data)

if __name__ == '__main__':
    # app.run(debug=True)
    from waitress import serve
    serve(app, host="0.0.0.0", port=8080)
