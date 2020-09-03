class FailedTestException implements Exception {
  FailedTestException({
    this.message = '',
    this.expected = '',
    this.actual = '',
    this.path = '',
  });

  /// Message added when the error is thrown.
  final Object message;

  /// Generic object conveying information about the expected object.
  final Object expected;

  /// Generic object conveying information about an actual object.
  final Object actual;

  /// Script path where error is thrown.
  ///
  /// For example: `Platform.script.path`.
  final String path;

  @override
  String toString() {
    final msg =
        message.toString().isEmpty ? '' : Error.safeToString(message) + '\n';

    final expectedString = expected.toString().isEmpty
        ? ''
        : ' Expected: ${Error.safeToString(expected)}\n';

    final actualString = actual.toString().isEmpty
        ? ''
        : ' Actual:   ${Error.safeToString(actual)}\n';

    final pathInfo = (path.isEmpty) ? '' : ' Thrown in $path.\n';

    return '$runtimeType: $msg $expectedString $actualString $pathInfo';
  }
}
