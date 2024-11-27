from locust import HttpUser, task, between
import time



class FastAPILocust(HttpUser):
    wait_time=between(1,5)
    host = 'http://localhost:8089/'
    
    @task
    def predict_image_upload(self):
        self.client.post(url='/predict/upload')
        
    @task
    def retrain(self):
        self.client.post(url='/retrain')

    @task
    def predict_camera(self):
        self.client.get(url='/predict/camera')