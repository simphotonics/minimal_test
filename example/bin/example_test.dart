import 'package:minimal_test/minimal_test.dart';

/// Custom object
class A {
  A(this.msg);
  final String msg;

  @override
  String toString() {
    return '$msg';
  }
}

/// Custom matcher for class A.
bool isMatchingA(left, right) {
  if (left is! A || right is! A) return false;
  return left.msg == right.msg;
}

void main() {
  final a1 = A('a1');
  final a1_copy = a1;
  final a2 = A('a2');
  final a3 = A('a1');

  group('Group of tests', () {
    test('Comparing copies', () {
      expect(a1, a1_copy); // Pass.
    });
    test('Comparing different objects', () {
      expect(a1, a2, reason: 'Expected to fail.'); // Fail.
    });
    test('Using custom matcher function.', () {
      expect(a1, a3, isMatching: isMatchingA); // Pass.
    });
  });
}
