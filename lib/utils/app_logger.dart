/// Application-wide logging utility.
///
/// Provides consistent logging across the Eye Care App with
/// different log levels and formatted output.
///
/// Example:
/// ```dart
/// AppLogger.info('User started protection');
/// AppLogger.error('Failed to save settings', error: e, stackTrace: s);
/// ```
library;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global logger instance for the application.
///
/// Use the static methods on [AppLogger] for consistent logging:
/// - [AppLogger.debug] for debug information
/// - [AppLogger.info] for general information
/// - [AppLogger.warning] for warnings
/// - [AppLogger.error] for errors
final Logger _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  level: kDebugMode ? Level.debug : Level.info,
);

/// Application logger with static methods for easy access.
///
/// Wraps the [Logger] package with application-specific configuration
/// and provides a simple API for logging throughout the app.
class AppLogger {
  AppLogger._(); // Private constructor to prevent instantiation

  /// Log a debug message.
  ///
  /// Use for detailed debugging information that should only
  /// appear in debug builds.
  ///
  /// Example:
  /// ```dart
  /// AppLogger.debug('Timer tick: $countdown seconds remaining');
  /// ```
  static void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log an informational message.
  ///
  /// Use for general information about application state or events.
  ///
  /// Example:
  /// ```dart
  /// AppLogger.info('Eye protection started');
  /// ```
  static void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message.
  ///
  /// Use for potentially problematic situations that don't prevent
  /// the app from functioning.
  ///
  /// Example:
  /// ```dart
  /// AppLogger.warning('Settings value out of range, using default');
  /// ```
  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message.
  ///
  /// Use for errors that may affect functionality. Always include
  /// the error object and stack trace when available.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await saveSettings();
  /// } catch (e, stackTrace) {
  ///   AppLogger.error('Failed to save settings', error: e, stackTrace: stackTrace);
  /// }
  /// ```
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message.
  ///
  /// Use for critical errors that prevent the app from functioning.
  ///
  /// Example:
  /// ```dart
  /// AppLogger.fatal('Database initialization failed', error: e);
  /// ```
  static void fatal(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log service initialization.
  ///
  /// Convenience method for logging service startup.
  static void serviceInit(String serviceName) {
    _logger.i('🚀 $serviceName initialized');
  }

  /// Log service disposal.
  ///
  /// Convenience method for logging service cleanup.
  static void serviceDispose(String serviceName) {
    _logger.i('🛑 $serviceName disposed');
  }

  /// Log a user action.
  ///
  /// Convenience method for logging user interactions.
  static void userAction(String action) {
    _logger.i('👤 User action: $action');
  }

  /// Log a state change.
  ///
  /// Convenience method for logging state transitions.
  static void stateChange(String provider, String change) {
    _logger.d('📊 $provider: $change');
  }
}
