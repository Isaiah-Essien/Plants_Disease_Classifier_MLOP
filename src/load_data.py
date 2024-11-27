import os
import cv2
import numpy as np

def load_dataset(dataset_path, image_size=(128, 128)):
    data = []
    labels = []

    all_classes = [folder for folder in os.listdir(dataset_path) if os.path.isdir(os.path.join(dataset_path, folder))]

    # Separate healthy and disease classes
    disease_classes = [cls for cls in all_classes if "healthy" not in cls.lower()]
    healthy_classes = [cls for cls in all_classes if "healthy" in cls.lower()]

    print(f"Selected disease classes: {disease_classes}")
    print(f"Selected healthy classes: {healthy_classes}")

    for class_name in disease_classes + healthy_classes:
        class_dir = os.path.join(dataset_path, class_name)
        class_images = [os.path.join(class_dir, img_name) for img_name in os.listdir(class_dir)]

        for img_path in class_images:
            image = cv2.imread(img_path)
            if image is None:
                print(f"Warning: Unable to load image: {img_path}")
                continue

            # Resize and add to dataset
            image = cv2.resize(image, image_size)
            data.append(image)
            labels.append(class_name)

    print(f"\nLoaded {len(data)} images.")
    return np.array(data), np.array(labels), disease_classes + healthy_classes
