## Minimal Test
[![Build Status](https://travis-ci.com/simphotonics/minimal_test.svg?branch=master)](https://travis-ci.com/simphotonics/minimal_test)

A minimalist library for writing simple tests. Aimed at testing Dart VM scripts using null-safety features.
Using this package introduces no further dependencies other than Dart SDK >= 2.9.0.

For features like test-shuffling, restricting tests to certain platforms, stream-matchers, complex asynchronous tests, it is
recommended to use the official package [test].

Note: In the context of this package, the functions [`group`][group] and [`test`][test_function] are merely used to organize and label tests and test-groups.
Each call to [`expect`][expect] is counted as a test. A test run will complete successfully if all expect-tests are passed and none of the test files
exits abnormally.

## Usage

The library provides the functions:
* [`group`][group]: Used to label a group of tests. The argument `body`, a function returning `void` or `FutureOr<void>`, usually contains
    one or several calls to `test`.
* [`test`][test_function]: The body of this function usually contains one or several calls to [`expect`][expect].
* [`setUpAll`][setUpAll]: A callback that is run before the `body` of [`test`][test_function].
* [`tearDownAll`][tearDownAll]: A callback that is run after the `body` of [`test`][test_function] has finished.
* [`expect`][expect]: Compares two objects. An expect-test is considered passed if the two objects are equal.

```Dart
import 'package:minimal_test/minimal_test.dart';

class A {
  A(this.msg);
  final String msg;

  @override
  String toString() {
    return 'A: $msg';
  }
}

late A a1;
late A a1_copy;
late A a2;

void main() {
  setUpAll(() {
    a1 = A('a1');
    a1_copy = a1;
    a2 = A('a2');
  });

  group('Group of tests', () {
    test('First Test', () {
      expect(a1, a1_copy);
    });
    test('Second Test', () {
      expect(a1, a2);
    });
  });
}
```
The script `bin\minimal_test.dart` attempts to find test-files specified
by the user. If no path is provided, the progam will scan the folder `test`.
It then attempts to run each test-file and generate a report by inspecting
the process stdout, stderr, and exit codes.

To run the tests in the `test` folder, navigate to the package root and use:
```Console
$ pub run --enable-experiment=non-nullable minimal_test:minimal_test.dart
```
Alternatively, the path to a test file or test directory may be specified:
```Console
$ dart --enable-experiment=non-nullable bin/minimal_test.dart test/src/class_a.dart
Finding test files:
  test/src/class_a.dart
Running test: dart --enable-experiment=non-nullable test/src/class_a.dart
<span style="color:red">cardinals</span>
  test-1: 1) outside group
      failed
        Expected: 'a'
        Actual:   'b'
        Difference: a'
  test-2: 2) outside group
      passed
  group-1: Class A
    test-1: equality of copies
      passed
    test-2: inequality of different instances
      failed: Expected to fail.
        Expected: A: a1
        Actual:   A: a2
    test-3: test exception
      failed
        Expected: A: a1
        Actual:   A: a2
  test-3: third test outside group
      failed
        Expected: 'First line.\n'
          'Second line'
        Actual:   'First line.\n'
          'Second line.'
        Difference: '


Number of failed tests: 4.
Exiting with ExitCode.SomeTestsFailed: 2.
```


## Limitations

To keep the library as simple as possible, test files are not parsed
and there is no provision to generate and inspect a node-structure of
test-groups and tests. As such, shuffling of tests is not supported.

While it is possible to run **asynchronous** tests, it is recommended
to await the completion of the objects being tested before issuing a call to
[`group`][group], [`test`][test_function], and [`expect`][expect].
Otherwise, the output of [`expect`][expect] might not
occur on the right line resulting in a confusing test-report.
File [`async_test.dart`][async_test.dart] shows how to test
the result of a future calculation.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/simphotonics/minimal_test/tracker

[test]: https://pub.dev/packages/test

[async_test.dart]: https://github.com/simphotonics/minimal_test/blob/master/example/async_test.dart

[expect]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/group.html

[group]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/group.html

[setUpAll]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/setUpAll.html

[test_function]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/test.html

[tearDownAll]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/tearDownAll.html