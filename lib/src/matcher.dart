/// Provides a recursive matcher function for comparing collections.
library matcher;

/// Function used to register a custom matcher with function `match`.
typedef IsMatching = bool Function(dynamic left, dynamic right);

/// Returns `true` if `left` matches `right`.
/// * Specify the matcher function `isEqual` to match custom objects.
/// * Handles build-in collection objects recursively.
/// * Use the callback `isEqual` to register a custom matcher.
bool match(dynamic left, dynamic right, {IsMatching? isMatching}) {
  if (left == right) return true;

  if (left is Iterable && right is Iterable) {
    if (left.runtimeType != right.runtimeType) return false;
    if (left.length != right.length) return false;
    final lit = left.iterator;
    final rit = right.iterator;
    while (lit.moveNext() && rit.moveNext()) {
      if (!match(lit.current, rit.current)) return false;
    }
    return true;
  }
  if (left is Map && right is Map) {
    if (left.length != right.length) return false;
    for (final key in left.keys) {
      if (!match(left[key], right[key])) return false;
    }
    return true;
  }

  if (isMatching != null) {
    if (isMatching(left, right)) {
      return true;
    } else {
      return false;
    }
  }

  return false;
}
