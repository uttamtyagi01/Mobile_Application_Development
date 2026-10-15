# LabSheet-10 — Q8 Add Firestore Student

**Question:** Add a student record to Cloud Firestore.

## Run
1. Open this folder as a Flutter project.
2. Configure Firebase for the target platform (see below).
3. Run `flutter pub get`, then `flutter run`.

## Firebase setup
Create a Firebase project and register the Android app using its exact application ID. Place `google-services.json` in `android/app/` and configure the Google Services Gradle plugin according to the current Firebase Flutter setup instructions. Enable Email/Password Authentication for Q2–Q7 and create a Cloud Firestore database for Q8–Q15. Configure secure Firestore rules before production use.

These are independent Flutter examples. Each folder has its own `lib/main.dart`; open and run one question at a time.
