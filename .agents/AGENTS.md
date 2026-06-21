# Gym App Project Rules & Guidelines

These rules dictate the behavioral constraints, architectural guidelines, and standard coding practices for any agent working on the `gym_app` project. Agents MUST strictly adhere to these instructions.

## 1. Tooling & Commands
- **FVM**: Always use `fvm flutter` and `fvm dart` instead of `flutter` or `dart` directly. 
- **Code Generation**: After editing ObjectBox models or other annotatable classes, run:
  `fvm flutter pub run build_runner build --delete-conflicting-outputs`

## 2. Architecture: Clean Architecture (Feature-First)
- **Directory Structure**: Separate the codebase into logical feature domains inside `lib/features/`.
- **Layers**: Every feature should be divided into:
  - `presentation/`: Contains UI `views/` and Riverpod `providers/`.
  - `domain/`: Contains `entities/`, `usecases/`, and `repositories/` (abstract contracts).
  - `data/`: Contains `models/`, `datasources/` (remote/local APIs), and `repositories/` (implementation).
- **Core Components**: Shared logic (theme, networking, constants, database setup) belongs in `lib/core/`.

## 3. State Management (Riverpod)
- **Use Modern Riverpod**: Rely exclusively on `Notifier` and `AsyncNotifier` (via `NotifierProvider` and `AsyncNotifierProvider`). 
- **NO Legacy Providers**: Do **not** use `StateProvider`, `StateNotifierProvider`, or `ChangeNotifierProvider`.
- **Encapsulation**: State modification must occur inside the `Notifier` class via defined methods. UI should never mutate state directly.

## 4. Database (ObjectBox)
- Store all NoSQL entities inside `data/models/` and map them correctly using `@Entity()`.
- Use relations (`ToOne`, `ToMany`) wisely.
- Always retrieve the ObjectBox store instance via the globally injected `objectBoxProvider`.

## 5. Networking (Dio & Environment)
- Inject networking calls via `DioClient` configured in `lib/core/network/dio_client.dart`.
- Respect environment variations (`Production`, `Staging`, `Test`, `TestLocal`) stored in `environmentProvider`. API calls must dynamically read the `baseUrl` from the current environment.

## 6. Commits & Formatting
- Hindari melakukan commit perubahan terkait formatting kecuali jika commit itu dikhususkan untuk formatting.
- Selalu commit file yang spesifik sesuai dengan perubahan atau fitur yang dilakukan.
