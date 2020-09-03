
## Minimal Test - Example

[![Build Status](https://travis-ci.com/simphotonics/minimal_test.svg?branch=master)](https://travis-ci.com/simphotonics/minimal_test)


## Asynchronous Tests

While it is possible to run **asynchronous** tests, it is recommended
to await the completion of the objects being tested before issuing a call to
`group`, `test`, and `expect`. Otherwise, the output of `expect` might not
occur on the right line resulting in a confusing test-report.
File [`async_test.dart`][async_test.dart] shows how to
test the result of a future calculation:
```Dart
import 'dart:async';

import 'package:minimal_test/minimal_test.dart';

Future<T> later<T>(
  T t, {
  Duration duration = const Duration(microseconds: 100),
}) {
  return Future.delayed(duration, () => t);
}

Future<void> main() async {
  final a = [await later(17), await later(27)];

  group('int', () {
    test('17', () {
      expect(a[0], 17);
    });

    test('27', () {
      expect(a[1], 27);
    });
  });

  final b = [
    await later(
      'seventeen',
      duration: Duration(
        microseconds: 230,
      ),
    ),
    await later('twentyseven'),
  ];

  group('Await in expect', () {
    test('seventeen', () {
      expect(b[0], 'seventeen');
    });
    test('twentyseven', () {
      expect(b[1], 'twentyseven');
    });
  });
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/simphotonics/minimal_test

[async_test.dart]: https://github.com/simphotonics/minimal_test/blob/master/example/async_test.dart