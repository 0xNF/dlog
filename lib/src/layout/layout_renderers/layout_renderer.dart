import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';

abstract class LayoutRenderer {
  const LayoutRenderer();

  String render(LogEventInfo logEvent) {
    final builder = StringBuffer();
    // TODO(nf): initial and max sizes
    renderAppenBuilder(logEvent, builder);
    return builder.toString();
  }

  void renderAppenBuilder(LogEventInfo logEvent, StringBuffer builder) {
    try {
      append(builder, logEvent);
    } on Exception catch (e) {
      internalLogger.error('failed to append to layout renderer', exception: e);
      if (mustRethrowExceptionImmediately(e)) {
        rethrow;
      }
    }
  }

  void append(StringBuffer builder, LogEventInfo logEvent);
}
