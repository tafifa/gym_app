# FitTrack Gym Application

A modern, robust Gym application built with Flutter following the **Clean Architecture (Feature-First)** design pattern. This app comes packed with local database storage, state management, push notifications, OTA updates, QR code scanning, and environment management.

---

## 🎯 Features

- **Google Login (Mock):** A simple login interface acting as the entry point to the application.
- **QR Code Check-in:** Uses the device camera to scan QR codes for gym check-ins.
- **Workout Dashboard:** Browse workout programs and exercises.
- **Workout History:** Logs completed workouts and sessions.
- **Settings & Environment:** Configurable environments (Production, Staging, Test, Test Local) directly from the settings page.
- **Debug vs Release Separations:** The app is configured with separate App Names and Application IDs for Debug (`.dev`) and Release builds, allowing simultaneous installations.

---

## 🛠️ Tech Stack & Packages

This application utilizes modern and industry-standard packages for maximum performance and maintainability:

### 1. Architecture & State Management
- **[flutter_riverpod](https://pub.dev/packages/flutter_riverpod) / [riverpod](https://pub.dev/packages/riverpod):** Robust reactive caching and data-binding framework. We use `Notifier` and `AsyncNotifier` for clean business logic encapsulation.
- **Clean Architecture (Feature-First):** The codebase is split into specific features (`auth`, `checkin`, `dashboard`, `workout`, `history`, `settings`). Each feature contains its own `presentation`, `domain`, and `data` layers.

### 2. Local Database
- **[objectbox](https://pub.dev/packages/objectbox) & [objectbox_flutter_libs](https://pub.dev/packages/objectbox_flutter_libs):** High-performance NoSQL local database used for offline storage of workout programs and session logs. Uses `build_runner` and `objectbox_generator` to generate entity bindings.

### 3. Networking & API
- **[dio](https://pub.dev/packages/dio):** Powerful HTTP client for Dart, supporting interceptors, global configuration, timeouts, and more. Configured to dynamically switch `baseUrl` based on the selected environment.

### 4. Push Notifications
- **[onesignal_flutter](https://pub.dev/packages/onesignal_flutter):** Reliable push notification service.

### 5. Camera & QR Scanner
- **[mobile_scanner](https://pub.dev/packages/mobile_scanner):** A universal scanner for Flutter based on MLKit. Used for the Check-in feature.

### 6. OTA Updates (Code Push)
- **[shorebird](https://shorebird.dev/):** Over-The-Air code push tool integrated to allow pushing hot fixes instantly without going through the App Store / Play Store review process.

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                          # App Entry Point & Initialization
├── objectbox.g.dart                   # Generated ObjectBox database bindings
├── core/                              # Core components shared across features
│   ├── config/                        # Environment configs (Prod, Staging, etc)
│   ├── database/                      # ObjectBox store initialization
│   ├── error/                         # Standard failures & exceptions
│   ├── network/                       # Dio client & interceptors
│   ├── notification/                  # OneSignal push notification service
│   ├── providers/                     # Global core providers (ObjectBox, Dio)
│   ├── shorebird/                     # Shorebird OTA Code Push management
│   └── theme/                         # Material 3 Light/Dark color themes
└── features/                          # Feature modules
    ├── auth/                          # Login Screen
    ├── checkin/                       # QR Scanner Screen
    ├── dashboard/                     # Navigation shell (Bottom Navigation Bar)
    ├── history/                       # Workout session history logs
    ├── settings/                      # App settings & Environment selector
    └── workout/                       # Workout programs & active sessions
```

---

## ⚙️ Environment Configuration

The application supports multiple environments:
- **Production**: `https://api.gym-app.com/v1/`
- **Staging**: `https://staging-api.gym-app.com/v1/`
- **Test**: `https://test-api.gym-app.com/v1/`
- **Test Local**: `http://10.0.2.2:8080/v1/` (Localhost mapping for Android Emulator)

You can switch environments during runtime by navigating to the **Settings** tab and selecting the environment from the dropdown. The `DioClient` automatically rebuilds with the new `baseUrl`.

---

## 🚀 Build Types (Debug vs Release)

To allow developers to keep the production app while developing, the application has been configured with separate identifiers for Debug and Release builds.

**Android:**
- **Debug:** App Name: `Gym App (Dev)`, Application ID Suffix: `.dev`
- **Release:** App Name: `Gym App`, Standard Application ID.

**iOS:**
- Configurations are set in `ios/Flutter/Debug.xcconfig` and `Release.xcconfig`.
- **Debug:** Display Name: `Gym App (Dev)`, Bundle ID Suffix: `.dev`
- **Release:** Display Name: `Gym App`, Standard Bundle ID.

---

## 🏃‍♂️ How to Run

1. **Install dependencies:**
   ```bash
   fvm flutter pub get
   ```

2. **Generate ObjectBox bindings (if models changed):**
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Run the App:**
   ```bash
   # Run Debug build (App Name: Gym App (Dev))
   fvm flutter run

   # Run Release build (App Name: Gym App)
   fvm flutter run --release
   ```
