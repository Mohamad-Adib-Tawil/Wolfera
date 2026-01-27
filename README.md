# Wolfera

A professional Flutter marketplace for buying and selling cars. Wolfera delivers a modern UI, fast discovery, secure authentication, localization, notifications, and a Supabase-powered backend.

---

## Features

- 🚗 Curated car listings with rich photos and details
- 🔎 Search, filter, and sort to find the right vehicle
- 🔐 Auth with email/password and Google Sign-In (Supabase Auth)
- 💬 Real-time chat between buyers and sellers
- 🌐 Full localization via EasyLocalization
- 🔔 Push notifications for key events (e.g., price changes)
- 🧰 Profiles, favorites, and saved cars
- 🖼️ Camera/gallery uploads with compression

---

## Technology Stack

- Framework: Flutter (Dart)
- Backend: Supabase (Database, Auth, Storage, Realtime)
- State Management: BLoC
- Auth: google_sign_in, Supabase OAuth
- Notifications: firebase_core, firebase_messaging
- Localization: easy_localization
- Media/UI: cached_network_image, image_picker, flutter_svg, lottie

---

## Installation

### Prerequisites
- Flutter SDK (stable)
- Dart SDK
- Android Studio or VS Code with Flutter plugin
- For iOS builds: macOS + Xcode

### Steps
1) Install dependencies
```bash
flutter pub get
```

2) Configure environment (choose ONE)
- Option A: Runtime variables via --dart-define
```bash
flutter run \
  --dart-define=SUPABASE_URL=YOUR_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY \
  --dart-define=GOOGLE_IOS_CLIENT_ID=YOUR_IOS_CLIENT_ID \
  --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID
```
- Option B: Local config file (dev only)
  - Copy `lib/core/config/supabase_config.dart.example` to `lib/core/config/supabase_config.dart`
  - Fill values for URL/anon key and optional Google web client ID

3) iOS notes
- Bundle ID: `com.wolfera.wolfera`
- Ensure `ios/Runner/GoogleService-Info.plist` is added as required
- Ensure `GIDClientID` is set in `ios/Runner/Info.plist` for Google Sign-In

4) Run
```bash
flutter run
```

---

## Screenshots

Preview (scaled thumbnails).

<div align="center">
<table>
  <tr>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.50.24 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.50.24 PM" /></td>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.50.45 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.50.45 PM" /></td>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.50.58 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.50.58 PM" /></td>
  </tr>
  <tr>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.51.11 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.51.11 PM" /></td>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.51.22 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.51.22 PM" /></td>
    <td><img src="screenshots/Screenshot 2026-01-27 at 10.51.57 PM.png" width="260" alt="Screenshot 2026-01-27 at 10.51.57 PM" /></td>
  </tr>
</table>
</div>

> Full gallery: [doc/GALLERY.md](doc/GALLERY.md)

---

## Build & Release

```bash
flutter build apk --release
flutter build appbundle --release
```

## Notes

- Configure Supabase keys and Google OAuth credentials via environment before releasing.
- Keep production signing keys private and out of version control.
