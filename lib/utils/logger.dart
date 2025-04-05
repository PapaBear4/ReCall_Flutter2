// lib/utils/logger.dart
import 'package:logger/logger.dart';

// Define a single, global logger instance
final logger = Logger(
  printer: PrettyPrinter(
      methodCount: 1, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the log print
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      ),
  // You can customize the filter and output here if needed
  // filter: ProductionFilter(), // Example: Only log Warnings and above in production
  // output: ConsoleOutput(), // Default is ConsoleOutput
);

// Optional: You could define different loggers here if needed,
// e.g., one for UI, one for background tasks, etc., but one global
// instance is usually sufficient for most apps.