import 'package:logger/logger.dart';

class MyLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    //return event.level == Level.error;
    return true;
  }
}

final log = Logger(
  output: ConsoleOutput(),
  filter: MyLogFilter(),
);

class ConsoleAndBugfenderOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      // ignore: avoid_print
      print(line);
    }
  }
}
