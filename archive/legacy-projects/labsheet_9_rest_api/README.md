# Labsheet 9 — REST API and JSON
This app fetches posts from JSONPlaceholder using `http.get`, parses JSON into a model, shows a progress indicator, handles errors with retry, filters by title, supports pull-to-refresh, and opens a detail dialog.
Internet permission is normally present in the Flutter Android template; if requests fail, check `android/app/src/main/AndroidManifest.xml` contains `<uses-permission android:name="android.permission.INTERNET"/>` outside the application tag.
