# Wolfera

Wolfera is a Flutter marketplace for buying and selling cars. The app delivers a smooth experience built around Supabase services and modern UI patterns.

## Core Features
- Browse curated car listings with rich photo galleries.
- Powerful search, filtering, and sorting to find the right vehicle fast.
- Secure authentication with email/password and Google Sign-In (Supabase Auth).
- Real-time chat between buyers and sellers for quick negotiations.
- Personal profile management including saved cars and preferences.
- Multilingual onboarding and localized UI for wider reach.

## Tech Stack
- Flutter (Dart) for cross-platform mobile development.
- Supabase for backend services, database, authentication, and storage.
- BLoC pattern for predictable state management.
- Google Maps, location, and media integrations for enhanced UX.

## Getting Started
```
flutter pub get
flutter run
```

## Build & Release
```
flutter build apk --release
flutter build appbundle --release
```

## Notes
- Configure Supabase keys and Google OAuth credentials via environment files before releasing.
- Production keystore details should remain private and excluded from version control.
