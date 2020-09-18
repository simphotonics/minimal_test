import 'dart:collection';

import 'package:minimal_test/minimal_test.dart';

class A {
  A(this.index, this.name);
  final int index;
  final String name;
}

bool isMatchingA(left, right) {
  if (left is! A || right is! A) return false;
  return left.index == right.index && left.name == right.name;
}

class B {
  B(this.list);
  final List<int> list;
}

bool isMatchingB(left, right) {
  if (left is! B || right is! B) return false;
  return match(left.list, right.list);
}

final _set = {1, 2, 3};
final _list = [1, 2, 3];
final _map = {1: 'one', 2: 'two'};
final _hashMap = HashMap<int, String>.from(_map);
final _splayTreeMap = SplayTreeMap<int, String>.from(_map);
final _listView = UnmodifiableListView(_list);

/// Matcher tests.
void main() {
  group('Collection', () {
    test('Different types', () {
      expect(match(0, []), false);
      expect(match(<int>[], <double>[]), false);
      expect(match(<int>[], []), false);
    });
    test('Same type', () {
      expect(match([], []), true);
      expect(match(<int>[], <int>[]), true);
    });
    test('List [1,2,3]', () {
      expect(match(_list, [1, 2, 3]), true);
    });
    test('Set {1,2,3}', () {
      expect(match(_set, {1, 2, 3}), true);
      expect(match(_set, {}), false);
      expect(match({}, {}), true);
      expect(match(<int>{}, {}), false);
    });
    test('Map {1: \'one\', 2: \'two\'}', () {
      expect(match(_map, {1: 'one', 2: 'two'}), true);
      expect(match(<int,dynamic>{}, {}), false);
    });
    test('HashMap {1: \'one\', 2: \'two\'}', () {
      expect(match(_hashMap, {1: 'one', 2: 'two'}), true);
    });
    test('SplayTreeMap: {1: \'one\', 2: \'two\'}', () {
      expect(match(_splayTreeMap, {1: 'one', 2: 'two'}), true);
    });
    test('UnmodifiableListView [1,2,3]', () {
      expect(match(_listView, [1, 2, 3]), true);
    });

    test('Map<int,List<int>>', () {
      expect(
          match(
            {
              1: [10, 11],
              2: [12, 13]
            },
            {
              1: [10, 11],
              2: [12, 13]
            },
          ),
          true);
    });
  });

  group('Custom objects', () {
    test('Class A', () {
      expect(
          match(
            A(27, 'twentyseven'),
            A(27, 'twentyseven'),
            isMatching: isMatchingA,
          ),
          true);
    });
    test('Class B', () {
      expect(
          match(
            B([1, 2]),
            B([1, 2]),
            isMatching: isMatchingB,
          ),
          true);
    });
  });
}
