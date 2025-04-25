# Task Manager

Task Manager is a minimalist productivity app designed to help you stay focused, organized, and motivated. Built with **Flutter** and powered by **Firebase**, it offers a seamless experience with **shared preferences** for session management and **provider** for state management. Featuring two core screens—**Today's Tasks** and **Daily Tasks**—along with a motivational widget and in-app lecture video access, Task Manager is your go-to tool for achieving goals.

<br>
<img src="https://github.com/user-attachments/assets/d4c822e5-1d82-4d0b-b3cf-00ae2ecbda48" alt="Today's Tasks Screen" width="400"/>
<img src="https://github.com/user-attachments/assets/25e37afa-23bb-4082-8ddd-720b91004a08" alt="Daily Tasks Screen" width="400"/>

## Features

- **Clear Task Management**: Intuitive interface for managing tasks efficiently.
- **Streak Tracking**: Build momentum with daily streak monitoring.
- **In-App Lecture Videos**: Watch study materials directly within the app.

## Screenshots
<br>
<img src="https://github.com/user-attachments/assets/06ebbed5-792f-4ba3-9165-6ceb3522e575" alt="Today's Tasks Screen" width="400"/>
<img src="https://github.com/user-attachments/assets/ecca574e-73fa-4d4c-aba1-e32d8e17aa42" alt="Daily Tasks Screen" width="400"/>
<img src="https://github.com/user-attachments/assets/97f30bbf-96fa-4e9d-a1d4-83af1159128b" alt="Motivational Widget" width="400"/>

<br>
## Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.0.0 or higher)
- [Dart](https://dart.dev/get-dart) (v2.17.0 or higher)
- [Firebase Account](https://firebase.google.com/)
- IDE (e.g., VS Code, Android Studio)

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/task-manager.git
   ```
2. **Navigate to the project directory**:
   ```bash
   cd task-manager
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
task-manager/
├── android/                # Android-specific files
├── ios/                    # iOS-specific files
├── lib/                    # Main Flutter source code
│   ├── models/             # Data models
│   ├── providers/          # State management with Provider
│   ├── view/            # UI screens (Today's Tasks, Daily Tasks)
│   └── main.dart           # App entry point
├── assets/                 # Images, fonts, and other static assets
├── pubspec.yaml            # Flutter dependencies
└── README.md               # Project documentation
```

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication)
- **State Management**: Provider
- **Session Management**: Shared Preferences
- **Language**: Dart

