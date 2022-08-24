import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/target_with_layout.dart';

abstract class TargetWithLayoutHeaderAndFooter extends TargetWithLayout {
  final Layout header;
  final Layout footer;

  TargetWithLayoutHeaderAndFooter({required super.spec, required super.config})
      : header = Layout.fromText(spec.header, configuration: config),
        footer = Layout.fromText(spec.footer, configuration: config);
}