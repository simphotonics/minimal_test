/// Provides an ultra simple implementations of the functions:
/// * `test`, `group`, `setUpAll`, and `tearDownAll`.
///
/// To enable/disable color output use:
/// ```
/// // Enable color output.
/// colorOutput = ColorOutput.ON;
/// // Disable colour output.
/// colorOutput = ColorOutput.OFF;
/// ```
///
library simple_test;

export 'src/failed_test_exception.dart';
export 'src/simple_test_base.dart';
export 'src/color_options.dart';
