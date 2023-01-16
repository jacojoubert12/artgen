from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import requests
import io
import base64
from PIL import Image, PngImagePlugin
import uuid


def generate_image(prompt):
    url = "https://e279c347-3950-42c2.gradio.live"

    payload = {
        "prompt": prompt,
        "steps": 50
    }

    response = requests.post(url=f'{url}/sdapi/v1/txt2img', json=payload)

    print(response)
    r = response.json()
    print(r)

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
        image.save(filename, pnginfo=pnginfo)
        return filename

app = Flask(__name__, static_folder='output')
cors = CORS(app, resources={r"/*": {"origins": "*"}})

@app.route('/', methods=['POST'])
def gen_img():
    data = request.get_json()
    prompt = data['prompt']
    filename = generate_image(prompt)
    image_data = {'image': filename}
    return jsonify(image_data)
    #return jsonify(message=f'Hello, {filename}!')

if __name__ == '__main__':
    app.run(debug=True)
