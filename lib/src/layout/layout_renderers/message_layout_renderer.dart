import 'package:flog3/src/abstractions/istring_value_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class MessageLayoutRenderer extends LayoutRenderer implements IStringValueRenderer {
  static const String id = "message";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  /// String that separates message from the exception.
  final String exceptionSeparator;

  ///  Indicates whether to log exception along with message.
  final bool withException;

  ///  Render the unformatted input message without using input parameters
  final bool raw;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue(logEvent));
  }

  String _getValue(LogEventInfo logEvent) {
    final sb = StringBuffer();
    if (raw) {
      sb.write(logEvent.message);
    } else {
      logEvent.appendFormattedMessage(sb);
    }
    if (withException && logEvent.exception != null) {
      sb.write(exceptionSeparator);
      sb.write(logEvent.exception);
    }

    // TODO(nf): raw is currently ignored
    return sb.toString();
  }

  @override
  String? getFormattedString(LogEventInfo logEvent) {
    if (withException) {
      return null;
    } else if (raw) {
      return logEvent.message;
    } else {
      return logEvent.formattedMessage;
    }
  }

  const MessageLayoutRenderer({
    this.exceptionSeparator = "|",
    this.withException = true,
    this.raw = false,
  });

  factory MessageLayoutRenderer.fromToken(LayoutVariable variable) {
    String exceptionSeparator = "|";
    bool withException = true;
    bool raw = false;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "exceptionseparator":
          exceptionSeparator = lv.getValue<String>();
          break;
        case 'withexception':
          withException = lv.getValue<bool>();
          break;
        case 'raw':
          raw = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }

    return MessageLayoutRenderer(
      exceptionSeparator: exceptionSeparator,
      withException: withException,
      raw: raw,
    );
  }
}
