import matplotlib.pyplot as plt
# Data Exploration and Visualization
def explore_data(data, labels, label_encoder):
    print("\n### Data Exploration and Visualization ###")

    # 1. Plot class distribution
    unique_classes, counts = np.unique(labels, return_counts=True)
    class_names = label_encoder.inverse_transform(unique_classes)
    plt.figure(figsize=(10, 5))
    plt.bar(class_names, counts, color="teal")
    plt.title("Class Distribution")
    plt.xlabel("Classes")
    plt.ylabel("Number of Samples")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.show()

    # 2. Show sample images
    plt.figure(figsize=(12, 12))
    # Display first 4 classes
    for i, class_name in enumerate(unique_classes[:4]):
        class_indices = np.where(labels == class_name)[
            0][:4]  # Get up to 4 images per class
        for j, idx in enumerate(class_indices):
            plt.subplot(4, 4, i * 4 + j + 1)
            plt.imshow(data[idx])
            plt.axis("off")
            plt.title(label_encoder.inverse_transform([class_name])[0])
    plt.suptitle("Sample Images by Class", fontsize=16)
    plt.tight_layout()
    plt.show()

    # 3. Average image for each class
    plt.figure(figsize=(12, 6))
    # Show average for first 4 classes
    for i, class_name in enumerate(unique_classes[:4]):
        class_indices = np.where(labels == class_name)[0]
        average_image = np.mean(data[class_indices], axis=0).astype("uint8")
        plt.subplot(1, 4, i + 1)
        plt.imshow(average_image)
        plt.axis("off")
        plt.title(f"Avg: {label_encoder.inverse_transform([class_name])[0]}")
    plt.suptitle("Average Image by Class", fontsize=16)
    plt.tight_layout()
    plt.show()
