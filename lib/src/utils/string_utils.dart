import 'dart:math' show min;

extension StringBlock on String {
  /// Returns a quoted string formatted as a block.
  ///
  /// Example: `'Hello\nworld'` => `'\'Hello \\n\'\n\'world\''`
  String get block {
    if (isEmpty) {
      return '\'\'';
    }
    final lines = split('\n');
    if (lines.length == 1) {
      return '\'$this\'';
    }
    final out = <String>[];
    for (var line in lines) {
      out.add('\'$line');
    }
    return out.join('\\n\'\n') + '\'';
  }

  /// Difference operator.
  String operator -(String other) {
    final length = min(this.length, other.length);
    var i = 0;
    for (i; i < length; ++i) {
      if (this[i] != other[i]) {
        break;
      }
    }
    return (i == this.length) ? other.substring(i) : substring(i);
  }

  /// Returns an indented quoted string block.
  ///
  /// If `spaces` is 3 and `chars` is `_a`
  /// then each line of the string block will
  /// start with: `_a_a_a`.
  ///
  /// If `skipFirstLine` is `true` the first line will
  /// not be indented.
  String indentedBlock(
    int indentMultiplier, {
    String chars = ' ',
    bool skipFirstLine = false,
  }) {
    final indentString = chars * indentMultiplier;
    if (isEmpty) {
      return (skipFirstLine) ? '\'\'' : '$indentString\'\'';
    }
    final lines = split('\n');
    if (lines.length == 1) {
      return (skipFirstLine) ? '\'$this\'' : '$indentString\'$this\'';
    }
    final out = <String>[];
    for (var line in lines) {
      out.add('$indentString\'$line');
    }
    if (skipFirstLine) {
      out.first = '\'${lines.first}';
    }
    return out.join('\\n\'\n') + '\'';
  }

  /// Indents the current string by prefixing each
  /// line with `chars` (repeated `indentMultiplier` times).
  String indent(
    int indentMultiplier, {
    String chars = ' ',
    bool skipFirstLine = false,
  }) {
    var indentString = chars * indentMultiplier;
    if (isEmpty) {
      return (skipFirstLine) ? '' : '$indentString';
    }
    final lines = split('\n');
    if (lines.length == 1) {
      return (skipFirstLine) ? '$this' : '$indentString$this';
    }
    final out = <String>[];
    for (var line in lines) {
      out.add('$indentString$line');
    }
    if (skipFirstLine) {
      out[0] = lines[0];
    }
    return out.join('\n');
  }

  /// Returns the number of times `substring` is found in `this`.
  /// * Substrings are counted in a non-overlapping fashion.
  /// * Returns `1` if `substring` is the empty String.
  int countSubstring(String substring) {
    final skip = substring.length;
    var count = 0;
    var index = 0;

    do {
      index = indexOf(substring, index);
      if (index == -1) {
        break;
      } else {
        ++count;
        index += skip;
      }
    } while (index > 0);
    return count;
  }
}
