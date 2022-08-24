import 'dart:io';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/all_event_properties_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/directory_separator_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/event_property_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/guid_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/hostname_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
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
import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");
  final basic = LogFactory.getLogger('SomeLogger') as FLogger;

  final LogEventInfo logEventInfo = LogEventInfo(
    level: LogLevel.info,
    loggerName: basic.name,
    timeStamp: DateTime.parse("2002-12-31T14:56:02.6666-0500"),
    stackTrace: StackTrace.current,
    exception: Exception("Some kind of exception"),
    eventProperties: {
      "propStr": "someString",
      "propBool": true,
      "propInt": -10,
      "propDouble": 3.5,
      "propMap": <String, String>{
        "mapEntry1": "me1",
        "mapEntry2": "me2",
      },
      "propList": <int>[1, 2, 3],
      "emptyString": "",
      "emptyNull": null,
      "emptyList": <int>[],
      "emptyMap": <String, dynamic>{},
    },
    messageFormatter: null,
    message: "hello friend",
  );

  group(r'Test ${dir-separator} Renderer', () {
    final LayoutRenderer t = DirectorySeparatorLayoutRenderer();

    setUp(() {});

    test('check path output', () {
      String output = t.render(logEventInfo);
      if (Platform.isWindows) {
        expect(output, r"\");
      } else {
        expect(output, "/");
      }
    });
  });

  group(r'Test ${all-event-properties} Renderer', () {
    setUp(() {});

    test('Check default format, default separator, default include empty, no exclude', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(output, 'propStr="someString",propBool=true,propInt=-10,propDouble=3.5,propMap={"mapEntry1":"me1","mapEntry2":"me2"},propList=[1,2,3]');
    });

    test('Check kvp format', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer(format: '[key]:[value]');
      String output = t.render(logEventInfo);
      expect(output, 'propStr:"someString",propBool:true,propInt:-10,propDouble:3.5,propMap:{"mapEntry1":"me1","mapEntry2":"me2"},propList:[1,2,3]');
    });

    test('Check separator', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer(separator: ';');
      String output = t.render(logEventInfo);
      expect(output, 'propStr="someString";propBool=true;propInt=-10;propDouble=3.5;propMap={"mapEntry1":"me1","mapEntry2":"me2"};propList=[1,2,3]');
    });

    test('Check include empty', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer(includeEmptyValues: true);
      String output = t.render(logEventInfo);
      expect(output, 'propStr="someString",propBool=true,propInt=-10,propDouble=3.5,propMap={"mapEntry1":"me1","mapEntry2":"me2"},propList=[1,2,3],emptyString="",emptyNull=null,emptyList=[],emptyMap={}');
    });

    test('Check exclude', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer(exclude: ['propMap', 'propList']);
      String output = t.render(logEventInfo);
      expect(output, 'propStr="someString",propBool=true,propInt=-10,propDouble=3.5');
    });

    test('Check non-existant exclude', () {
      final LayoutRenderer t = AllEventPropertiesLayoutRenderer(exclude: ['DNE']);
      String output = t.render(logEventInfo);
      expect(output, 'propStr="someString",propBool=true,propInt=-10,propDouble=3.5,propMap={"mapEntry1":"me1","mapEntry2":"me2"},propList=[1,2,3]');
    });
  });

  group(r'Test ${event-property} Renderer', () {
    setUp(() {});

    test('check item', () {
      final LayoutRenderer t = EventPropertyLayoutRenderer(item: 'propstr');
      String output = t.render(logEventInfo);
      expect(output, "someString");
    });

    test('check item does not exist', () {
      final LayoutRenderer t = EventPropertyLayoutRenderer(item: 'dne');
      String output = t.render(logEventInfo);
      expect(output, "");
    });

    test('check item preserve case', () {
      final LayoutRenderer t = EventPropertyLayoutRenderer(item: 'propstr', ignoreCase: false);
      String output = t.render(logEventInfo);
      expect(output, "");
    });

    test('check object path root', () {
      final LayoutRenderer t = EventPropertyLayoutRenderer(item: 'propMap', objectPath: r'$');
      String output = t.render(logEventInfo);
      expect(output, '{"mapEntry1":"me1","mapEntry2":"me2"}');
    });

    test('check object path nested', () {
      // TODO(nf): JSONPath syntax is NYI
      final LayoutRenderer t = EventPropertyLayoutRenderer(item: 'propMap', objectPath: r'$.mapEntry');
      String output = t.render(logEventInfo);
      expect(output, 'me1');
    }, skip: true);
  });

  group(r'Test ${guid} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = GuidLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(Uuid.isValidUUID(fromString: output), true);
    });

    test('check uuid.v1', () {
      final LayoutRenderer t = GuidLayoutRenderer(format: GuidFormat.v1);
      String output = t.render(logEventInfo);
      expect(Uuid.isValidUUID(fromString: output), true);
    });

    test('check uuid.v4', () {
      final LayoutRenderer t = GuidLayoutRenderer(format: GuidFormat.v4);
      String output = t.render(logEventInfo);
      expect(Uuid.isValidUUID(fromString: output), true);
    });

    test('check uuid.v5', () {
      final LayoutRenderer t = GuidLayoutRenderer(format: GuidFormat.v5, namespace: Uuid.NAMESPACE_DNS, guidname: 'www.example.com');
      String output = t.render(logEventInfo);
      expect(Uuid.isValidUUID(fromString: output), true);
    });

    /// TODO(NF): generate from log event is NYI
    test('check generate from log event', () {
      final LayoutRenderer t = GuidLayoutRenderer(generateFromLogEvent: true);
      String output = t.render(logEventInfo);
      expect(Uuid.isValidUUID(fromString: output, validationMode: ValidationMode.nonStrict), true);
    }, skip: true);
  });

  group(r'Test ${hostname} Renderer', () {
    final String hostName = Platform.localHostname;
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = HostnameLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(output, hostName);
    });
  });

  group(r'Test ${liteal} Renderer', () {
    final String hostName = Platform.localHostname;
    setUp(() {});

    test('check regular text', () {
      final LayoutRenderer t = LiteralLayoutRenderer(text: "hello");
      String output = t.render(logEventInfo);
      expect(output, "hello");
    });

    test('check escaped layout text', () {
      final LayoutRenderer t = LiteralLayoutRenderer(text: r"${stuff");
      String output = t.render(logEventInfo);
      expect(output, r"${stuff");
    });
  });

  group(r'Test ${level} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = LevelLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(output, "Info");
    });

    test('check uppercase', () {
      final LayoutRenderer t = LevelLayoutRenderer(uppercase: true);
      String output = t.render(logEventInfo);
      expect(output, "INFO");
    });

    test('check fullName', () {
      final LayoutRenderer t = LevelLayoutRenderer(format: LevelFormat.fullName);
      String output = t.render(logEventInfo);
      expect(output, "Information");
    });

    test('check first character', () {
      final LayoutRenderer t = LevelLayoutRenderer(format: LevelFormat.firstCharacter);
      String output = t.render(logEventInfo);
      expect(output, "I");
    });

    test('check ordinal', () {
      final LayoutRenderer t = LevelLayoutRenderer(format: LevelFormat.ordinal);
      String output = t.render(logEventInfo);
      expect(output, "2");
    });
  });

// TODO(nf): local-ip does stuff async and we haveno good answer to that yet
  group(
    r'Test ${local-ip} Renderer',
    () {
      setUp(() {});

      test('check default', () {
        final LayoutRenderer t = LocalIPLayoutRenderer();
        String output = t.render(logEventInfo);
        expect(InternetAddress.tryParse(output) != null, true);
      }, skip: true);

      test('check IPv4', () {
        final LayoutRenderer t = LocalIPLayoutRenderer(addressFamily: InternetAddressType.IPv4);
        String output = t.render(logEventInfo);
        expect(InternetAddress.tryParse(output)!.type, InternetAddressType.IPv4);
      });

      test('check IPv6', () {
        final LayoutRenderer t = LocalIPLayoutRenderer(addressFamily: InternetAddressType.IPv6);
        String output = t.render(logEventInfo);
        expect(InternetAddress.tryParse(output)!.type, InternetAddressType.IPv6);
      });
    },
    skip: true,
  );

  group(r'Test ${loggername} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = LoggerNameLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(output, "SomeLogger");
    });

    test('check Short Name', () {
      final LayoutRenderer t = LoggerNameLayoutRenderer(shortName: true);
      String output = t.render(logEventInfo);
      expect(output, "SomeLogger");
    });
  });

  group(r'Test ${time} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = TimeLayoutRenderer();
      String output = t.render(logEventInfo);
      final hourLocal = logEventInfo.timeStamp.toLocal().hour.toString().padLeft(2, '0');
      expect(output, "$hourLocal:56:02.6660");
      final hourUTC = logEventInfo.timeStamp.toUtc().hour.toString().padLeft(2, '0');
      expect(output != "$hourUTC:56:02.6660", true);
    });

    test('check Universal Time', () {
      final LayoutRenderer t = TimeLayoutRenderer(universalTime: true);
      String output = t.render(logEventInfo);
      final hourLocal = logEventInfo.timeStamp.toLocal().hour.toString().padLeft(2, '0');
      expect(output != "$hourLocal:56:02.6660", true);
      final hourUTC = logEventInfo.timeStamp.toUtc().hour.toString().padLeft(2, '0');
      expect(output, "$hourUTC:56:02.6660");
    });
  });

  group(r'Test ${shortdate} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = ShortDateLayoutRenderer();
      String output = t.render(logEventInfo);
      final time = logEventInfo.timeStamp.toLocal();
      final fmtd = "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
      expect(output, fmtd);
    });

    test('check Universal Time', () {
      final LayoutRenderer t = ShortDateLayoutRenderer(universalTime: true);
      String output = t.render(logEventInfo);
      final time = logEventInfo.timeStamp.toUtc();
      final fmtd = "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}";
      expect(output, fmtd);
    });
  });

  group(r'Test ${longdate} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = LongDateLayoutRenderer();
      String output = t.render(logEventInfo);
      final time = logEventInfo.timeStamp.toLocal();
      final fmtd =
          "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}.${time.millisecond.toString().padRight(4, '0')}";
      expect(output, fmtd);
    });

    test('check Universal Time', () {
      final LayoutRenderer t = LongDateLayoutRenderer(universalTime: true);
      String output = t.render(logEventInfo);
      final time = logEventInfo.timeStamp.toUtc();
      final fmtd =
          "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}.${time.millisecond.toString().padRight(4, '0')}";
      expect(output, fmtd);
    });
  });

  group(r'Test ${sequenceid} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = SequenceIdRenderer();
      String output = t.render(logEventInfo);
      expect(output, "1");
    });
  });

  group(r'Test ${newline} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = NewLineLayoutRenderer();
      String output = t.render(logEventInfo);
      if (Platform.isWindows) {
        expect(output, "\r\n");
      } else {
        expect(output, "\n");
      }
    });
  });

  group(r'Test ${message} Renderer', () {
    setUp(() {});

    test('check default', () {
      final LayoutRenderer t = MessageLayoutRenderer();
      String output = t.render(logEventInfo);
      expect(output, "hello friend|Exception: Some kind of exception");
    });

    test('check exception separator', () {
      final LayoutRenderer t = MessageLayoutRenderer(exceptionSeparator: '%');
      String output = t.render(logEventInfo);
      expect(output, "hello friend%Exception: Some kind of exception");
    });

    test('check without exception', () {
      final LayoutRenderer t = MessageLayoutRenderer(withException: false);
      String output = t.render(logEventInfo);
      expect(output, "hello friend");
    });

    /// TODO(nf): what should raw even do
    test('check raw', () {
      final LayoutRenderer t = MessageLayoutRenderer(raw: true);
      String output = t.render(logEventInfo);
      expect(output, "hello friend");
    }, skip: true);
  });
}
