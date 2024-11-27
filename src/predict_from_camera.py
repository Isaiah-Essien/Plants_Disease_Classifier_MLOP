import os
import cv2
from load_data import load_dataset
from train_model import train_cnn
import numpy as np


def predict_from_camera(model, label_encoder, dataset_path, model_save_path, label_encoder_path):
    print("\n### Predicting from Live Camera ###")
    cap = cv2.VideoCapture(0)
    if not cap.isOpened():
        print("Error: Unable to access the camera.")
        return
    print("Press 'q' to capture an image and make a prediction.")

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Error: Unable to read from the camera.")
            break

        cv2.imshow("Live Camera - Press 'q' to Capture", frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            cap.release()
            cv2.destroyAllWindows()
            image_resized = cv2.resize(frame, (128, 128)) / 255.0
            probabilities = model.predict(
                image_resized.reshape(1, 128, 128, 3))[0]
            predicted_class = label_encoder.inverse_transform(
                [np.argmax(probabilities)])[0]
            confidence = np.max(probabilities) * 100
            print(f"Prediction: {predicted_class} | Confidence: {
                  confidence:.2f}%")

            # Save the image to the appropriate class folder
            class_dir = os.path.join(dataset_path, predicted_class)
            if not os.path.exists(class_dir):
                os.makedirs(class_dir)
            save_path = os.path.join(class_dir, "captured_image.jpg")
            cv2.imwrite(save_path, frame)
            print(f"Image saved to class directory: {class_dir}")

            # Retrain the model with the updated dataset
            print("\nRetraining the model with the updated dataset...")
            data, labels, _ = load_dataset(dataset_path)
            cnn_model, label_encoder = train_cnn(
                data, labels, model_save_path=model_save_path, label_encoder_path=label_encoder_path
            )
            print("Model retrained and updated successfully.")
            break
