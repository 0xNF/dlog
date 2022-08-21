import 'package:flog3/src/variable/variable_spec.dart';

class Variable {
  final String name;
  final String value;

  const Variable({required this.name, required this.value});

  factory Variable.fromSpec(VariableSpec spec) {
    return Variable(name: spec.name, value: spec.value);
  }
}
