## 0.1.0

- Set min SDK version to 2.10.0. 

## 0.0.9

- Relaxed matching of lists, sets, and maps. For example,
 `match(<int>[1, 2], UnmodifiableListView([1, 2]))` returns `true` as does `match(<int>[1, 2], [1, 2]`.
- Note **empty** lists, sets, and maps only match if they have the same runtime type.
  For example: `match(<int>[], [])` returns `false`.

## 0.0.8

- Restructured `README.md`
- Changed output of function `expect()` to show non-matching strings.

## 0.0.7

- Added library `matcher.dart`.
- Enables comparing collections with matching entries.

## 0.0.6

- Set min SDK version to 2.9.0.

## 0.0.5

- Amended section usage.
- Set min SDK version to 2.10.0-0.0.beta.

## 0.0.5-nullsafety

- Amended links in `README.md`.
- Increased min SDK version.

## 0.0.4

- Applied pedantic lints.

## 0.0.3

- Added tests.

## 0.0.2

- Added color output.

## 0.0.1

- Initial version.