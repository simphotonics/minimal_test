import 'dart:async';

import 'package:minimal_test/minimal_test.dart';
import 'package:minimal_test/src/process/test_process.dart';
import 'package:minimal_test/src/process/test_process_result.dart';
import 'package:minimal_test/src/utils/color_options.dart';

/// Test related to class `TestProcessResult`.
Future<void> main() async {
  final testFiles = [
    'test/src/class_a_test.dart',
    'test/src/class_b_test.dart',
    'test/src/class_c_test.dart',
  ];

  final fResults = <Future<TestProcessResult>>[];
  for (final file in testFiles) {
    fResults.add(TestProcess.runTest(
      'dart',
      [
        file,
      ],
    ));
  }

  await Future.wait<TestProcessResult>(fResults).then((results) {
    group('exitMessage', () {
      test('Some tests failed.', () {
        final exitMsg = TestProcessResult.exitMessage(
          results: [results[0]],
          isVerbose: true,
          colorOutput: ColorOutput.OFF,
        );
        expect(
          exitMsg.message,
          '\n'
          'Number of failed tests: 4.\n'
          'Exiting with ExitCode.SomeTestsFailed.',
        );
        expect(exitMsg.code, 2);
      });
      test('Exited abnormally.', () {
        final exitMsg = TestProcessResult.exitMessage(
          results: [results[1]],
          isVerbose: true,
          colorOutput: ColorOutput.OFF,
        );
        expect(
          exitMsg.message,
          'Command: dart test/src/class_b_test.dart \n'
          '  exited abnormally with code: 255. \n'
          '\n'
          'Some tests may have been skipped. \n'
          '',
        );
        expect(exitMsg.code, 255);
      });
      test('Completed successfully.', () {
        final exitMsg = TestProcessResult.exitMessage(
          results: [results[2]],
          isVerbose: true,
          colorOutput: ColorOutput.OFF,
        );
        expect(
            exitMsg.message,
            'Completed successfully. \n'
            'Exiting with code: 0.\n'
            '');
        expect(exitMsg.code, 0);
      });
    });
  });
}
