import 'dart:io';

import 'package:flog3/src/layout/layout_renderers/all_event_properties_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/directory_separator_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/event_property_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/guid_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/hostname_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/level_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/literal_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/local_ip_layout_renderers.dart';
import 'package:flog3/src/layout/layout_renderers/logger_name_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/longdate_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/message_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/new_line_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/sequence_id_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/shortdate_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/time_layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:test/test.dart';

void main() {
  group('Sequential Renderer Tests', () {
    test("get a separator and a literal renderer", () {
      final parser = LayoutParser(source: r"${dir-separator}some-text");
      final rs = parser.parse();
      final lr1 = rs[0];
      assert(rs[0] is DirectorySeparatorLayoutRenderer);
      assert(rs[1] is LiteralLayoutRenderer);
      assert((rs[1] as LiteralLayoutRenderer).text == "some-text");
    });
  });
  group('Directory Separator renderer tests', () {
    test("get a Directory Separator renderer", () {
      final parser = LayoutParser(source: r"${dir-separator}");
      final lr = parser.parse().first;
      assert(lr is DirectorySeparatorLayoutRenderer);
    });
  });

  group('Newline renderer tests', () {
    test("get a New Line renderer", () {
      final parser = LayoutParser(source: r"${newline}");
      final lr = parser.parse().first;
      assert(lr is NewLineLayoutRenderer);
    });
  });

  group('Sequence renderer tests', () {
    test("get a SequenceId renderer", () {
      final parser = LayoutParser(source: r"${sequenceid}");
      final lr = parser.parse().first;
      assert(lr is SequenceIdRenderer);
    });
  });

  group('Literal Text renderer tests', () {
    test("get a Literal Text renderer", () {
      final parser = LayoutParser(source: r"'just|some|literal|text'");
      final lr = parser.parse().first;
      assert(lr is LiteralLayoutRenderer);
      final lrc = lr as LiteralLayoutRenderer;
      assert(lrc.text == "just|some|literal|text");
    });

    test("get an escaped text literal renderer", () {
      final parser = LayoutParser(source: r"${literal:text='${'}");
      final lr = parser.parse().first;
      assert(lr is LiteralLayoutRenderer);
      final lrc = lr as LiteralLayoutRenderer;
      assert(lrc.text == r"${");
    });
  });

  group('Loggername renderer tests', () {
    test("get a Logger Name renderer", () {
      final parser = LayoutParser(source: r"${loggername}");
      final lr = parser.parse().first;
      assert(lr is LoggerNameLayoutRenderer);
      final lrc = lr as LoggerNameLayoutRenderer;
      assert(!lrc.shortName);
    });

    test("get a Logger Name renderer with shortName", () {
      final parser = LayoutParser(source: r"${loggername:shortname=true}");
      final lr = parser.parse().first;
      assert(lr is LoggerNameLayoutRenderer);
      final lrc = lr as LoggerNameLayoutRenderer;
      assert(lrc.shortName);
    });
  });

  group('GUID renderer tests', () {
    test("get a GUID renderer", () {
      final parser = LayoutParser(source: r"${guid}");
      final lr = parser.parse().first;
      assert(lr is GuidLayoutRenderer);
      final lrc = lr as GuidLayoutRenderer;
      assert(lrc.format == GuidFormat.v4);
    });

    test("get a GUID v1 renderer", () {
      final parser = LayoutParser(source: r"${guid:format=v1}");
      final lr = parser.parse().first;
      assert(lr is GuidLayoutRenderer);
      final lrc = lr as GuidLayoutRenderer;
      assert(lrc.format == GuidFormat.v1);
    });

    test("get a GUID v4", () {
      final parser = LayoutParser(source: r"${guid:format=v4}");
      final lr = parser.parse().first;
      assert(lr is GuidLayoutRenderer);
      final lrc = lr as GuidLayoutRenderer;
      assert(lrc.format == GuidFormat.v4);
    });

    test("get a GUID using LogEvent", () {
      final parser = LayoutParser(source: r"${guid:generateFromLogEvent=true}");
      final lr = parser.parse().first;
      assert(lr is GuidLayoutRenderer);
      final lrc = lr as GuidLayoutRenderer;
      assert(lrc.generateFromLogEvent);
    });

    test("get a GUID using v5 with namespaces", () {
      final parser = LayoutParser(source: r"${guid:format=v5:namespace='https://example.com':guidname='somename'}");
      final lr = parser.parse().first;
      assert(lr is GuidLayoutRenderer);
      final lrc = lr as GuidLayoutRenderer;
      assert(lrc.format == GuidFormat.v5);
      assert(lrc.namespace == 'https://example.com');
      assert(lrc.guidname == 'somename');
    });
  });

  group('Level renderer tests', () {
    test("get a Level renderer", () {
      final parser = LayoutParser(source: r"${level}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.uppercase == false);
      assert(rl.format == LevelFormat.name);
    });

    test("Level renderer with uppercase true", () {
      final parser = LayoutParser(source: r"${level:uppercase=true}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.uppercase);
    });

    test("Level renderer with format Name", () {
      final parser = LayoutParser(source: r"${level:format=name}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.format == LevelFormat.name);
    });

    test("Level renderer with format FullName", () {
      final parser = LayoutParser(source: r"${level:format=fullname}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.format == LevelFormat.fullName);
    });

    test("Level renderer with format First Character", () {
      final parser = LayoutParser(source: r"${level:format=firstcharacter}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.format == LevelFormat.firstCharacter);
    });

    test("Level renderer with format Ordinal", () {
      final parser = LayoutParser(source: r"${level:format=ordinal:uppercase=true}");
      final r = parser.parse().first;
      assert(r is LevelLayoutRenderer);
      final rl = r as LevelLayoutRenderer;
      assert(rl.format == LevelFormat.ordinal);
      assert(rl.uppercase);
    });
  });

  group('Time renderer tests', () {
    test("get a Time renderer", () {
      final parser = LayoutParser(source: r"${time}");
      final r = parser.parse().first;
      assert(r is TimeLayoutRenderer);
      final rl = r as TimeLayoutRenderer;
      assert(!rl.universalTime);
    });

    test("get a Time renderer with universal", () {
      final parser = LayoutParser(source: r"${time:universaltime=true}");
      final r = parser.parse().first;
      assert(r is TimeLayoutRenderer);
      final rl = r as TimeLayoutRenderer;
      assert(rl.universalTime);
    });
  });

  group('ShortDate renderer tests', () {
    test("get a ShortDate renderer", () {
      final parser = LayoutParser(source: r"${shortdate}");
      final r = parser.parse().first;
      assert(r is ShortDateLayoutRenderer);
      final rl = r as ShortDateLayoutRenderer;
      assert(!rl.universalTime);
    });

    test("get a ShortDate renderer with universal", () {
      final parser = LayoutParser(source: r"${shortdate:universaltime=true}");
      final r = parser.parse().first;
      assert(r is ShortDateLayoutRenderer);
      final rl = r as ShortDateLayoutRenderer;
      assert(rl.universalTime);
    });
  });

  group('LongDate renderer tests', () {
    test("get a LongDate renderer", () {
      final parser = LayoutParser(source: r"${longdate}");
      final r = parser.parse().first;
      assert(r is LongDateLayoutRenderer);
      final rl = r as LongDateLayoutRenderer;
      assert(!rl.universalTime);
    });

    test("get a LongDate renderer with universal", () {
      final parser = LayoutParser(source: r"${longdate:universaltime=true}");
      final r = parser.parse().first;
      assert(r is LongDateLayoutRenderer);
      final rl = r as LongDateLayoutRenderer;
      assert(rl.universalTime);
    });
  });

  group('Hostname renderer tests', () {
    test("get a Hostname renderer", () {
      final parser = LayoutParser(source: r"${hostname}");
      final r = parser.parse().first;
      assert(r is HostnameLayoutRenderer);
    });
  });

  group('AllEventProperties renderer tests', () {
    test("get a AllEventProperties renderer", () {
      final parser = LayoutParser(source: r"${all-event-properties}");
      final r = parser.parse().first;
      assert(r is AllEventPropertiesLayoutRenderer);
      final lrc = r as AllEventPropertiesLayoutRenderer;
      assert(!lrc.includeEmptyValues);
      assert(lrc.exclude.isEmpty);
      assert(lrc.format == "[key]=[value]");
      assert(lrc.separator == ",");
    });

    test("get a AllEventProperties renderer with include empty", () {
      final parser = LayoutParser(source: r"${all-event-properties:includeemptyvalues=true}");
      final r = parser.parse().first;
      assert(r is AllEventPropertiesLayoutRenderer);
      final lrc = r as AllEventPropertiesLayoutRenderer;
      assert(lrc.includeEmptyValues);
    });

    test("get a AllEventProperties renderer with include empty", () {
      final parser = LayoutParser(source: r"${all-event-properties:separator='x'}");
      final r = parser.parse().first;
      assert(r is AllEventPropertiesLayoutRenderer);
      final lrc = r as AllEventPropertiesLayoutRenderer;
      assert(lrc.separator == 'x');
    });

    test("get a AllEventProperties renderer with exclude list", () {
      final parser = LayoutParser(source: r"${all-event-properties:exclude='x,y,z'}");
      final r = parser.parse().first;
      assert(r is AllEventPropertiesLayoutRenderer);
      final lrc = r as AllEventPropertiesLayoutRenderer;
      assert(lrc.exclude.length == 3);
    });

    test("get a AllEventProperties renderer with format", () {
      final parser = LayoutParser(source: r"${all-event-properties:format='[value]=[key]'}");
      final r = parser.parse().first;
      assert(r is AllEventPropertiesLayoutRenderer);
      final lrc = r as AllEventPropertiesLayoutRenderer;
      assert(lrc.format == "[value]=[key]");
    });
  });

  group('EventProperty renderer tests', () {
    test("get an EventProperty renderer", () {
      final parser = LayoutParser(source: r"${event-property:item=item1}");
      final r = parser.parse().first;
      assert(r is EventPropertyLayoutRenderer);
      final lrc = r as EventPropertyLayoutRenderer;
      assert(lrc.item == "item1");
      assert(lrc.ignoreCase);
      assert(lrc.objectPath == null);
    });

    test("get a AllEventProperties renderer with ignore case false", () {
      final parser = LayoutParser(source: r"${event-property:item=item5:ignorecase=false}");
      final r = parser.parse().first;
      assert(r is EventPropertyLayoutRenderer);
      final lrc = r as EventPropertyLayoutRenderer;
      assert(!lrc.ignoreCase);
    });

    test("get a AllEventProperties renderer with object path", () {
      final parser = LayoutParser(source: r"${event-property:item=item5:objectpath='$[0].name'}");
      final r = parser.parse().first;
      assert(r is EventPropertyLayoutRenderer);
      final lrc = r as EventPropertyLayoutRenderer;
      assert(lrc.objectPath == r'$[0].name');
    });
  });

  group('Message renderer tests', () {
    test("get a Message renderer", () {
      final parser = LayoutParser(source: r"${message}");
      final r = parser.parse().first;
      assert(r is MessageLayoutRenderer);
      final lrc = r as MessageLayoutRenderer;
      assert(lrc.exceptionSeparator == "|");
      assert(lrc.withException);
      assert(!lrc.raw);
    });

    test("get a Message renderer with new Exception Separator", () {
      final parser = LayoutParser(source: r"${message:exceptionSeparator='%'}");
      final r = parser.parse().first;
      assert(r is MessageLayoutRenderer);
      final lrc = r as MessageLayoutRenderer;
      assert(lrc.exceptionSeparator == "%");
    });

    test("get a Message renderer with new Exception Separator", () {
      final parser = LayoutParser(source: r"${message:withException=false}");
      final r = parser.parse().first;
      assert(r is MessageLayoutRenderer);
      final lrc = r as MessageLayoutRenderer;
      assert(!lrc.withException);
    });

    test("get a Message renderer with raw", () {
      final parser = LayoutParser(source: r"${message:raw=true}");
      final r = parser.parse().first;
      assert(r is MessageLayoutRenderer);
      final lrc = r as MessageLayoutRenderer;
      assert(lrc.withException);
    });
  });

  group('Local IP renderer tests', () {
    test("get a Local Ip renderer", () {
      final parser = LayoutParser(source: r"${local-ip}");
      final r = parser.parse().first;
      assert(r is LocalIPLayoutRenderer);
      final lrc = r as LocalIPLayoutRenderer;
      assert(lrc.addressFamily == InternetAddressType.any);
    });
    test("get a Local Ip renderer with different Addr family", () {
      final parser = LayoutParser(source: r"${local-ip:addressFamily=ipv6}");
      final r = parser.parse().first;
      assert(r is LocalIPLayoutRenderer);
      final lrc = r as LocalIPLayoutRenderer;
      assert(lrc.addressFamily == InternetAddressType.IPv6);
    });
  });
}
