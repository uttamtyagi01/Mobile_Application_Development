# Labsheet 10 — Firebase Auth + Cloud Firestore
Starter app with Firebase initialization, email/password registration/login/logout, auth-state switching, and Firestore student add/list/update/delete.

## Required setup
1. Create a Firebase project.
2. Configure FlutterFire with `flutterfire configure`.
3. Ensure `firebase_options.dart` is generated in `lib/`.
4. In Firebase Console, enable Authentication > Email/Password.
5. Create/enable Cloud Firestore and set appropriate development rules.
6. Run `flutter pub get` then `flutter run`.

For a real deployment, use secure Firestore rules and never rely on open test rules.
