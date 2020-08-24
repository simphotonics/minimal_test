import 'dart:io';

void main(List<String> args) {
  shell(args[0], args.getRange(1, args.length).toList());
  print(args);
}

void shell(
  String cmd,
  List<String> opts,
) {
  // List all files in the current directory in UNIX-like systems.
  Process.run(cmd, opts).then((ProcessResult results) {
    print(results.stdout);
  });
}
