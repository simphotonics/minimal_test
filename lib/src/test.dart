typedef Body = void Function();
typedef Setup = dynamic Function();
typedef Teardown = dynamic Function();

/// Class representing a test.
class Test {
  Test(this.description, this.body);

  /// Test description.
  final String description;

  /// Test body.
  final Body body;

  void call() {
    body();
  }

  @override
  String toString() => 'Test: $description';
}

/// Class representing a test group.
class TestGroup {
  TestGroup(
    this.description, {
    this.setup,
    this.teardown,
    this.isRandom = false,
  });

  /// Group description.
  final String description;

  /// Tests registered with the group.
  final _tests = <Test>[];

  /// Function run before any tests.
  final Setup? setup;

  /// Function run after any tests.
  final Teardown? teardown;

  /// Determines if tests are run in random order.
  final bool isRandom;

  /// Adds a test to the test group.
  void add(Test test) => _tests.add(test);

  /// Calls the function `setup` followed by
  /// the registered test functions and finally `teardown`.
  void call() {
    if (setup != null) setup!();
    if (isRandom) {
      for (final test in _tests..shuffle()) {
        test();
      }
    } else {
      for (final test in _tests) {
        test();
      }
    }
    if (teardown != null) teardown!();
  }

  @override
  String toString() {
    final b = StringBuffer();
    b.writeln('Group: $description');
    for (var test in _tests) {
      b.writeln('    $test');
    }
    return b.toString();
  }
}

/// Represents an executable test file containing test groups.
class TestFile {
  TestFile(
    this.path, {
    this.isRandom = false,
    this.setupAll,
    this.teardownAll,
  }) {
    _groups.add(_default);
    _current = _default;
  }

  /// Path to the test file.
  final String path;

  /// The registered test groups.
  final _groups = <TestGroup>[];

  /// The default test group. Contains tests
  /// declared outside a test group.
  final _default = TestGroup('default');

  /// The current test group.
  // ignore: unused_field
  late TestGroup _current;

  /// The setup function called before each test.
  final Setup? setupAll;

  /// The teardown function called after each test.
  final Teardown? teardownAll;

  /// Determines if the groups are called in random order.
  final bool isRandom;

  /// Adds a group to the test file.
  void addGroup(TestGroup group) {
    _groups.add(group);
    _current = group;
  }

  /// Signals that we are leaving a test group.
  /// Is called before exiting the body of a `group` function.
  void leaveGroup() {
    _current = _default;
  }

  /// Adds a test to the current test group.
  void addTest(Test test) {
    _current.add(test);
  }

  /// Calls the registered test group functions.
  void call() {
    if (isRandom) {
      for (final group in _groups..shuffle()) {
        group();
      }
    } else {
      for (final group in _groups) {
        group();
      }
    }
  }

  @override
  String toString() {
    final b = StringBuffer();
    b.writeln('');
    b.writeln('TestFile: $path');
    for (var group in _groups) {
      b.write('  $group');
    }
    return b.toString();
  }
}
