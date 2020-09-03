import 'dart:io';

import 'package:minimal_test/minimal_test.dart';

class B {
  B(this.msg);
  final String msg;

  @override
  String toString() {
    return 'B: $msg';
  }
}

late B b1;
late B b1_copy;
late B b2;

void main() {
  sleep(Duration(seconds: 1));
  setUpAll(() {
    b1 = B('b1');
    b1_copy = b1;
    b2 = B('b2');
  });

  group('Class B', () {
    test('equality of copies', () async {
      expect(b1, b1_copy);
      throw 'TestException';
    });
  });
}
