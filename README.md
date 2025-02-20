# Description
This is a Flutter application that fetches posts from the JSONPlaceholder API
(https://jsonplaceholder.typicode.com/posts) and displays them in a scrollable list as described from the test requirements.
# Flutter Project Setup Guide

## Prerequisites
Ensure you have the following installed on your system:
- **Flutter SDK** ([Download](https://flutter.dev/docs/get-started/install))
- **Git** ([Download](https://git-scm.com/downloads))
- **Android Studio** or **VS Code** (Optional but recommended)
- **Android Emulator** or **Physical Device** (For running the app)

---

## Setup Instructions

### 1. Clone the Repository
Run the following command in your terminal:

```sh
git clone https://github.com/bettkipronoh/test-bett-senior-flutter-engineer.git
```

### 2. Navigate to the Project Directory
```sh
cd test-bett-senior-flutter-engineer
```

### 3. Verify Flutter Setup
Check if Flutter is correctly installed:
```sh
flutter doctor
```

### 4. Install Dependencies
```sh
flutter pub get
```
### 5. Connect a Device or Start an Emulator
- To run on a **physical device**, enable **USB debugging** (Android) or set up your device with Xcode (iOS).
- To run on an **emulator**, open **Android Studio** or **VS Code** and start an emulator.
- List available devices:
  ```sh
  flutter devices
  ```

### 6. Run the Flutter App
```sh
flutter run
```
If multiple devices are connected, specify the device ID:
```sh
flutter run -d <device_id>
```

- If using **iOS**, ensure **CocoaPods** is installed and run:
  ```sh
  cd ios
  pod install
  cd ..
  ```
### To test this app without running the project, here is the link to download the apk
- **Flutter SDK** ([Download](https://drive.google.com/file/d/1rItCc4tzKtSJAaWZK6KP0xBxuMKmmJ8B/view?usp=sharing))
### 🎉 Your Flutter project is now ready to run! 🚀
