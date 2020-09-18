import 'package:minimal_test/minimal_test.dart';

class C {
  C(this.msg);
  final String msg;

  @override
  String toString() {
    return 'B: $msg';
  }
}

void main() {
  final c1 = C('c1');
  final c1_copy = c1;

  group('Class C', () {
    test('equality of copies', () async {
      expect(c1, c1_copy);
    });
  });
}
