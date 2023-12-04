import 'package:logger/logger.dart';

final global_logger = () => Logger(
  printer: FileNamePrinter(),
  level: Level.verbose,
);
class FileNamePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    // Get the current call site
    StackTrace trace = StackTrace.current;
    // Get the file name from the call site
    String fileName = trace.toString().split('\n')[0].split(' ')[1];
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $fileName: $message')];
  }
}