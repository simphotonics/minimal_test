import 'dart:async';
import 'dart:io';

import 'package:minimal_test/script_dependencies.dart';

/// The script usage.
const usage = '\n'
    'Usage: minimal_test <test-directory/test-file> '
    '[options]\n\n'
    '  Note: If a test-directory is specified, the program  will attempt \n'
    '        to run all dart files ending with \'_test.dart.\'\n\n'
    '  Options:\n'
    '    -h, --help                Shows script usage.\n'
    '    -v, --verbose             Enables displaying error messages.\n'
    '    --disable-color           Disables color output.\n';

Future<void> main(List<String> args) async {
  // Resolving test files.
  if (args.isEmpty) {
    print('Please specify a path to a test directory or a test file.');
    print(usage);
    exit(ExitCode.NoTestFilesFound.index);
  } else if (args[0] == '-h' || args[0] == '--h') {
    print(usage);
    exit(ExitCode.NoTestFilesFound.index);
  }

  final testFiles = await resolveTestFiles(args[0]);

  if (testFiles.isEmpty) {
    print('Could not resolve any test files using path: ${args[0]}');
    exit(ExitCode.NoTestFilesFound.index);
  } else {
    print('Finding test files: ');
    for (final file in testFiles) {
      print('  ${file.path}');
    }
  }

  // Reading script options
  final colorOutput =
      args.contains('--disable-color') ? ColorOutput.OFF : ColorOutput.ON;
  final isVerbose = args.contains('--verbose');

  // final results = Future<Map<String, ProcessResult>>(() {
  //   final map = <String, ProcessResult>{};

  //   for (final file in testFiles) {
  //     Process.run(
  //       'dart',
  //       [
  //         '--enable-experiment=non-nullable',
  //         file.path,
  //       ],
  //     ).then((process) {
  //       map[file.path] = process;
  //     });
  //   }

  //   return map;
  // });
  final exitCodes = <String, Completer<int>>{};
  final stderrOutput = <String, Completer<String>>{};
  final results = <String, Future<ProcessResult>>{};

  // Starting processes.
  for (final file in testFiles) {
    exitCodes[file.path] = Completer<int>();
    stderrOutput[file.path] = Completer<String>();

    results[file.path] = Process.run(
      'dart',
      [
        '--enable-experiment=non-nullable',
        file.path,
      ],
    );
  }

  print('Running test ... ');
  results.forEach((path, result) {
    result.then((res) {
      print('  dart --enable-experiment=non-nullable $path.');
      print(indent(res.stdout, 4, colorOutput: colorOutput));
      if (isVerbose) {
        // Indenting stderr output by 10 spaces.
        print(indent(res.stderr, 10));
      }
      exitCodes[path]?.complete(res.exitCode);
      stderrOutput[path]?.complete(res.stderr);
    });
  });

  //Future.wait(results).then((list) {});

  await exitMessage(
    exitCodes: exitCodes,
    stderrOutput: stderrOutput,
    colorOutput: colorOutput,
    isVerbose: isVerbose,
  ).then<ExitMessage>((item) {
    print(item.message);
    exit(item.code);
  });
}
