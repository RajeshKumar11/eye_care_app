# Eye Care App Architecture

## Overview

Eye Care App follows a clean architecture pattern with clear separation of concerns, making the codebase maintainable, testable, and scalable.

## Architecture Diagram

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  ┌─────────────────────────────────┐   │
│  │         UI (Screens)             │   │
│  │  - HomeScreen                    │   │
│  │  - SettingsScreen                │   │
│  │  - TrainingScreen                │   │
│  │  - BlinkOverlay                  │   │
│  └──────────────┬──────────────────┘   │
│                 │                        │
│  ┌──────────────▼──────────────────┐   │
│  │      State Management            │   │
│  │  - SettingsProvider              │   │
│  │  - EyeCareProvider               │   │
│  │  - ExerciseProvider              │   │
│  └──────────────┬──────────────────┘   │
└─────────────────┼────────────────────────┘
                  │
┌─────────────────▼────────────────────────┐
│           Business Logic Layer           │
│  ┌─────────────────────────────────┐    │
│  │         Services                 │    │
│  │  - BackgroundService             │    │
│  │  - NotificationService           │    │
│  │  - OverlayService                │    │
│  │  - TTSService                    │    │
│  │  - StorageService                │    │
│  └──────────────┬──────────────────┘    │
└─────────────────┼─────────────────────────┘
                  │
┌─────────────────▼─────────────────────────┐
│            Data Layer                     │
│  ┌─────────────────────────────────┐     │
│  │         Models                   │     │
│  │  - EyeCareSettings               │     │
│  │  - EyeCarePreset                 │     │
│  └─────────────────────────────────┘     │
│                                           │
│  ┌─────────────────────────────────┐     │
│  │    Platform Channels             │     │
│  │  - SharedPreferences             │     │
│  │  - SystemOverlay (Android)       │     │
│  │  - Notifications                 │     │
│  └─────────────────────────────────┘     │
└───────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Presentation Layer

**Location**: `lib/screens/` and `lib/widgets/`

**Responsibilities**:
- Display UI components
- Handle user interactions
- Subscribe to state changes
- Render data from providers

**Key Principles**:
- UI components should be dumb (minimal logic)
- Business logic belongs in providers/services
- Widgets should be reusable and composable

**Example**:
```dart
// HomeScreen subscribes to EyeCareProvider
Consumer<EyeCareProvider>(
  builder: (context, provider, child) {
    return Text('Status: ${provider.isActive}');
  },
)
```

### 2. State Management Layer

**Location**: `lib/providers/`

**Technology**: Provider pattern (provider package)

**Responsibilities**:
- Manage application state
- Notify UI of state changes
- Coordinate between services
- Handle business logic

**Key Classes**:

1. **SettingsProvider**
   - Manages user settings
   - Persists settings to storage
   - Notifies UI of changes

2. **EyeCareProvider**
   - Manages protection state (active/inactive)
   - Coordinates blink reminders
   - Handles timer logic

3. **ExerciseProvider**
   - Manages eye exercise state
   - Tracks exercise progress
   - Handles TTS coordination

**Example**:
```dart
class SettingsProvider extends ChangeNotifier {
  EyeCareSettings _settings = const EyeCareSettings();

  void updateBlinkInterval(int seconds) {
    _settings = _settings.copyWith(blinkIntervalSeconds: seconds);
    _saveSettings();
    notifyListeners();
  }
}
```

### 3. Business Logic Layer

**Location**: `lib/services/`

**Responsibilities**:
- Implement core app functionality
- Handle platform-specific logic
- Manage external dependencies
- Provide API to providers

**Key Services**:

1. **BackgroundService**
   - Manages foreground service (Android)
   - Keeps app running in background
   - Handles wake locks

2. **NotificationService**
   - Creates notification channels
   - Shows reminders
   - Handles notification actions

3. **OverlayService**
   - Manages system overlay permission
   - Shows overlay windows
   - Handles overlay lifecycle

4. **TTSService**
   - Text-to-speech for exercises
   - Platform-specific implementation
   - Voice guidance

5. **StorageService**
   - SharedPreferences wrapper
   - Settings persistence
   - Data serialization

**Example**:
```dart
class OverlayService {
  static Future<bool> checkPermission() async {
    // Platform-specific permission check
  }

  static Future<void> show(Widget overlay) async {
    // Show system overlay
  }
}
```

### 4. Data Layer

**Location**: `lib/models/`

**Responsibilities**:
- Define data structures
- Serialize/deserialize data
- Provide immutable data objects
- Business logic related to data

**Key Models**:

1. **EyeCareSettings**
   - User configuration data
   - Serialization methods
   - Preset factory methods

2. **EyeCarePreset**
   - Predefined configurations
   - Display information

**Example**:
```dart
class EyeCareSettings {
  final int blinkIntervalSeconds;

  const EyeCareSettings({this.blinkIntervalSeconds = 15});

  EyeCareSettings copyWith({int? blinkIntervalSeconds}) {
    return EyeCareSettings(
      blinkIntervalSeconds: blinkIntervalSeconds ?? this.blinkIntervalSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
    'blinkIntervalSeconds': blinkIntervalSeconds,
  };
}
```

## Data Flow

### User Action Flow

```
User Tap
    ↓
Widget (onTap)
    ↓
Provider Method
    ↓
Service Call
    ↓
Platform API
    ↓
Service Response
    ↓
Provider State Update
    ↓
notifyListeners()
    ↓
Widget Rebuild
    ↓
UI Update
```

### Example: Start Protection Flow

1. User taps "Start Protection" button
2. HomeScreen calls `eyeCareProvider.startProtection()`
3. EyeCareProvider:
   - Updates `isActive` state
   - Calls `BackgroundService.start()`
   - Calls `NotificationService.show()`
   - Starts blink timer
4. Services handle platform-specific logic
5. Provider calls `notifyListeners()`
6. UI rebuilds with new state

## Platform-Specific Architecture

### Android

```
Flutter App
    ↓
MethodChannel
    ↓
MainActivity.kt
    ↓
- SystemOverlay
- ForegroundService
- NotificationManager
- AlarmManager
```

### iOS

```
Flutter App
    ↓
MethodChannel
    ↓
AppDelegate.swift
    ↓
- LocalNotifications
- BackgroundTasks
- AVFoundation (TTS)
```

### Desktop (Windows/macOS/Linux)

```
Flutter App
    ↓
Platform Plugins
    ↓
- Window Management
- Notifications (limited)
- File System
```

## Design Patterns

### 1. Provider Pattern

Used for state management across the app.

**Benefits**:
- Simple and intuitive
- Built-in with Flutter
- Easy testing
- Good performance

### 2. Repository Pattern

StorageService acts as a repository for settings.

**Benefits**:
- Abstracts data source
- Easy to swap implementations
- Testable with mocks

### 3. Factory Pattern

EyeCareSettings.fromPreset() creates preset configurations.

**Benefits**:
- Centralized creation logic
- Easy to add new presets
- Type-safe

### 4. Singleton Pattern

Services use singleton pattern for global access.

**Benefits**:
- Single source of truth
- Efficient resource usage
- Easy dependency injection

## Testing Strategy

### Unit Tests
- Models: Serialization, business logic
- Providers: State changes, notifications
- Services: Individual methods
- Utils: Helper functions

### Widget Tests
- UI components render correctly
- User interactions work
- State updates reflect in UI

### Integration Tests
- Complete user flows
- Multi-component interactions
- Platform-specific features

See [test/README.md](../test/README.md) for details.

## Code Organization

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── settings_model.dart
├── providers/                # State management
│   ├── settings_provider.dart
│   ├── eye_care_provider.dart
│   └── exercise_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   └── training_screen.dart
├── services/                 # Business logic
│   ├── background_service.dart
│   ├── notification_service.dart
│   ├── overlay_service.dart
│   ├── tts_service.dart
│   └── storage_service.dart
├── utils/                    # Utilities
│   ├── constants.dart
│   └── platform_utils.dart
└── widgets/                  # Reusable widgets
    ├── blink_overlay.dart
    ├── blank_screen.dart
    └── preset_selector.dart
```

## Dependencies

### Core
- `flutter`: UI framework
- `provider`: State management

### Platform Features
- `shared_preferences`: Local storage
- `flutter_local_notifications`: Notifications
- `system_alert_window`: Overlay (Android)
- `workmanager`: Background tasks
- `flutter_tts`: Text-to-speech

### Development
- `flutter_test`: Testing framework
- `mockito`: Mocking for tests
- `flutter_launcher_icons`: Icon generation

## Performance Considerations

### 1. State Management
- Use `const` constructors where possible
- Minimize `notifyListeners()` calls
- Use `Consumer` with `child` parameter for optimization

### 2. Timers
- Cancel timers when not needed
- Use `Timer.periodic` efficiently
- Avoid creating multiple timers

### 3. Overlay Performance
- Keep overlay widgets lightweight
- Use `RepaintBoundary` for complex overlays
- Minimize rebuilds

### 4. Memory Management
- Dispose controllers and listeners
- Cancel streams and subscriptions
- Clear timers in dispose methods

## Security Considerations

### 1. Permissions
- Request only necessary permissions
- Explain permission usage to users
- Handle permission denial gracefully

### 2. Data Storage
- No sensitive data stored
- Settings encrypted if needed
- Local storage only

### 3. Privacy
- No analytics or tracking
- No network requests
- No data collection

## Future Architecture Improvements

### Planned
1. **Bloc Pattern**: Consider migration for complex state
2. **Repository Layer**: Proper repository pattern
3. **Dependency Injection**: get_it or riverpod
4. **Feature-Based Structure**: Group by feature vs layer

### Under Consideration
1. **GraphQL/REST API**: For future cloud sync
2. **Local Database**: SQLite for usage statistics
3. **Modular Architecture**: Separate packages for features

## Contributing to Architecture

When adding features:
1. Follow existing patterns
2. Keep layers separate
3. Write tests for new components
4. Update this document
5. Consider backward compatibility

## Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Last Updated**: 2026-01-16
