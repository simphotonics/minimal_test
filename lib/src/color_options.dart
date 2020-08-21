library color_options;

enum ColorOutput { ON, OFF }

/// Ansi color modifier: Reset to default.
const String RESET = '\u001B[0m';

/// Ansi color modifier.
const String BLUE = '\u001B[34m';

/// Ansi color modifier.
const String CYAN = '\u001B[36m';

/// Ansi color modifier.
const String GREEN = '\u001B[32m';

/// Ansi color modifier.
const String RED = '\u001B[31m';

/// Ansi color modifier.
const String YELLOW = '\u001B[33m';

/// Ansi color modifier.
const String MAGENTA = '\u001B[35m';

/// Transforms error/exception messages to an output string.
String colorize(
  String message,
  String color,
  ColorOutput colorOutput,
) {
  color = (colorOutput == ColorOutput.ON) ? color : '';
  final reset = (colorOutput == ColorOutput.ON) ? RESET : '';

  return message = message.isEmpty ? '' : '$color$message$reset';
}
