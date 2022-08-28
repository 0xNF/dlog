import 'dart:io';

import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';
import 'package:flog3/src/log_event_info.dart';

///The local IP address whether IPv4 or IPv6 from NetworkInterface.List
class LocalIPLayoutRenderer extends LayoutRenderer {
  static const id = "local-ip";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  /// Explicitly prioritize IP addresses from a certain AddressFamily (Ex. IPv4 / IPv6)
  final InternetAddressType addressFamily;

  const LocalIPLayoutRenderer({
    this.addressFamily = InternetAddressType.any,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    // TODO(nf): what to do about async values
    _getValue(logEvent).then((value) => builder.write(value));
  }

  Future<String> _getValue(LogEventInfo logEvent) async {
    final lst = await NetworkInterface.list(type: addressFamily);
    return lst.firstOrNull?.addresses.firstOrNull?.address ?? "";
  }

  factory LocalIPLayoutRenderer.fromToken(LayoutVariable variable) {
    InternetAddressType addressFamily = InternetAddressType.any;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "addressfamily":
          final s = lv.getValue<String>().toLowerCase();
          final val = [InternetAddressType.IPv4, InternetAddressType.IPv6, InternetAddressType.any, InternetAddressType.unix].firstWhereOrNull((element) => element.name.toLowerCase() == s);
          addressFamily = val ?? addressFamily;
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return LocalIPLayoutRenderer(
      addressFamily: addressFamily,
    );
  }
}
