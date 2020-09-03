import 'dart:convert';
import 'dart:io';

import 'test_process_result.dart';

/// Extension on [Process].
/// Adds the static method `runTest`.
extension TestProcess on Process {
  /// Runs a test process and returns an instance of
  /// `TestProcessResult`.
  static Future<TestProcessResult> runTest(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) {
    return Process.run(executable, arguments,
            workingDirectory: workingDirectory,
            environment: environment,
            includeParentEnvironment: includeParentEnvironment,
            runInShell: runInShell,
            stdoutEncoding: stdoutEncoding,
            stderrEncoding: stderrEncoding)
        .then((processResult) {
      return (TestProcessResult.from(
        processResult: processResult,
        executable: executable,
        arguments: arguments,
      ));
    });
  }
}
