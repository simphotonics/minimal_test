## Simple Test

A library providing simple test functions. Aimed at testing Dart scripts with null-safety enabled.

## Usage

```Dart
import 'package:simple_test/simple_test.dart';

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
  group('Group of tests', () {
    setUpAll(() {
      a1 = A('a1');
      a1_copy = a1;
      a2 = A('a2');
    });

    test('First Test', () {
      expect(a1, a1_copy);
    });
    test('Second Test', () {
      expect(a1, a2);
    });
  });
}
```

To run the tests in this package use:
```Console
$ dart --enable-experiment=non-nullable test/simple_test_test.dart
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/simphotonics/simple_test
