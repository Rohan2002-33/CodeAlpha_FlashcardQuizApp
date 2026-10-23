# CodeAlpha_FlashcardQuizApp

Flashcard quiz mobile app built with **Flutter** for the **CodeAlpha App Development Internship – Task 1**.

## Features
- Flashcard with **question on front** and **answer on back** (flip animation)
- **Show Answer / Hide Answer** button
- **Next** and **Previous** navigation with progress bar
- **Add, edit and delete** flashcards (delete has Undo)
- Search cards in library
- Data saved on device (survives app restart)
- Light / Dark / System theme
- Clean Material 3 UI

## Screens
Splash · Study · Library · Add/Edit Card · Settings

## Tech
- Flutter + Dart
- State management: `provider`
- Local storage: `shared_preferences`

## Project structure
```
lib/
  models/      flashcard.dart
  services/    storage_service.dart
  providers/   flashcard_provider.dart, settings_provider.dart
  theme/       app_theme.dart
  widgets/     flip_card.dart, empty_state.dart, confirm_dialog.dart
  screens/     splash, home_shell, study, library, card_form, settings
  main.dart
```

## Run locally
```bash
git clone https://github.com/Rohan2002-33/CodeAlpha_FlashcardQuizApp.git
cd CodeAlpha_FlashcardQuizApp
flutter pub get
flutter run
```

## Build APK
```bash
flutter build apk --release
```
APK path: `build/app/outputs/flutter-apk/app-release.apk`

## Author
YOUR NAME – Mahir Ahamed Rohan