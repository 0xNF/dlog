import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/target.dart';

abstract class TargetWithLayout extends Target {
  final Layout layout;

  TargetWithLayout({required super.spec, required super.config}) : layout = Layout.fromText(spec.layout, configuration: config);
}
