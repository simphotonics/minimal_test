import 'dart:async';
import 'dart:io';

import 'matcher.dart';
import 'test.dart';
import 'exceptions/failed_test_exception.dart';
import 'utils/string_utils.dart';

// final _testFile = TestFile(Platform.script.path);

/// Counters.
int _testCounter = 0;
int _groupCounter = 0;
int _groupTestCounter = 0;
bool _inGroupBlock = false;

void _enterGroup() {
  _inGroupBlock = true;
  ++_groupCounter;
}

void _leaveGroup() {
  _inGroupBlock = false;
  _groupTestCounter = 0;
}

void _enterTest() {
  if (_inGroupBlock) {
    ++_groupTestCounter;
  } else {
    ++_testCounter;
  }
}

/// The callback used to setup tests.
///
/// It is called before each test.
Setup? _setupAllCallback;

/// The callback used to teardown tests.
///
/// It is called before a test exits.
Teardown? _teardownAllCallback;

/// Adds the tests contained in `body` to the current test group.
FutureOr<void> group(String description, dynamic Function() body) {
  _enterGroup();
  print('group-$_groupCounter: $description');
  body();
  _leaveGroup();
}

/// Performs a test by running the function `body`.
FutureOr<void> test(String description, dynamic Function() body) {
  _enterTest();
  if (_setupAllCallback != null) {
    _setupAllCallback!();
  }
  if (_inGroupBlock) {
    print('  test-$_groupTestCounter: $description');
  } else {
    print('test-$_testCounter: $description');
  }
  body();

  if (_teardownAllCallback != null) {
    _teardownAllCallback!();
  }
}

// /// Registers a function to be run before tests.
// void setUp(dynamic Function() callback) {}

// /// Registers a function to be run after tests.
// void tearDown(dynamic Function() callback) {}

/// Registers a function to be run before each test `body`.
FutureOr<void> setUpAll(dynamic Function() callback) {
  _setupAllCallback = callback;
}

/// Registers a function to be run after each tests `body`.
FutureOr<void> tearDownAll(dynamic Function() callback) {
  _teardownAllCallback = callback;
}

/// Compares [expected] with [actual] and throws a [FailedTestException] if
/// the two objects do not match.
/// * Custom objects may be compared using the function `isEqual`. This is
/// useful if the equality operator cannot be overriden.
/// * Collections are matched entry by entry in a recursive fashion.
void expect(
  dynamic actual,
  dynamic expected, {
  String reason = '',
  IsMatching? isMatching,
}) {
  if (match(actual, expected, isMatching: isMatching)) {
    print('    passed${reason.isEmpty ? '' : ': $reason'}');
  } else {
    print('    failed${reason.isEmpty ? '' : ': $reason'}');

    var actualString = (actual is String)
        ? actual.indentedBlock(8, skipFirstLine: true)
        : actual.toString().indent(8, skipFirstLine: true);

    var expectedString = (expected is String)
        ? expected.indentedBlock(8, skipFirstLine: true)
        : expected.toString().indent(8, skipFirstLine: true);

    final difference =
        (actual is String && expected is String) ? actual - expected : '';

    // Add hashCode if printed objects are identical.
    if (actualString == expectedString) {
      actualString += ' (${actual.runtimeType}, '
          'hashCode: ${actual.hashCode})';
      expectedString += ' (${expected.runtimeType}, '
          'hashCode: ${expected.hashCode})';
    }

    print('      Actual:   $actualString');
    print('      Expected: $expectedString');
    if (difference.isNotEmpty) {
      print('      Difference: '
          '${difference.indentedBlock(8, skipFirstLine: true)}');
    }

    try {
      throw FailedTestException(
        message: 'Equality test failed.',
        expected: expected,
        actual: actual,
        path: Platform.script.path,
      );
    } catch (e, s) {
      stderr.write(e.toString());

      final lines = s.toString().split('\n');
      final indentString = '  ';
      stderr.writeln(lines
          .map<String>(
            (item) => indentString + item,
          )
          .join('\n'));
    }
  }
}
