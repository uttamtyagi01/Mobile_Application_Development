# LabSheet-10 — Firebase Authentication and Cloud Firestore

Each question folder is a separate Flutter project with a question-specific `lib/main.dart`, `pubspec.yaml`, and README.

## Setup
Configure Firebase for the Android/iOS app, enable Email/Password sign-in for authentication questions, and create a Cloud Firestore database for database questions. See each question README for steps.

## Questions
- `q1_firebase_connection` — Initialize Firebase and display Firebase Connected.
- `q2_register_user` — Register a new user with email and password using Firebase Authentication.
- `q3_login_user` — Log in an existing user with email and password.
- `q4_home_logout` — Display the signed-in email and provide logout.
- `q5_auth_error_snackbar` — Handle Firebase Authentication errors and show a SnackBar.
- `q6_password_reset` — Send a password reset email using sendPasswordResetEmail().
- `q7_auth_state_changes` — Switch between login and home states using authStateChanges().
- `q8_add_firestore_student` — Add a student record to Cloud Firestore.
- `q9_realtime_students` — Display student records in real time using snapshots().
- `q10_update_firestore_student` — Update an existing student record in Firestore.
- `q11_delete_firestore_student` — Delete a student record after confirmation.
- `q12_filter_course` — Filter students with a Firestore where() query by course.
- `q13_order_by_name` — Display student records ordered by name.
- `q14_firestore_notes` — Create, edit, list and delete notes in Cloud Firestore.
- `q15_firebase_student_management` — Manage student records with add, update, list and delete operations.
