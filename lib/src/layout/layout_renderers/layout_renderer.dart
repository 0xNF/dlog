import 'package:flog3/src/abstractions/irenderable.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:meta/meta.dart';
import 'package:flog3/src/log_event_info.dart';

abstract class LayoutRenderer implements IRenderable {
  bool get isInitialized;

  const LayoutRenderer();

  String get name;

  @override
  String render(LogEventInfo logEvent) {
    final builder = StringBuffer();
    // TODO(nf): initial and max sizes
    renderAppendBuilder(logEvent, builder);
    return builder.toString();
  }

  void renderAppendBuilder(LogEventInfo logEvent, StringBuffer builder) {
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

  @mustCallSuper
  void initialize() {}
}
