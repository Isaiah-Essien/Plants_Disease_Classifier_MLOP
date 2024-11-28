from fastapi import FastAPI, File, UploadFile
from tensorflow.keras.models import load_model
from load_data import load_dataset
from train_model import train_cnn
import joblib
import cv2
import numpy as np
import os
import sys
from fastapi.middleware.cors import CORSMiddleware

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Initialize the FastAPI app
app = FastAPI()

# CORS middleware for allowed origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Paths
BASE_PATH = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_PATH, "models/cnn_model.h5")
ENCODER_PATH = os.path.join(BASE_PATH, "models/label_encoder.pkl")
DATASET_PATH = os.path.join(BASE_PATH, "dataset")

# Load the model and label encoder
cnn_model = load_model(MODEL_PATH, compile=False)
label_encoder = joblib.load(ENCODER_PATH)


def preprocess_image(image_bytes, target_size=(128, 128)):
    """
    Preprocess image data from bytes.
    """
    image = cv2.imdecode(np.frombuffer(
        image_bytes, np.uint8), cv2.IMREAD_COLOR)
    if image is None:
        return None
    image_resized = cv2.resize(image, target_size) / 255.0
    return image_resized


@app.post("/predict/upload")
async def predict_from_upload(file: UploadFile = File(...)):
    """
    Predict the class of an uploaded image.
    """
    image_bytes = await file.read()
    preprocessed_image = preprocess_image(image_bytes)

    if preprocessed_image is None:
        return {"error": "Uploaded file is not a valid image"}

    # Predict the class
    probabilities = cnn_model.predict(
        preprocessed_image.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100

    return {
        "prediction": {
            "class": predicted_class,
            "confidence": f"{confidence:.2f}%",
        }
    }


@app.post("/retrain")
async def retrain_with_uploaded_file(file: UploadFile = File(...)):
    """
    Upload a new image, predict its class, append it to the dataset, and retrain the model.
    """
    global cnn_model, label_encoder

    # Save the uploaded file to a temporary file
    image_bytes = await file.read()
    preprocessed_image = preprocess_image(image_bytes)

    if preprocessed_image is None:
        return {"error": "Uploaded file is not a valid image"}

    # Predict the class
    probabilities = cnn_model.predict(
        preprocessed_image.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100

    # Append the image to the predicted class folder
    class_dir = os.path.join(DATASET_PATH, predicted_class)
    os.makedirs(class_dir, exist_ok=True)
    file_path = os.path.join(class_dir, file.filename)

    # Save the file
    with open(file_path, "wb") as f:
        f.write(image_bytes)

    # Retrain the model with the updated dataset
    data, labels, _ = load_dataset(DATASET_PATH)
    cnn_model, label_encoder = train_cnn(
        data, labels, model_save_path=MODEL_PATH, label_encoder_path=ENCODER_PATH
    )

    return {
        "predicted_class": predicted_class,
        "confidence": f"{confidence:.2f}%",
        "message": "Image added to dataset and model retrained successfully.",
    }


@app.get("/predict/camera")
async def predict_from_camera():
    """
    Capture a live image from the camera, save it, and predict its class.
    """
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        return {"error": "Unable to access the camera"}

    ret, frame = cap.read()
    cap.release()

    if not ret:
        return {"error": "Unable to read from the camera"}

    frame_resized = cv2.resize(frame, (128, 128)) / 255.0
    probabilities = cnn_model.predict(frame_resized.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100

    return {
        "prediction": {
            "class": predicted_class,
            "confidence": f"{confidence:.2f}%",
        }
    }


@app.post("/train")
async def train_model_endpoint():
    """
    Retrain the model with the existing dataset.
    """
    data, labels, _ = load_dataset(DATASET_PATH)
    train_cnn(data, labels, model_save_path=MODEL_PATH,
              label_encoder_path=ENCODER_PATH)
    return {"message": "Model trained successfully"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
