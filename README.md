# Flutter To-Do List App

A mobile To-Do List application built with Flutter that allows users to manage tasks efficiently, set reminders, and view tasks by category. The app supports Firebase authentication, user-based task separation, and local notifications.

## Features

### User Authentication
- Login with email and password using Firebase Auth.
- Each user has their own tasks stored separately.
- Logout functionality.

### Task Management
- Add, edit, and delete tasks.
- Assign tasks to categories: Kuliah, Pribadi, Kerja, Umum.
- Set task priority: Low, Medium, High.
- Mark tasks as done/not done.
- Reorder tasks via drag-and-drop.
  
### Category & Filter
- Filter tasks by category using ChoiceChips.
- Filter tasks by status: All, Done, Not Done.

### Reminders
- Schedule notifications for tasks at specific dates and times.
- Local notifications handled via NotificationService.

### Theme Support
- Switch between light and dark themes.
- Theme persists throughout the app.

### Firebase Integration
- Firebase Auth for user login.
- Tasks can be synced to Firebase (optional if implementing cloud storage).

## Screenshots
### Homepage
<img width="270" height="600" alt="Screenshot_20260115_141913" src="https://github.com/user-attachments/assets/09844176-48ad-49af-9e19-fc06b3097dbd" />

### Add & Edit Task Page
<img width="270" height="600" alt="Screenshot_20260115_141957" src="https://github.com/user-attachments/assets/baf6853b-cb7d-4806-8e07-97b5b6666d5a" />

### Login Page
<img width="270" height="600" alt="Screenshot_20260115_142015" src="https://github.com/user-attachments/assets/897f2117-7efe-468e-b460-0b78b0dd2c71" />

### Category Filter View
<img width="270" height="600" alt="Screenshot_20260115_141716" src="https://github.com/user-attachments/assets/88ec7bd7-c123-4570-8c6b-70a7736aa8d8" />

### View Based on Task Completion
<img width="270" height="600" alt="Screenshot_20260115_141926" src="https://github.com/user-attachments/assets/6e6e295b-1e5d-4f36-9ca1-8653e553c63a" />

### Dark & Light Mode
<img width="270" height="600" alt="Screenshot_20260115_141913" src="https://github.com/user-attachments/assets/09844176-48ad-49af-9e19-fc06b3097dbd" />
<img width="270" height="600" alt="Screenshot_20260115_142527" src="https://github.com/user-attachments/assets/3c05cd06-ee5b-4163-8114-2a8d3e5a1fb1" />


## Getting Started

### Prerequisites
- Flutter >= 3.x
- Dart >= 3.x
- Android Studio / VS Code
- Firebase project (for authentication)
- Node.js (for Firebase CLI if using FlutterFire)

## Installation
1. Clone this repo:
```
git clone https://github.com/yourusername/finalproject_mp.git
cd finalproject_mp
```

2. Install dependencies:
```
flutter pub get
```

3. Configure Firebase:
```
flutterfire configure

```
Note: Make sure to place the google-services.json file in android/app/.

4. Run the app:
```
flutter run
```

## Project Structure
```
lib/
├─ main.dart              # Entry point
├─ models/
│  └─ task.dart           # Task model
├─ pages/
│  ├─ home_page.dart      # Main task view
│  ├─ add_edit_task_page.dart  # Add/Edit Task
│  └─ login_page.dart     # Firebase login page
├─ services/
│  ├─ local_storage.dart  # Local task persistence
│  └─ notification_service.dart # Scheduling notifications
```


