from sklearn.preprocessing import LabelEncoder


def preprocess_data(data, labels):
    data = data.astype('float32') / 255.0  # Normalize
    label_encoder = LabelEncoder()
    encoded_labels = label_encoder.fit_transform(labels)
    return data, encoded_labels, label_encoder
