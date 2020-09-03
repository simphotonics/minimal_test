import 'dart:async';
import 'dart:io';
import 'dart:isolate';

/// Class holding a command [cmd] and its [options].
///
/// Used to start a process in an isolate.
class Command {
  const Command(
    this.cmd,
    this.options,
    this.sendPort,
  );
  final String cmd;
  final List<String> options;
  final SendPort sendPort;
}

/// Helper class used to spawn an isolate and run a process in it.
///
/// The result of the process is available via the getter `result`.
class Worker {
  Worker({
    required this.cmd,
    required this.options,
  });

  /// The command used to start a process in the isolate.
  final String cmd;

  /// The command options used together with `cmd` to
  /// start a process in the isolate.
  final List<String> options;

  /// The receive port used to receive message from the isolate.
  final _receivePort = ReceivePort();

  /// The isolate used by the instance of `TestWorker`.
  Isolate? _isolate;

  /// Kills the isolate and cancels stream subscriptions.
  void dispose() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
      _receivePort.close();
    }
  }

  /// Starts an isolate and launches the process
  /// specified by [cmd].
  Future<ProcessResult> get result async {
    _isolate = await Isolate.spawn(
        entryPoint,
        Command(
          cmd,
          options,
          _receivePort.sendPort,
        ),
        debugName: 'Iso: $cmd $options');

    return await _receivePort.firstWhere(
      (item) => item is ProcessResult,
    ) as ProcessResult;
  }

  /// Isolate entry point.
  ///
  /// Start the process specified by command.
  static void entryPoint(Command command) async {
    final result = await Process.run(command.cmd, command.options);
    command.sendPort.send(result);
  }
}

/// Usage of TestWorker.
// void main() async {
//   stdout.writeln('spawning isolate...');

//   final testWorker = Worker(cmd: 'dart', options: [
//     '--enable-experiment=non-nullable',
//     'test/class_a_test.dart',
//   ]);
//   final result = await testWorker.result;
//   print(result.stdout);
//   print(result.stderr);

//   stdout.writeln('press enter key to quit...');
//   await stdin.first;
//   testWorker.dispose();
//   stdout.writeln('goodbye!');
//   exit(0);
// }
