import logging
from fastapi import FastAPI, File, UploadFile, Request
from tensorflow.keras.models import load_model
from load_data import load_dataset
from train_model import train_cnn
import joblib
import cv2
import numpy as np
import os
import sys
import time

os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Initialize the FastAPI app
app = FastAPI()

# Paths
MODEL_PATH = os.path.join(os.path.dirname(__file__), "models/cnn_model.h5")
ENCODER_PATH = os.path.join(os.path.dirname(
    __file__), "models/label_encoder.pkl")
DATASET_PATH = os.path.join(os.path.dirname(__file__), "dataset")


# Load the model and label encoder with error handling
try:
    cnn_model = load_model(MODEL_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load model: {e}")

try:
    label_encoder = joblib.load(ENCODER_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load label encoder: {e}")


# Middleware for Logging and Monitoring

logger = logging.getLogger("uvicorn")
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    latency = time.time() - start_time
    logger.info(
        f"Endpoint: {request.url.path}, Method: {request.method}, Latency: {latency:.2f}s")
    return response



# Helper function for prediction
def predict_image(image_path):
    image = cv2.imread(image_path)
    if image is None:
        return {"error": "Uploaded file is not a valid image"}
    image_resized = cv2.resize(image, (128, 128)) / 255.0
    probabilities = cnn_model.predict(image_resized.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100
    return {"class": predicted_class, "confidence": confidence}


@app.post("/train")
async def train_model():
    """
    Retrain the model with the existing dataset.
    """
    from main_pipeline import load_dataset, train_cnn
    data, labels, _ = load_dataset(DATASET_PATH)
    trained_model, encoder = train_cnn(
        data, labels, model_save_path=MODEL_PATH, label_encoder_path=ENCODER_PATH)
    return {"message": "Model trained successfully"}


@app.post("/predict/upload")
async def predict_from_upload(file: UploadFile = File(...)):
    """
    Predict the class of an uploaded image.
    """
    os.makedirs("temp", exist_ok=True)
    image_path = os.path.join("temp", file.filename)
    with open(image_path, "wb") as f:
        f.write(await file.read())
    try:
        result = predict_image(image_path)
    finally:
        os.remove(image_path)
    return result


@app.get("/predict/camera")
async def predict_from_camera():
    """
    Captures a live image from the camera, saves it, and predicts its class.
    """
    cap = cv2.VideoCapture(0)
    try:
        if not cap.isOpened():
            return {"error": "Unable to access the camera"}
        ret, frame = cap.read()
        if not ret:
            return {"error": "Unable to read from the camera"}

        # Save the captured frame as an image
        temp_image_path = "temp_camera_image.jpg"
        cv2.imwrite(temp_image_path, frame)

        # Predict the captured image's class
        result = predict_image(temp_image_path)

        # Clean up
        os.remove(temp_image_path)
        return result
    finally:
        cap.release()


@app.post("/retrain")
async def retrain_with_uploaded_file(file: UploadFile = File(...)):
    """
    Upload a new image, predict its class, append it to the dataset, and retrain the model.
    """
    global cnn_model, label_encoder

    # Save the uploaded file directly to memory
    image_data = await file.read()

    # Decode the image using OpenCV
    nparr = np.frombuffer(image_data, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    if image is None:
        return {"error": "Uploaded file is not a valid image"}

    # Preprocess the image
    image_resized = cv2.resize(image, (128, 128)) / 255.0

    # Predict the class
    probabilities = cnn_model.predict(image_resized.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100

    # Append the image to the predicted class folder
    class_dir = os.path.join(DATASET_PATH, predicted_class)
    os.makedirs(class_dir, exist_ok=True)
    save_path = os.path.join(class_dir, file.filename)
    cv2.imwrite(save_path, image)

    # Retrain the model with the updated dataset
    data, labels, _ = load_dataset(DATASET_PATH)
    cnn_model, label_encoder = train_cnn(
        data, labels, model_save_path=MODEL_PATH, label_encoder_path=ENCODER_PATH
    )

    # Return the response
    return {
        "predicted_class": predicted_class,
        "confidence": f"{confidence:.2f}%",
        "message": "Image added to dataset and model retrained successfully."
    }
    

