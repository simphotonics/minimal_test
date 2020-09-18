import 'package:minimal_test/minimal_test.dart';
import 'package:minimal_test/src/utils/string_utils.dart';

/// Testing functions and extensions provided by library `string_utils`.
void main() {
  group('block', () {
    test('empty', () {
      expect(''.block, '\'\'');
    });
    test('one-line', () {
      expect('First line.'.block, '\'First line.\'');
    });
    test('multi-line', () {
      expect(
          'First line.\nSecond line.'.block,
          '\'First line.\\n\'\n'
          '\'Second line.\'');
    });
  });

  group('countSubstring', () {
    test('empty', () {
      expect(''.countSubstring(''), 1);
      expect('This is one line'.countSubstring(''), 1);
    });
    test('one-line', () {
      expect('This is one line'.countSubstring('i'), 3);
    });
    test('multi-line', () {
      expect('First line\n Second line \n'.countSubstring('i'), 3);
    });
  });

  group('indent', () {
    test('empty', () {
      expect(''.indent(-1, chars: '&&'), '');
    });
    test('empty', () {
      expect(''.indent(3, chars: '_-'), '_-_-_-');
    });
    test('one-line', () {
      expect(
        'This is one line.'.indent(1, chars: '  '),
        '  This is one line.',
      );
    });
    test('multi-line', () {
      expect(
          'First line.\nSecond line.'.indent(
            2,
            chars: '_',
          ),
          '__First line.\n'
          '__Second line.');
    });
  });

  group('difference', () {
    test('empty', () {
      expect('' - '', '');
    });
    test('abc - \'\'', () {
      expect('abc' - '', 'abc');
    });
    test('abc - abc', () {
      expect('abc' - 'abc', '');
    });
    test('abcd - abc', () {
      expect('abcd' - 'abc', 'd');
    });
    test('abc - abcd', () {
      expect('abc' - 'abcd', 'd');
    });

    test('multi-line', () {
      expect(
          'First line.\nSecond line.' - 'First line,\nSecond line.',
          '.\n'
          'Second line.');
    });
  });

  group('indentedBlock', () {
    test('empty', () {
      expect(''.indentedBlock(-1, chars: ' '), '\'\'');
    });
    test('empty', () {
      expect(''.indentedBlock(3, chars: ' '), '   \'\'');
    });
    test('one-line', () {
      expect(
        'This is one line.'.indentedBlock(1, chars: '  '),
        '  \'This is one line.\'',
      );
    });
    test('multi-line', () {
      expect(
          'First line.\nSecond line.'.indentedBlock(
            2,
            chars: '_',
          ),
          '__\'First line.\\n\'\n'
          '__\'Second line.\'');
    });
  });
}
