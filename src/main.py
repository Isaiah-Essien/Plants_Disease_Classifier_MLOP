from fastapi import FastAPI, File, UploadFile
from tensorflow.keras.models import load_model
from load_data import load_dataset
from train_model import train_cnn
import joblib
import cv2
import numpy as np
import os
import sys

# Suppress TensorFlow warnings
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Initialize the FastAPI app
app = FastAPI()

# Paths
BASE_PATH = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_PATH, "models/cnn_model.h5")
ENCODER_PATH = os.path.join(BASE_PATH, "models/label_encoder.pkl")
DATASET_PATH = os.path.join(BASE_PATH, "dataset")

# Load the model and label encoder
try:
    cnn_model = load_model(MODEL_PATH, compile=False)
except Exception as e:
    raise RuntimeError(f"Failed to load model: {e}")

try:
    label_encoder = joblib.load(ENCODER_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load label encoder: {e}")

# Helper function for image prediction


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
async def train_model_endpoint():
    """
    Retrain the model with the existing dataset.
    """
    from main_pipeline import load_dataset, train_cnn
    data, labels, _ = load_dataset(DATASET_PATH)
    trained_model, encoder = train_cnn(
        data, labels, model_save_path=MODEL_PATH, label_encoder_path=ENCODER_PATH
    )
    return {"message": "Model trained successfully"}


@app.post("/predict/upload")
async def predict_from_upload(file: UploadFile = File(...)):
    """
    Predict the class of an uploaded image.
    """
    temp_dir = os.path.join(BASE_PATH, "temp")
    os.makedirs(temp_dir, exist_ok=True)
    image_path = os.path.join(temp_dir, file.filename)
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
    Capture a live image from the camera, save it, and predict its class.
    """
    cap = cv2.VideoCapture(0)
    try:
        if not cap.isOpened():
            return {"error": "Unable to access the camera"}
        ret, frame = cap.read()
        if not ret:
            return {"error": "Unable to read from the camera"}
        temp_image_path = os.path.join(BASE_PATH, "temp_camera_image.jpg")
        cv2.imwrite(temp_image_path, frame)
        result = predict_image(temp_image_path)
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

    try:
        # Save the uploaded file directly to a temporary file
        temp_dir = "temp"
        os.makedirs(temp_dir, exist_ok=True)
        image_path = os.path.join(temp_dir, file.filename)
        with open(image_path, "wb") as f:
            f.write(await file.read())

        # Read and preprocess the image
        image = cv2.imread(image_path)
        if image is None:
            return {"error": "Uploaded file is not a valid image"}

        image_resized = cv2.resize(image, (128, 128)) / 255.0

        # Predict the class
        probabilities = cnn_model.predict(
            image_resized.reshape(1, 128, 128, 3))[0]
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

        # Clean up temporary file
        os.remove(image_path)

        return {
            "predicted_class": predicted_class,
            "confidence": f"{confidence:.2f}%",
            "message": "Image added to dataset and model retrained successfully.",
        }

    except Exception as e:
        return {"error": str(e)}

