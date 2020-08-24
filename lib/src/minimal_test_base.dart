import 'dart:async';

import '../minimal_test.dart';

typedef Setup = dynamic Function();
typedef Teardown = dynamic Function();

/// Counts tests.
int _testCounter = 1;
int _groupCounter = 1;

/// The callback used to setup tests.
///
/// It is called before each test.
Setup? _setupAllCallback;

/// The callback used to teardown tests.
///
/// It is called before a test exits.
Teardown? _teardownAllCallback;

/// Performs a test by running the function `body`.
FutureOr<void> test(String description, dynamic Function() body) {
  if (_setupAllCallback != null) {
    _setupAllCallback!();
  }
  print('  test-$_testCounter: $description');
  body();
  if (_teardownAllCallback != null) {
    _teardownAllCallback!();
  }
  ++_testCounter;
}

/// Adds test contained in `body` to test group.
FutureOr<void> group(String description, dynamic Function() body) {
  print('group-$_groupCounter: $description');
  body();
}

// /// Registers a function to be run before tests.
// void setUp(dynamic Function() callback) {}

// /// Registers a function to be run after tests.
// void tearDown(dynamic Function() callback) {}

/// Registers a function to be run once before all tests.
void setUpAll(dynamic Function() callback) {
  _setupAllCallback = callback;
}

/// Registers a function to be run once after all tests.
void tearDownAll(dynamic Function() callback) {
  _teardownAllCallback = callback;
}

/// Compares [expected] with [actual] and throws a [FailedTestException] if
/// two objects are not equal.
void expect(dynamic expected, dynamic actual, {String reason = ''}) {
  if (expected == actual) {
    print('    passed${reason.isEmpty ? '' : ': $reason'}');
  } else {
    print('    failed${reason.isEmpty ? '' : ': $reason'}');
    print('      Expected: $expected');
    print('      Actual: $actual');
    throw FailedTestException(
      message: 'Equality test failed.',
      expected: expected,
      actual: actual,
    );
  }
}
