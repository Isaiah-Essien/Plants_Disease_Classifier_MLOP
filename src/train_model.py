from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow.keras.utils import to_categorical
from sklearn.metrics import ConfusionMatrixDisplay
import matplotlib.pyplot as plt
import joblib
from build_model import build_cnn
import numpy as np
from preprocess import preprocess_data


def train_cnn(data, labels, model_save_path=None, label_encoder_path=None):
    # Preprocess Data
    data, encoded_labels, label_encoder = preprocess_data(data, labels)
    num_classes = len(np.unique(encoded_labels))
    X_train, X_test, y_train, y_test = train_test_split(
        data, encoded_labels, test_size=0.25, stratify=encoded_labels)

    # Convert to categorical
    y_train_onehot = to_categorical(y_train, num_classes=num_classes)
    y_test_onehot = to_categorical(y_test, num_classes=num_classes)

    # Build model
    model = build_cnn(X_train.shape[1:], num_classes)

    # Train model
    early_stopping = EarlyStopping(
        monitor='val_loss', patience=2, restore_best_weights=True, verbose=1)
    history = model.fit(
        X_train, y_train_onehot,
        validation_data=(X_test, y_test_onehot),
        epochs=50,
        batch_size=32,
        callbacks=[early_stopping]
    )

    # Evaluate Model
    predictions = np.argmax(model.predict(X_test), axis=1)
    accuracy = accuracy_score(y_test, predictions)
    print(f"CNN Accuracy: {accuracy:.4f}")
    print("\nClassification Report:")
    print(classification_report(y_test, predictions,
          target_names=label_encoder.classes_))

    # Confusion Matrix Visualization
    cm = confusion_matrix(y_test, predictions)
    disp = ConfusionMatrixDisplay(
        confusion_matrix=cm, display_labels=label_encoder.classes_)
    plt.figure(figsize=(12, 12))
    disp.plot(cmap=plt.cm.Blues, colorbar=True)
    plt.title('Confusion Matrix')
    plt.xticks(rotation=45)
    plt.show()

    plt.figure(figsize=(12, 6))
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'], label='Train Accuracy')
    plt.plot(history.history['val_accuracy'], label='Val Accuracy')
    plt.title('Accuracy')
    plt.legend()
    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'], label='Train Loss')
    plt.plot(history.history['val_loss'], label='Val Loss')
    plt.title('Loss')
    plt.legend()
    plt.show()

    # Save the model
    if model_save_path:
        model.save(model_save_path)

    # Save the label encoder
    if label_encoder_path:
        joblib.dump(label_encoder, label_encoder_path)
        print(f"Label encoder saved to: {label_encoder_path}")

    return model, label_encoder
