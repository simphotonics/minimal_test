# Minimal Test
[![Build Status](https://travis-ci.com/simphotonics/minimal_test.svg?branch=master)](https://travis-ci.com/simphotonics/minimal_test)

## Introduction

A minimalist library for writing simple tests.
Using this package introduces no further dependencies other than Dart SDK >= 2.9.0.
Aimed at testing Dart VM scripts using null-safety.

For features like test-shuffling, restricting tests to certain platforms, stream-matchers, complex asynchronous tests, it is
recommended to use the [official package test].

Note: In the context of this package, the functions [`group`][group] and [`test`][test_function] are merely used to organize and label tests and test-groups.
Each call to [`expect`][expect] is counted as a test. A test run will complete successfully if all *expect-tests* are passed and none of the test files
exits abnormally.

## Usage

#### 1. Include [`minimal_test`][minimal_test] as a `dev_dependency` in your `pubspec.yaml` file.

#### 2. Write unit tests using the functions:
 * [`group`][group]: Used to label a group of tests. The argument `body`, a function returning `void` or `FutureOr<void>`, usually contains
     one or several calls to `test`.
 * [`test`][test_function]: The body of this function usually contains one or several calls to [`expect`][expect].
 * [`setUpAll`][setUpAll]: A callback that is run before the `body` of [`test`][test_function].
 * [`tearDownAll`][tearDownAll]: A callback that is run after the `body` of [`test`][test_function] has finished.
 * [`expect`][expect]: Compares two objects. An expect-test is considered passed if the two objects match.
 (Matching should be understood as a form of lax equality test. For example  two lists match if their entries match.)

  <details><summary> Show test file content. </summary>

  ```Dart
  import 'package:minimal_test/minimal_test.dart';

  /// Custom object
  class A {
    A(this.msg);
    final String msg;

    @override
    String toString() {
      return 'A: $msg';
    }
  }

  /// Custom matcher for class A.
  bool isMatchingA(left, right){
    if (left is! A || right is! A) return false;
    return left.msg == right.msg;
  }

  void main() {
    final a1 = A('a1');
    final a1_copy = a1;
    final a2 = A('a2');
    final a3 = A('a1');

    group('Group of tests', () {
      test('Comparing copies', () {
        expect(a1, a1_copy); // Pass.
      });
      test('Comparing different objects', () {
        expect(a1, a2, 'Expected to fail.'); // Fail.
      });
      test('Using custom matcher function', () {
        expect(a1, a3, isMatching: isMatching); // Pass.
      });

    });
  }
  ```
  </details>

  <details> <summary> Show console output (test report). </summary>

  ![Console Output](https://raw.githubusercontent.com/simphotonics/minimal_test/master/images/console_output.svg?sanitize=true)

  </details>



#### 3. Run the tests in the package `test` folder by navigating to the package root and using the command:

```Console
$ pub run --enable-experiment=non-nullable minimal_test:minimal_test.dart
```
Alternatively, the path to a test file or test directory may be specified:
```Console
$ pub run --enable-experiment=non-nullable minimal_test:minimal_test.dart example/bin/example_test.dart
```


## Limitations

To keep the library as simple as possible, test files are not parsed
and there is no provision to generate and inspect a node-structure of
test-groups and tests. As such, shuffling of tests is currently not supported.

While it is possible to run **asynchronous** tests, it is recommended
to await the completion of the objects being tested before issuing a call to
[`group`][group], [`test`][test_function], and [`expect`][expect].
Otherwise, the output printed by the method [`expect`][expect] might not
occur on the right line making it difficult to read the test output.
However, the total number of failed/passed tests
is reported correctly.

File [`async_test.dart`][async_test.dart] shows how to test
the result of a future calculation.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/simphotonics/minimal_test/tracker

[official package test]: https://pub.dev/packages/test

[async_test.dart]: https://github.com/simphotonics/minimal_test/blob/master/example/async_test.dart

[expect]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/group.html

[group]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/group.html

[minimal_test]: https://pub.dev/packages/minimal_test

[setUpAll]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/setUpAll.html

[test_function]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/test.html

[tearDownAll]: https://pub.dev/documentation/minimal_test/doc/api/minimal_test/tearDownAll.html