import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/layout/layout_with_header_and_footer.dart';
import 'package:flog3/src/target/target_with_layout.dart';

abstract class TargetWithLayoutHeaderAndFooter extends TargetWithLayout {
  Layout? header;
  Layout? footer;

  TargetWithLayoutHeaderAndFooter({required super.spec, required LogConfiguration config}) : super(config: config) {
    if (layout is LayoutWithHeaderAndFooter) {
      final lhf = layout as LayoutWithHeaderAndFooter;
      header = lhf.header;
      footer = lhf.footer;
    } else {
      header = spec.header == null ? null : Layout.fromSpec(spec.header!, configuration: config);
      header = spec.footer == null ? null : Layout.fromSpec(spec.footer!, configuration: config);
    }
  }
}
