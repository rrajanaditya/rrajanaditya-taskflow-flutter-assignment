# TaskFlow: Flutter Firebase To-Do Application

> A robust, responsive task management application built with Flutter, Firebase Authentication, and the Firebase Realtime Database REST API.

## Project Overview
This project was developed to demonstrate modern Flutter development practices, including domain-driven feature architecture, robust state management, and direct REST API integration with Firebase.

## Key Features
- **Authentication:** Secure user sign-up and login via Firebase Authentication (Email/Password) and Google Sign-In support.
- **Task Management (CRUD):** Create, read, update, and delete tasks dynamically.
- **REST API Integration:** Interacts with Firebase Realtime Database exclusively through standard HTTP requests, attaching Auth ID Tokens for security.
- **State Management:** Utilizes the `provider` package for predictable, scalable state handling.
- **Adaptive UI:** Built with Material 3 design standards, featuring a fully responsive layout and seamless Light/Dark mode transitions based on system preferences.
- **Error Handling:** Graceful interception of authentication exceptions and API failures with user-friendly error boundaries.

## Architecture Structure
The codebase follows a Feature-First (Domain-Driven) architecture for scalability:
```text
lib/
├── core/               # Shared utilities and constants
├── features/
│   ├── auth/
│   │   ├── providers/  # Authentication state and logic
│   │   └── views/      # Login and Sign-up UI
│   └── todos/
│       ├── models/     # Data models and JSON serialization
│       ├── providers/  # REST API logic and task state
│       └── views/      # List and task creation UI
└── main.dart           # Application entry point
```

## Technical Stack
- **Framework:** Flutter (Dart)
- **Backend:** Firebase Auth, Firebase Realtime Database
- **State Management:** Provider
- **Networking:** HTTP (REST)

## Installation & Setup
1. Clone the repository:
```bash
git clone <YOUR_REPOSITORY_URL>
cd todo_firebase_app
```
2. Install dependencies:
```bash
flutter pub get
```
3. Configure Firebase:
- Create a Firebase project and enable Authentication and Realtime Database.
- Update the database URL in `lib/features/todos/providers/todo_provider.dart`.
- Place your generated `google-services.json` file in the `android/app/` directory.

4. Run the application:
```bash
flutter run
```
