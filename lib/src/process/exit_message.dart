/// Class holding an exit code and an exit message.
class ExitMessage {
  ExitMessage(this.message, this.code);

  /// The exit message.
  final String message;

  /// The exit code.
  final int code;

  @override
  String toString() => message;
}
