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
import 'package:flog3/src/layout/parser/layout_token.dart';
import 'package:flog3/src/layout/parser/tokenizer/layout_tokenizer.dart';
import 'package:flog3/src/layout/parser/tokenizer/layout_tokens.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';

class LayoutVariable {
  final String variableName;
  final LayoutType layoutType;
  final Object value;

  LayoutVariable(this.variableName, this.layoutType, this.value);

  T getValue<T>() {
    if (value is LayoutVariable) {
      return (value as LayoutVariable).getValue<T>();
    }
    return value as T;
  }
}

enum LayoutType {
  bool,
  int,
  double,
  string,
  layout,
  enumeration,
}

LayoutRenderer _reifyLayoutParser(LayoutVariable lv) {
  if (lv.layoutType == LayoutType.layout) {
    switch (lv.variableName.toLowerCase()) {
      case NewLineLayoutRenderer.id:
        return NewLineLayoutRenderer.fromToken(lv);
      case DirectorySeparatorLayoutRenderer.id:
        return DirectorySeparatorLayoutRenderer.fromToken(lv);
      case SequenceIdRenderer.id:
        return SequenceIdRenderer.fromToken(lv);
      case LoggerNameLayoutRenderer.id:
        return LoggerNameLayoutRenderer.fromToken(lv);
      case GuidLayoutRenderer.id:
        return GuidLayoutRenderer.fromToken(lv);
      case LevelLayoutRenderer.id:
        return LevelLayoutRenderer.fromToken(lv);
      case TimeLayoutRenderer.id:
        return TimeLayoutRenderer.fromToken(lv);
      case ShortDateLayoutRenderer.id:
        return ShortDateLayoutRenderer.fromToken(lv);
      case LongDateLayoutRenderer.id:
        return LongDateLayoutRenderer.fromToken(lv);
      case HostnameLayoutRenderer.id:
        return HostnameLayoutRenderer.fromToken(lv);
      case AllEventPropertiesLayoutRenderer.id:
        return AllEventPropertiesLayoutRenderer.fromToken(lv);
      case EventPropertyLayoutRenderer.id:
        return EventPropertyLayoutRenderer.fromToken(lv);
      case MessageLayoutRenderer.id:
        return MessageLayoutRenderer.fromToken(lv);
      case LocalIPLayoutRenderer.id:
        return LocalIPLayoutRenderer.fromToken(lv);
      case LiteralLayoutRenderer.id:
      default:
        return LiteralLayoutRenderer.fromToken(lv);
    }
    /* match the renderer types */
  } else {
    /* everything else gets a literal */
    return LiteralLayoutRenderer.fromToken(lv);
  }
}

class LayoutParser {
  final String source;

  final List<Token> _tokens = [];
  int _position = -1;
  Token? _currentToken;

  LayoutParser({required this.source});

  List<LayoutRenderer> parse() {
    final tokenizer = LayoutTokenizer(reader: StringReader(str: source));
    _tokens.clear();
    _tokens.addAll(tokenizer.tokenize());

    final vars = <LayoutVariable>[];

    while (!_isEOF()) {
      final v = _getNextToken();
      vars.add(v);
    }

    final renderers = vars.map((e) => _reifyLayoutParser(e)).toList();

    return renderers;
  }

  bool _isEOF() {
    return (_position + 1) >= _tokens.length;
  }

  LayoutVariable _getNextToken() {
    Token t = _readToken();
    if (t.tokenType == LayoutTokenType.dollarsign) {
      return _parseLayoutRenderer();
    }
    if (t.tokenType == LayoutTokenType.colon) {
      return _parseKvp();
    }
    // TODO(nf) comma separated lists
    return _parseValue();
  }

  LayoutVariable _parseLayoutRenderer() {
    final vars = <LayoutVariable>[];
    _expect(LayoutTokenType.openCurleyBrace);
    Token t = _readToken();
    if (t.tokenType != LayoutTokenType.keyword) {
      throw LayoutParserException("Expected keyword, got ${t.value}", t);
    }
    final layoutKind = t.value;
    if (!_isKnownLayout(layoutKind)) {
      throw LayoutParserException("Unknown LayoutParser value. Got $layoutKind", t);
    }
    while (_peekToken().tokenType != LayoutTokenType.closingCurlyBrace) {
      final lv = _getNextToken();
      vars.add(lv);
    }
    _eatToken();

    return LayoutVariable(layoutKind, LayoutType.layout, vars);
  }

  void _expect(LayoutTokenType tokenType) {
    _eatToken();
    if (_currentToken == null || _currentToken!.tokenType != tokenType) {
      throw LayoutParserException("Cannot read past end of input", Token(LayoutTokenType.endOfInput, _currentToken?.location ?? 0, ""));
    }
  }

  void _eatToken() {
    _readToken();
  }

  LayoutVariable _parseKvp() {
    String key;
    LayoutVariable value;
    Token t = _readToken();
    key = t.value;
    if (t.tokenType != LayoutTokenType.keyword) {
      throw LayoutParserException("Expected keyword, got ${t.tokenType}", t);
    }
    _expect(LayoutTokenType.equalTo);
    value = _getNextToken();
    return LayoutVariable(key, value.layoutType, value);
  }

  Token _readToken() {
    _position++;
    _currentToken = _tokens[_position];
    return _currentToken!;
  }

  Token _peekToken() {
    return _tokens[_position + 1];
  }

  /// TODO(nf): load dynamic layout renderers into here
  bool _isKnownLayout(String val) {
    final vlower = val.toLowerCase();
    return const [
      DirectorySeparatorLayoutRenderer.id,
      GuidLayoutRenderer.id,
      LevelLayoutRenderer.id,
      LiteralLayoutRenderer.id,
      LoggerNameLayoutRenderer.id,
      NewLineLayoutRenderer.id,
      SequenceIdRenderer.id,
      TimeLayoutRenderer.id,
      ShortDateLayoutRenderer.id,
      LongDateLayoutRenderer.id,
      HostnameLayoutRenderer.id,
      AllEventPropertiesLayoutRenderer.id,
      EventPropertyLayoutRenderer.id,
      MessageLayoutRenderer.id,
      LocalIPLayoutRenderer.id,
    ].map((e) => e.toLowerCase()).contains(vlower);
  }

  LayoutVariable _parseValue() {
    final t = _currentToken!;
    Object val = "";
    LayoutType ltype = LayoutType.string;
    if (t.tokenType == LayoutTokenType.keyword) {
      final s = t.value.toLowerCase();
      if (s == 'true') {
        val = true;
        ltype = LayoutType.bool;
      } else if (s == 'false') {
        val = false;
        ltype = LayoutType.bool;
      } else {
        ltype = LayoutType.enumeration;
        val = t.value;
      }
    } else if (t.tokenType == LayoutTokenType.number) {
      final i = int.tryParse(t.value);
      if (i != null) {
        ltype = LayoutType.int;
        val = i;
      } else {
        // tOOD(nf): handle [minus]+{number} for negative
        final d = double.tryParse(t.value);
        if (d != null) {
          ltype = LayoutType.double;
          val = d;
        }
        throw LayoutParserException("Expected a number but got ${t.value}", t);
      }
    } else if (t.tokenType == LayoutTokenType.string) {
      val = t.value.toString();
      ltype = LayoutType.string;
    }
    return LayoutVariable(r"$boundvariable", ltype, val);
  }

  // bool _is
}
