import 'package:minimal_test/minimal_test.dart';

class C {
  C(this.msg);
  final String msg;

  @override
  String toString() {
    return 'B: $msg';
  }
}

late C c1;
late C c1_copy;
late C c2;

void main() {
  setUpAll(() {
    c1 = C('c1');
    c1_copy = c1;
    c2 = C('c2');
  });

  group('Class C', () {
    test('equality of copies', () async {
      expect(c1, c1_copy);
    });
  });
}
