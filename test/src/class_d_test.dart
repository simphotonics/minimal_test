import 'package:minimal_test/minimal_test.dart';

class D {
  D(this.msg);
  final String msg;

  @override
  String toString() {
    return 'B: $msg';
  }
}

bool isMatchingD(left, right) {
  if (left is! D || right is! D) return false;
  return left.msg == right.msg;
}

late D d1;
late D d1_copy;
late D d2;

void main() {
  setUpAll(() {
    d1 = D('d1');
    d1_copy = d1;
    d2 = D('d1');
  });

  group('Class D', () {
    test('equality of copies', () async {
      expect(d1, d1_copy);
      expect(d1, d2, reason: 'Same content different objects.');
      expect(d1, d2, reason: 'Uses custom matcher', isMatching: isMatchingD);
    });
  });
}
