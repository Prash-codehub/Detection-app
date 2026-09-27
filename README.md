# Snack Spotter (Detection App)

A real-time snack detection Flutter application using YOLO (Ultralytics). This app can detect snacks using your device's camera.

## Features
- Real-time object detection using the camera.
- Powered by `ultralytics_yolo`.
- Easy to configure with your own YOLO models and data.

## Requirements
- Flutter SDK (^3.7.0)
- Android Studio or Xcode (for iOS)
- A physical device (camera access is required for real-time detection)

## Where to Place the Model and Data Files

To run the app properly, you need to provide the pre-trained model and the data YAML/labels file. Place them in the following directories:

1. **Model File**: 
   Place your model file (e.g., `best.pt`, `best_int8.tflite`, etc.) inside the `assets/models/` directory.
   - Path: `assets/models/`

2. **Data YAML / Labels File**:
   Place your data YAML file (e.g., `data.yaml`) or your labels text file (e.g., `labels.txt`) directly in the `assets/` directory.
   - Path: `assets/`

*Note: If you add new files or change their names, make sure to update the `pubspec.yaml` under the `flutter: assets:` section so Flutter can bundle them into the app.*

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/Prash-codehub/Detection-app.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application on a connected device:
   ```bash
   flutter run
   ```
