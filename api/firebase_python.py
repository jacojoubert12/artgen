import firebase_admin
# from firebase_admin import db
from firebase_admin import storage
from firebase_admin import credentials
from firebase_admin import firestore

from PIL import Image, PngImagePlugin
import io
import base64
import requests
import uuid
import time

class FirebaseClient:
    def __init__(self):

        cred = credentials.Certificate("artgen-66569-firebase-adminsdk-lsnbw-ff55e7971b.json")
        # firebase_admin.initialize_app(cred)
        self.app = firebase_admin.initialize_app(cred, options={
            # 'databaseURL': 'https://artgen-66569-default-rtdb.firebaseio.com/',
            'storageBucket': 'image_gen_requests'
        })

        # self.db = db.reference()
        self.db = firestore.client()
        self.storage = storage.bucket()
        self.id = str(uuid.uuid1())
        self.register_client()
        self.listen_for_requests()


    def register_client(self):
        #subsribe to shared topic

        pass

        # client_ref = self.db.child('image_gen_clients').child(self.id)
        # client_ref.set(True)

    def listen_for_requests(self):
        #handle incomming messages

        # doc_ref = self.db.collection('image_gen_requests').document('queue_sizes')
        # doc_ref.set({  #set overwrite the whole document

        #     'anythingv3': 0,
        #     # 'lname':'Doe',
        #     # 'email':'john@gmail.com',
        #     # 'age':24


        # },merge= True)

        queusize_ref = self.db.collection(u'image_gen_requests').document(u'queue_sizes')

        queusize_ref.update({"total": firestore.Increment(1), "anythingv3": firestore.Increment(1),"f222": firestore.Increment(1)})
        # queusize_ref.update({"f222": firestore.Increment(1)})
        pass

    def process_request(self, request):
        print(request)
        # data = request.get_json()
        # prompt = data['prompt']
        # negprompt = data['negprompt']
        # steps = data['steps']
        # guidance = data['guidance']
        # width = data['width']
        # height = data['height']
        # batch_size = data['batch_size']

        # self.generate_image(prompt, negprompt, steps, guidance, width, height, batch_size)

    def getServerURL(self, dmodel, speed):
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

    def generate_image(self, prompt, negprompt, steps, guidance, width, height, batch_size, batch_count=1, dmodel='sd', speed=0):

        url = self.getServerURL(dmodel, speed)

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
        image_urls = []
        for i in r:
            image = Image.open(io.BytesIO(base64.b64decode(i.split(",",1)[0])))
            image_bytes = io.BytesIO()
            image.save(image_bytes, format='JPEG')
            image_bytes.seek(0)
            # Generate a unique ID for the image
            image_id = str(uuid.uuid1())
            # Create a new blob in the 'images' bucket with the ID
            blob = self.storage.blob(f'images/{image_id}')
            # Upload the image data to the blob
            blob.upload_from_file(image_bytes)
            # Get the public URL of the image
            image_url = blob.public_url
            image_urls.append(image_url)


            # file_path = "sample_image_file.jpg"
            # bucket = storage.bucket() # storage bucket
            # blob = bucket.blob(file_path)
            # blob.upload_from_filename(file_path)

        # return filenames

if __name__ == '__main__':
    fbc = FirebaseClient()
