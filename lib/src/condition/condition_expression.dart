import 'package:flog3/src/log_event_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition_expression.g.dart';

@JsonSerializable()
class ConditionExpression {
  final String expression;

  const ConditionExpression({required this.expression});

  bool evaluate(LogEventInfo logEvent) {
    // TODO(nf)
    return false;
  }

  Map<String, dynamic> toJson() => _$ConditionExpressionToJson(this);
  factory ConditionExpression.fromJson(Map<String, dynamic> json) => _$ConditionExpressionFromJson(json);
}
