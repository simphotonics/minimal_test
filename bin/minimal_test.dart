import 'dart:async';
import 'dart:io';

import 'package:minimal_test/src/process/exit_code.dart';
import 'package:minimal_test/src/process/test_process_result.dart';
import 'package:minimal_test/src/utils/color_options.dart';
import 'package:minimal_test/src/process/test_process.dart';
import 'package:minimal_test/src/utils/file_utils.dart';

/// The script usage.
const usage = '\n'
    'Usage: minimal_test [<test-directory/test-file>] '
    '[options]\n\n'
    '  Note: If a test-directory is specified, the program  will attempt \n'
    '        to run all dart files ending with \'_test.dart.\'\n'
    '  Options:\n'
    '    -h, --help                Shows script usage.\n'
    '    -v, --verbose             Enables displaying error messages.\n'
    '    --disable-color           Disables color output.\n';

Future<void> main(List<String> args) async {
  final _args = List.from(args);

  // Reading script options.
  final colorOutput =
      _args.contains('--disable-color') ? ColorOutput.OFF : ColorOutput.ON;
  final isVerbose = _args.contains('--verbose') || _args.contains('-v');
  _args.remove('--disable-color');
  _args.remove('--verbose');
  _args.remove('-v');

  if (_args.isEmpty) {
    _args.add('test');
  }

  if (_args[0] == '-h' || _args[0] == '--help') {
    print(usage);
    exit(0);
  }

  // Resolving test files.
  final testFiles = await resolveTestFiles(_args[0]);
  if (testFiles.isEmpty) {
    print('Could not resolve any test files using path: ${_args[0]}');
    print('Please specify a path to a test directory containing test files.');
    print(usage);
    exit(ExitCode.NoTestFilesFound.index);
  } else {
    print('Finding test files: ');
    for (final file in testFiles) {
      print('  ${file.path}');
    }
  }

  // Starting processes.
  final fResults = <Future<TestProcessResult>>[];
  for (final file in testFiles) {
    fResults.add(TestProcess.runTest(
      'dart',
      [
        file.path,
      ],
    ));
  }

  // Printing results.
  fResults.forEach((fResult) {
    fResult.then((result) {
      print('Running test: ${result.command}');
      print(result.formattedStdout(
        indentMultiplier: 2,
        colorOutput: colorOutput,
      ));
      if (isVerbose) {
        // Indenting stderr output by 10 spaces.
        print(result.formattedStderr(
          indentMultiplier: 10,
          colorOutput: colorOutput,
        ));
      }
    });
  });

  // Composing exit message.
  final results = await Future.wait(fResults);
  final exitMsg = TestProcessResult.exitMessage(
    results: results,
    colorOutput: colorOutput,
    isVerbose: isVerbose,
  );

  // Exiting.
  print(exitMsg.message);
  exit(exitMsg.code);
}
