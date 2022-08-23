import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/target.dart';

// abstract class TargetWithLayoutHeaderAndFooter extends Target {
//   Layout get header => _layoutHF.header;
//   Layout get footer => _layoutHF.footer;
//   @override
//   Layout get layout => _layoutHF.layout;

//   final LayoutWithHeaderAndFooter _layoutHF;

//   TargetWithLayoutHeaderAndFooter();
// }

// class LayoutWithHeaderAndFooter extends Layout {
//   final Layout layout;
//   final Layout header;
//   final Layout footer;

//   LayoutWithHeaderAndFooter({
//     required super.source,
//     required super.configuration,
//     required super.renderers,
//   });

//   @override
//   String render(LogEventInfo logEvent) {
//     return layout.render(logEvent);
//   }
// }
