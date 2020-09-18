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

void main() {
  sleep(Duration(microseconds: 20));

  final b1 = B('b1');
  final b1_copy = b1;
  
  group('Class B', () {
    test('equality of copies', () async {
      expect(b1, b1_copy);
      throw 'TestException';
    });
  });
}
