/// Provides the recursive function `match` for comparing collections.
library matcher;

/// Type of a callback function used to register a custom matcher with `match`.
typedef IsMatching = bool Function(dynamic left, dynamic right);

/// Returns `true` if `left` matches `right`.
/// * Handles build-in collection objects recursively.
/// * Use the callback `isMatching` to register a custom matcher.
bool match(dynamic left, dynamic right, {IsMatching? isMatching}) {
  if (left == right) return true;

  if (left is Iterable && right is Iterable) {
    if (left.runtimeType != right.runtimeType) {
      if (left is List && right is List) {
        // Can't check the entry type of an empty list.
        if (left.isEmpty) return false;
      } else if (left is Set && right is Set) {
        // Can't check the entry type of an empty set.
        if (left.isEmpty) return false;
      } else {
        return false;
      }
    }
    if (left.length != right.length) return false;
    final lit = left.iterator;
    final rit = right.iterator;
    while (lit.moveNext() && rit.moveNext()) {
      if (!match(lit.current, rit.current)) return false;
    }
    return true;
  }
  if (left is Map && right is Map) {
    // Can't check key and value type of an empty map.
    if (left.runtimeType != right.runtimeType && left.isEmpty) return false;
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
