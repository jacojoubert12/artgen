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

        # image_urls = []
        # for i in r:
        #     image = Image.open(io.BytesIO(base64.b64decode(i.split(",",1)[0])))
        #     image_bytes = io.BytesIO()
        #     image.save(image_bytes, format='JPEG')
        #     image_bytes.seek(0)
        #     # Generate a unique ID for the image
        #     image_id = str(uuid.uuid1())
        #     # Create a new blob in the 'images' bucket with the ID
        #     blob = self.storage.blob(f'images/{image_id}')
        #     # Upload the image data to the blob
        #     blob.upload_from_file(image_bytes)
        #     # Get the public URL of the image
        #     image_url = blob.public_url
        #     image_urls.append(image_url)


            # file_path = "sample_image_file.jpg"
            # bucket = storage.bucket() # storage bucket
            # blob = bucket.blob(file_path)
            # blob.upload_from_filename(file_path)

        # return filenames

if __name__ == '__main__':
    fbc = FirebaseClient()



#Delete all inactive anonamous user
# import firebase_admin
# from firebase_admin import auth
# from firebase_admin import firestore
# from datetime import datetime, timedelta

# def delete_inactive_anonymous_users():
#     now = datetime.utcnow()
#     week_ago = now - timedelta(days=7)
#     users = auth.list_users().iterate_all()
#     for user in users:
#         if user.last_sign_in_time and user.provider_data[0].provider_id == 'anonymous':
#             last_sign_in_time = datetime.fromtimestamp(user.last_sign_in_time / 1000)
#             if last_sign_in_time < week_ago:
#                 auth.delete_user(user.uid)

# firebase_admin.initialize_app()
# delete_inactive_anonymous_users()
