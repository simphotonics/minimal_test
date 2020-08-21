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
  colorOutput = ColorOutput.ON;

  group('Class A', () {
    setUpAll(() {
      a1 = A('a1');
      a1_copy = a1;
      a2 = A('a2');
    });

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
  });
}
