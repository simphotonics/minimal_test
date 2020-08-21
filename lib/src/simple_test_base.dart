import '../simple_test.dart';
import 'color_options.dart';

typedef Setup = dynamic Function();
typedef Teardown = dynamic Function();

int counter = 1;

ColorOutput colorOutput = ColorOutput.ON;

Setup? setupAllCallback;
Teardown? teardownAllCallback;

void test(String description, dynamic Function() body) {
  if (setupAllCallback != null) {
    setupAllCallback!();
  }
  print('  test-$counter: ' + colorize(description, CYAN, colorOutput));
  body();
  if (teardownAllCallback != null) {
    teardownAllCallback!();
  }
  ++counter;
}

void group(String description, dynamic Function() body) {
  print('group: ' + colorize(description, MAGENTA, colorOutput));
  body();
}

// /// Registers a function to be run before tests.
// void setUp(dynamic Function() callback) {}

// /// Registers a function to be run after tests.
// void tearDown(dynamic Function() callback) {}

/// Registers a function to be run once before all tests.
void setUpAll(dynamic Function() callback) {
  setupAllCallback = callback;
}

/// Registers a function to be run once after all tests.
void tearDownAll(dynamic Function() callback) {
  teardownAllCallback = callback;
}

void expect(dynamic expected, dynamic actual, {String reason = ''}) {
  if (expected == actual) {
    print(colorize(
      '    passed${reason.isEmpty ? '' : ':$reason'}',
      GREEN,
      colorOutput,
    ));
  } else {
    print(
      colorize('    failed', RED, colorOutput) +
          '${reason.isEmpty ? '' : ': $reason'}',
    );
    print('      Expected: $expected');
    print('      Actual: $actual');
    throw FailedTestException(
      message: 'Equality test failed.',
      expected: expected,
      actual: actual,
    );
  }
}
