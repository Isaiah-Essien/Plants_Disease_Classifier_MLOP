from load_data import load_dataset
from train_model import train_cnn
from predict_from_file import predict_from_file
from predict_from_camera import predict_from_camera


if __name__ == "__main__":
    # Define paths
    dataset_path = r"C:\Users\hp\OneDrive\Desktop\Plants_Disease_Classifier_MLOP\dataset"
    model_save_path = r"C:\Users\hp\OneDrive\Desktop\Plants_Disease_Classifier_MLOP\models\cnn_model.h5"
    label_encoder_path = r"C:\Users\hp\OneDrive\Desktop\Plants_Disease_Classifier_MLOP\models\label_encoder.pkl"
    test_image_path = r"C:\Users\hp\Downloads\test_leaf.jpg"

    # Load dataset
    data, labels, _ = load_dataset(dataset_path)

    # Train model and save label encoder
    cnn_model, label_encoder = train_cnn(
        data, labels, model_save_path=model_save_path, label_encoder_path=label_encoder_path
    )

    # Predict from a test image and update the model
    predict_from_file(
        cnn_model, label_encoder, test_image_path, dataset_path, model_save_path, label_encoder_path
    )

    # Predict from live camera and update the model
    predict_from_camera(
        cnn_model, label_encoder, dataset_path, model_save_path, label_encoder_path
    )
