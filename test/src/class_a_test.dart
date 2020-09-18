import 'package:minimal_test/minimal_test.dart';

class A {
  A(this.msg);
  final String msg;

  @override
  String toString() {
    return 'A: $msg';
  }
}

void main() {
  final a1 = A('a1');
  final a1_copy = a1;
  final a2 = A('a2');

  test('1) outside group', () {
    expect('a', 'b');
  });

  test('2) outside group', () {
    expect('a', 'a');
  });

  group('Class A', () {
    test('equality of copies', () {
      expect(a1, a1_copy);
    });
    test('inequality of different instances', () {
      try {
        expect(a1, a2, reason: 'Expected to fail.');
      } on FailedTestException catch (e) {
        expect(e.expected, a1);
        expect(e.actual, a2);
      }
    });
    test('test exception', () {
      expect(a1, a2);
    });
  });

  test('third test outside group', () {
    expect(
      'First line.\nSecond line',
      'First line.\nSecond line.',
    );
  });
}
