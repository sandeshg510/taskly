# task_manager
Download apk : https://drive.google.com/file/d/1SVKdJlqQ6qMWpX6q1ZcJ_etHP_P_0rOi/view?usp=sharing

Taskly 
A flutter app created with standard practices of Clean Architecture and Test Driven Development.

Here I've used the followings :

Three layered architecture(Data-Domain-Presentation)
Bloc state management
Firebase
Cloud Firestore

Features:
User Authentication:
Implemented user registration and login using Firebase Authentication (email/password).
Displayed appropriate error messages for invalid credentials.

Task Management:
Users are able to create, edit, delete, and view tasks.
Each task have the following fields: title, description, due date, and priority (low, medium, high).
Tasks are stored on firebase_firestore as a backend.
Included a feature to mark tasks as complete/incomplete.

Task Filtering:
Provided the ability to filter tasks by priority and status (completed/incomplete).
Tasks are displayed in a list format, sorted by due date (earliest to latest).

User Interface:
Created a clean and responsive UI with Material Design principles.
the app is visually appealing on both iOS and Android devices (used appropriate padding, spacing, and colors)

![Welcome Screen](https://github.com/user-attachments/assets/d9009c3d-d272-49dc-bdf2-1245b2f8a497)

![Sign Up Screen](https://github.com/user-attachments/assets/6573719c-466a-48bd-903c-01954f89616d)

![Sign In Screen](https://github.com/user-attachments/assets/a8c32fa9-5adb-40b0-a188-687b09c0623c)

![Tasks Screen](https://github.com/user-attachments/assets/d22621e0-d536-44c8-ac2e-3b4f35428464)
