# Clean Architecture Feature-First Gym Application

We have successfully generated, configured, and verified a simple Gym application in Flutter. The app follows the **Clean Architecture (Feature-First)** design and implements all requested packages: **Riverpod**, **ObjectBox**, **Dio**, **OneSignal**, and **Shorebird**.

---

## 📂 Project Directory Structure

```text
lib/
├── main.dart                          # App Entry Point & Initialization
├── objectbox.g.dart                   # Generated ObjectBox database bindings
├── core/
│   ├── database/
│   │   └── objectbox_service.dart     # ObjectBox store initialization & management
│   ├── error/
│   │   └── failures.dart              # Standard failures for Clean Architecture
│   ├── network/
│   │   └── dio_client.dart            # Dio wrapper configured with interceptors
│   ├── notification/
│   │   └── onesignal_service.dart     # OneSignal push notification service (platform safe)
│   ├── providers/
│   │   └── core_providers.dart        # Global core providers (ObjectBox, Dio)
│   ├── shorebird/
│   │   └── shorebird_service.dart     # Shorebird OTA Code Push management
│   └── theme/
│       └── app_theme.dart             # Material 3 Light/Dark color themes
└── features/
    ├── dashboard/
    │   └── dashboard_screen.dart      # Navigation shell (Bottom Navigation Bar)
    ├── workout/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── workout_local_datasource.dart
    │   │   │   └── workout_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── workout_entities.dart     # ObjectBox Entities (Program & Exercise)
    │   │   └── repositories/
    │   │       └── workout_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── exercise.dart
    │   │   │   └── workout_program.dart
    │   │   ├── repositories/
    │   │   │   └── workout_repository.dart
    │   │   └── usecases/
    │   │       ├── get_workout_programs.dart
    │   │       └── sync_workout_programs.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── workout_provider.dart
    │       └── views/
    │           ├── active_workout_screen.dart
    │           ├── workout_detail_screen.dart
    │           └── workout_list_screen.dart
    └── history/
        ├── data/
        │   ├── datasources/
        │   │   └── history_local_datasource.dart
        │   ├── models/
        │   │   └── workout_session_entity.dart  # ObjectBox Entity (Session Logs)
        │   └── repositories/
        │       └── history_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── workout_session.dart
        │   ├── repositories/
        │   │   └── history_repository.dart
        │   └── usecases/
        │       ├── get_workout_history.dart
        │       └── save_workout_session.dart
        └── presentation/
            ├── providers/
            │   └── history_provider.dart
            └── views/
                └── history_screen.dart
```

---

## 🛠️ Package Integration Details

### 1. Riverpod (State Management)
- Implemented modern AsyncNotifiers (`WorkoutProgramsNotifier` and `WorkoutHistoryNotifier`) to handle data fetching, syncing, loading, and success states dynamically.
- State is decoupled from the UI, ensuring proper separation of concerns in line with Clean Architecture principles.

### 2. ObjectBox (Local NoSQL Database)
- **Workout Programs**: Modeled using standard relations (`ToMany<ExerciseEntity>` and `@Backlink` `ToOne<WorkoutProgramEntity>`).
- **History Logging**: Structured logs (`WorkoutSession` containing exercise and set lists) are stored inside the database via `exercisesJson` serialization. This ensures clean reads and fast transaction processing.
- Bindings were generated successfully using `build_runner` into [objectbox.g.dart](file:///D:/Code/Flutter/gym_app/lib/objectbox.g.dart).

### 3. Dio (Network Operations)
- Configured in [dio_client.dart](file:///D:/Code/Flutter/gym_app/lib/core/network/dio_client.dart) with `LogInterceptor`.
- Remote fetch operations support automated mock fallbacks so the app works seamlessly out of the box when testing.

### 4. OneSignal (Push Notifications)
- Handled safely inside [onesignal_service.dart](file:///D:/Code/Flutter/gym_app/lib/core/notification/onesignal_service.dart).
- Added checks for `Platform` and `kIsWeb` to prevent runtime crashes when running on unsupported platforms (like Windows desktop or Chrome).

### 5. Shorebird (OTA Updates)
- Programmatic updater checks are configured inside [shorebird_service.dart](file:///D:/Code/Flutter/gym_app/lib/core/shorebird/shorebird_service.dart).
- The settings panel includes a user interface to test code updates and outputs.

---

## 🧪 Verification
The codebase has been checked with `flutter analyze` and compiled successfully.
All classes have standard imports and are fully decoupled.
