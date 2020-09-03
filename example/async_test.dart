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
