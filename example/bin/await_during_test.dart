import 'dart:async';

import 'package:minimal_test/minimal_test.dart';

Future<T> later<T>(
  T t, {
  Duration duration = const Duration(microseconds: 100),
}) {
  return Future.delayed(duration, () => t);
}



/// Demonstrator test.
/// The output printed by the call to `expect()` occurs after all group and test
/// labels are printed.
///
/// The association between test-label and passed/failed is lost.
/// A better way to test future computations is shown in file: `await_test.dart`.
Future<void> main() async {
  group('int: await in expect', () {
    test('17', () async {
      expect(
          await (later(17,
              duration: Duration(
                microseconds: 200,
              ))),
          17);
    });

    test('27', () async {
      expect(await (later(27)), 27);
    });
  });

  group('String: await in expect', () {
    test('seventeen', () async {
      expect(
          await later(
            'seventeen',
            duration: Duration(
              microseconds: 230,
            ),
          ),
          'seventeen');
    });
    test('twentyseven', () async {
      expect(await later('twentyseven'), 'twentyseven');
    });
  });
}
