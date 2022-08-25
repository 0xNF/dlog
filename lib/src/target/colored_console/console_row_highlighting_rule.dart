import 'package:flog3/src/condition/condition_expression.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/target/specs/color.dart';

class ConsoleRowHighlightingRule {
  static final ConsoleRowHighlightingRule defaultt = ConsoleRowHighlightingRule(conditionExpression: null, foregroundColor: ConsoleColor.noChange, backgroundColor: ConsoleColor.noChange);

  final ConditionExpression? condition;
  final ConsoleColor foregroundColor;
  final ConsoleColor backgroundColor;

  ConsoleRowHighlightingRule({
    String? conditionExpression,
    required this.foregroundColor,
    required this.backgroundColor,
  }) : condition = conditionExpression == null ? null : ConditionExpression(expression: conditionExpression);

  bool checkCondition(LogEventInfo logEvent) {
    return condition?.evaluate(logEvent) ?? true;
  }
}
