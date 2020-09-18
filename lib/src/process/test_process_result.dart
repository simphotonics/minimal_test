import 'dart:io' hide stderr, stdout;

import '../utils/string_utils.dart';
import '../utils/color_options.dart';
import 'exit_code.dart';
import 'exit_message.dart';

/// Extends [ProcessResult].
/// * Adds fields: `cmd`, and `options`.
class TestProcessResult extends ProcessResult {
  TestProcessResult({
    required this.executable,
    required this.arguments,
    required int pid,
    required int exitCode,
    required dynamic stdout,
    required dynamic stderr,
  }) : super(
          pid,
          exitCode,
          stdout,
          stderr,
        );

  /// Creates a `TestProcessResult` from a `ProcessResult`.
  TestProcessResult.from({
    required this.executable,
    required this.arguments,
    required ProcessResult processResult,
  }) : super(
          processResult.pid,
          processResult.exitCode,
          processResult.stdout,
          processResult.stderr,
        );

  /// The command used to start the process.
  final String executable;

  /// The command options used to start the process.
  final List<String> arguments;

  /// Returns the command and the options used to start this process.
  String get command => '$executable ' + arguments.join(' ');

  /// Returns the number of failed `expect()` tests.

  /// Note: Every time an `expect()` test fails a
  /// message is written to `stderr`.
  int get failedTests {
    return '$stderr'.countSubstring(
      'FailedTestException: "Equality test failed."',
    );
  }

  /// Indents and colorizes `this.stdout`.
  ///
  /// Each line of output will start with
  /// `indentChars` repeated `indentMultiplier` times.
  String formattedStdout(
      {String indentChars = ' ',
      int indentMultiplier = 1,
      ColorOutput colorOutput = ColorOutput.ON}) {
    final indentString = indentChars * indentMultiplier;
    final lines = '$stdout'.split('\n');
    if (colorOutput == ColorOutput.ON) {
      return _colorizeStdout(lines)
          .map<String>(
            (item) => indentString + item,
          )
          .join('\n');
    } else {
      return lines
          .map<String>(
            (item) => indentString + item,
          )
          .join('\n');
    }
  }

  /// Applies color to certain lines of test output.
  List<String> _colorizeStdout(List<String> lines) {
    final colorizedLines = <String>[];
    const expected = '      Expected:';
    const actual = '      Actual:';
    const difference = '      Difference:';
    const expectedLength = expected.length;
    const actualLength = actual.length;
    const differenceLength = difference.length;

    final colorOutput = ColorOutput.ON;
    for (final line in lines) {
      line.trimRight();
      if (line.startsWith('  test-')) {
        colorizedLines.add(colorize(line, CYAN, colorOutput));
      } else if (line.startsWith('test-')) {
        colorizedLines.add(colorize(line, CYAN, colorOutput));
      } else if (line.startsWith('group-')) {
        colorizedLines.add(colorize(line, CYAN_BOLD, colorOutput));
      } else if (line.startsWith('    passed')) {
        colorizedLines.add(colorize(line, GREEN, colorOutput));
      } else if (line.startsWith('    failed: ')) {
        colorizedLines.add(colorize(line, YELLOW, colorOutput));
      } else if (line.startsWith('    failed')) {
        colorizedLines.add(colorize(line, RED, colorOutput));
      } else if (line.startsWith('FailedTestException:')) {
        colorizedLines.add(colorize(line, RED, colorOutput));
      } else if (line.startsWith(expected)) {
        colorizedLines.add(colorize(
              expected,
              MAGENTA,
              colorOutput,
            ) +
            line.substring(expectedLength));
      } else if (line.startsWith(actual)) {
        colorizedLines.add(colorize(
              actual,
              MAGENTA,
              colorOutput,
            ) +
            line.substring(actualLength));
      } else if (line.startsWith(difference)) {
        colorizedLines.add(colorize(
              difference,
              MAGENTA,
              colorOutput,
            ) +
            line.substring(differenceLength));
      } else {
        colorizedLines.add(line);
      }
    }
    return colorizedLines;
  }

  /// Indents and colorizes `this.stderr`.
  ///
  /// Each line of output will start with
  /// `indentChars` repeated `indentMultiplier` times.
  String formattedStderr(
      {String indentChars = ' ',
      int indentMultiplier = 1,
      ColorOutput colorOutput = ColorOutput.ON}) {
    final indentString = indentChars * indentMultiplier;
    final lines = '$stderr'.split('\n');
    if (colorOutput == ColorOutput.ON) {
      return _colorizeStderr(lines)
          .map<String>(
            (item) => indentString + item,
          )
          .join('\n');
    } else {
      return lines
          .map<String>(
            (item) => indentString + item,
          )
          .join('\n');
    }
  }

  /// Applies color to certain lines of test stderr output.
  List<String> _colorizeStderr(List<String> lines) {
    final colorizedLines = <String>[];
    final colorOutput = ColorOutput.ON;
    for (final line in lines) {
      line.trimRight();
      if (line.startsWith('FailedTestException:')) {
        colorizedLines.add(colorize(line, RED, colorOutput));
      } else {
        colorizedLines.add(line);
      }
    }
    return colorizedLines;
  }

  /// Returns an object of type [ExitMessage].
  /// * Checks if the test processes exited normally.
  /// * Checks if stderr contains the string `FailedTestException`.
  static ExitMessage exitMessage({
    required List<TestProcessResult> results,
    required ColorOutput colorOutput,
    bool isVerbose = false,
  }) {
    var msg = '';
    var exitCode = 0;
    var numberOfFailedTests = 0;

    for (final result in results) {
      numberOfFailedTests += result.failedTests;
    }

    if (numberOfFailedTests > 0) {
      msg = '\nNumber of failed tests: ${colorize(
        numberOfFailedTests.toString(),
        RED,
        colorOutput,
      )}.\n';
      exitCode = ExitCode.SomeTestsFailed.index;
    }

    for (final result in results) {
      if (result.exitCode != 0) {
        exitCode = result.exitCode;
        msg = msg +
            'Command: ${result.command} \n'
                '  exited abnormally with code: '
                '${colorize(exitCode.toString(), RED, colorOutput)}. \n'
                '${isVerbose ? '' : 'Try using the option --verbose for more details.'}\n' +
            colorize('Some tests may have been skipped. \n', RED, colorOutput);
      }
    }

    if (exitCode == ExitCode.SomeTestsFailed.index) {
      msg = msg +
          'Exiting with ' +
          colorize(ExitCode.SomeTestsFailed.toString(), RED, colorOutput) +
          '.';
    }
    if (exitCode == 0) {
      msg = '${colorize('Completed successfully.', GREEN, colorOutput)} \n'
          'Exiting with code: 0.\n';
    }
    return ExitMessage(msg, exitCode);
  }
}
