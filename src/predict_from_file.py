import os
import cv2
from train_model import train_cnn
from load_data import load_dataset
import numpy as np


def predict_from_file(model, label_encoder, image_path, dataset_path, model_save_path, label_encoder_path):
    print("\n### Predicting from File ###")
    image = cv2.imread(image_path)
    if image is None:
        print("Error: Unable to read the image file.")
        return
    image_resized = cv2.resize(image, (128, 128)) / 255.0
    probabilities = model.predict(image_resized.reshape(1, 128, 128, 3))[0]
    predicted_class = label_encoder.inverse_transform(
        [np.argmax(probabilities)])[0]
    confidence = np.max(probabilities) * 100
    print(f"Prediction: {predicted_class} | Confidence: {confidence:.2f}%")

    # Append the image to the dataset
    class_dir = os.path.join(dataset_path, predicted_class)
    if not os.path.exists(class_dir):
        os.makedirs(class_dir)
    save_path = os.path.join(class_dir, os.path.basename(image_path))
    cv2.imwrite(save_path, image)
    print(f"Image saved to class directory: {class_dir}")

    # Retrain the model with the updated dataset
    print("\nRetraining the model with the updated dataset...")
    data, labels, _ = load_dataset(dataset_path)
    cnn_model, label_encoder = train_cnn(
        data, labels, model_save_path=model_save_path, label_encoder_path=label_encoder_path
    )
    print("Model retrained and updated successfully.")
