import 'dart:async';

import 'package:minimal_test/minimal_test.dart';
import 'package:minimal_test/src/process/test_process.dart';
import 'package:minimal_test/src/process/test_process_result.dart';
import 'package:minimal_test/src/utils/color_options.dart';

Future<void> main() async {
  final testFiles = [
    'test/src/class_a.dart',
    'test/src/class_b.dart',
    'test/src/class_c.dart',
  ];

  final fResults = <Future<TestProcessResult>>[];
  for (final file in testFiles) {
    fResults.add(TestProcess.runTest(
      'dart',
      [
        '--enable-experiment=non-nullable',
        file,
      ],
    ));
  }

  await Future.wait<TestProcessResult>(fResults).then((results) {
    group('exitMessage', () {
      test('Some tests failed.', () {
        final exitMsg = exitMessage(
          results: [results[0]],
          isVerbose: true,
          colorOutput: ColorOutput.OFF,
        );
        expect(
          exitMsg.message,
          '\n'
          'Number of failed tests: 4.\n'
          'Exiting with ExitCode.SomeTestsFailed: 2.',
        );
        expect(exitMsg.code, 2);
      });
      test('Exited abnormally.', () {
        final exitMsg = exitMessage(
          results: [results[1]],
          isVerbose: true,
          colorOutput: ColorOutput.OFF,
        );
        expect(
          exitMsg.message,
          'Command: dart --enable-experiment=non-nullable test/src/class_b.dart \n'
          '  exited abnormally with code: 255. \n'
          '\n'
          'Some tests may have been skipped. \n'
          '',
        );
        expect(exitMsg.code, 255);
      });
      test('Completed successfully.', () {
        final exitMsg = exitMessage(
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
