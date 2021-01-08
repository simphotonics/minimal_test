import 'dart:io';

import 'package:minimal_test/minimal_test.dart';

Future<void> main() async {
  // Processes
  final processA = await Process.run('dart', [
    '--enable-experiment=non-nullable',
    'bin/minimal_test.dart',
    'test/src/class_a_test.dart',
    '--disable-color',
  ]);
  final processB = await Process.run('dart', [
    '--enable-experiment=non-nullable',
    'bin/minimal_test.dart',
    'test/src/class_b_test.dart',
    '--disable-color',
  ]);
  final processC = await Process.run('dart', [
    '--enable-experiment=non-nullable',
    'bin/minimal_test.dart',
    'test/src/class_c_test.dart',
    '--disable-color',
  ]);
  final processD = await Process.run('dart', [
    '--enable-experiment=non-nullable',
    'bin/minimal_test.dart',
    'test/unknown.dart',
    '--disable-color',
  ]);

  final String usage = (await Process.run(
    'dart',
    ['--enable-experiment=non-nullable', 'bin/minimal_test.dart', '-h'],
  ))
      .stdout;

  group('Exit codes', () {
    test('A', () {
      expect(processA.exitCode, 2);
    });
    test('B', () {
      expect(processB.exitCode, 255);
    });
  });

  group('No. of failed tests', () {
    test('A: 4', () {
      expect(processA.stdout.contains('Number of failed tests: 4.'), true);
    });
    test('B: some skipped', () {
      expect(
        processB.stdout.contains('Some tests may have been skipped'),
        true,
      );
    });
    test('C: completed', () {
      expect(
        processC.stdout.contains('Completed successfully.'),
        true,
      );
    });
  });

  group('Input files', () {
    test('A', () {
      expect(processA.stdout.contains('test/src/class_a_test.dart'), true);
    });
    test('D', () {
      expect(
          processD.stdout.contains('Could not resolve any '
              'test files using path: test/unknown.dart'),
          true);
    });
  });

  group('Stdout', () {
    test('A', () {
      expect(
          processA.stdout,
          'Finding test files: \n'
          '  test/src/class_a_test.dart\n'
          'Running test: dart --enable-experiment=non-nullable test/src/class_a_test.dart\n'
          '  test-1: 1) outside group\n'
          '      failed\n'
          '        Actual:   \'a\'\n'
          '        Expected: \'b\'\n'
          '        Difference: \'a\'\n'
          '  test-2: 2) outside group\n'
          '      passed\n'
          '  group-1: Class A\n'
          '    test-1: equality of copies\n'
          '      passed\n'
          '    test-2: inequality of different instances\n'
          '      failed: Expected to fail.\n'
          '        Actual:   A: a1\n'
          '        Expected: A: a2\n'
          '    test-3: test exception\n'
          '      failed\n'
          '        Actual:   A: a1\n'
          '        Expected: A: a2\n'
          '  test-3: third test outside group\n'
          '      failed\n'
          '        Actual:   \'First line.\\n\'\n'
          '          \'Second line\'\n'
          '        Expected: \'First line.\\n\'\n'
          '          \'Second line.\'\n'
          '        Difference: \'.\'\n'
          '  \n'
          '\n'
          'Number of failed tests: 4.\n'
          'Exiting with ExitCode.SomeTestsFailed.\n'
          '');
    });
    test('B', () {
      expect(
          processB.stdout,
          'Finding test files: \n'
          '  test/src/class_b_test.dart\n'
          'Running test: dart --enable-experiment=non-nullable test/src/class_b_test.dart\n'
          '  group-1: Class B\n'
          '    test-1: equality of copies\n'
          '      passed\n'
          '  \n'
          'Command: dart --enable-experiment=non-nullable test/src/class_b_test.dart \n'
          '  exited abnormally with code: 255. \n'
          'Try using the option --verbose for more details.\n'
          'Some tests may have been skipped. \n'
          '\n'
          '');
    });
    test('D', () {
      expect(
          processD.stdout,
          'Could not resolve any test files using path: test/unknown.dart\n'
          'Please specify a path to a test directory containing test files.\n'
          '\n'
          'Usage: minimal_test [<test-directory/test-file>] [options]\n'
          '\n'
          '  Note: If a test-directory is specified, the program  will attempt \n'
          '        to run all dart files ending with \'_test.dart.\'\n'
          '  Options:\n'
          '    -h, --help                Shows script usage.\n'
          '    -v, --verbose             Enables displaying error messages.\n'
          '    --disable-color           Disables color output.\n'
          '\n'
          '');
    });
  });

  group('Options', () {
    test('-h', () {
      expect(
          usage,
          '\n'
          'Usage: minimal_test [<test-directory/test-file>] [options]\n'
          '\n'
          '  Note: If a test-directory is specified, the program  will attempt \n'
          '        to run all dart files ending with \'_test.dart.\'\n'
          '  Options:\n'
          '    -h, --help                Shows script usage.\n'
          '    -v, --verbose             Enables displaying error messages.\n'
          '    --disable-color           Disables color output.\n'
          '\n'
          '');
    });
  });
}
