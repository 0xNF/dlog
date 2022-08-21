import 'package:flog3/src/layout/layout_renderers/all_event_properties_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/directory_separator_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/event_property_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/guid_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/hostname_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/level_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/literal_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/logger_name_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/longdate_layout_renderer.dart';
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

LayoutRenderer _reifyLayoutParsers(LayoutVariable vars) {
  if (vars.layoutType == LayoutType.layout) {
    switch (vars.variableName.toLowerCase()) {
      case NewLineLayoutRenderer.name:
        return NewLineLayoutRenderer.fromToken(vars);
      case DirectorySeparatorLayoutRenderer.name:
        return DirectorySeparatorLayoutRenderer.fromToken(vars);
      case SequenceIdRenderer.name:
        return SequenceIdRenderer.fromToken(vars);
      case LoggerNameLayoutRenderer.name:
        return LoggerNameLayoutRenderer.fromToken(vars);
      case GuidLayoutRenderer.name:
        return GuidLayoutRenderer.fromToken(vars);
      case LevelLayoutRenderer.name:
        return LevelLayoutRenderer.fromToken(vars);
      case TimeLayoutRenderer.name:
        return TimeLayoutRenderer.fromToken(vars);
      case ShortDateLayoutRenderer.name:
        return ShortDateLayoutRenderer.fromToken(vars);
      case LongDateLayoutRenderer.name:
        return LongDateLayoutRenderer.fromToken(vars);
      case HostnameLayoutRenderer.name:
        return HostnameLayoutRenderer.fromToken(vars);
      case AllEventPropertiesLayoutRenderer.name:
        return AllEventPropertiesLayoutRenderer.fromToken(vars);
      case EventPropertyLayoutRenderer.name:
        return EventPropertyLayoutRenderer.fromToken(vars);
      case LiteralLayoutRenderer.name:
      default:
        return LiteralLayoutRenderer.fromToken(vars);
    }
    /* match the renderer types */
  } else {
    /* everything else gets a literal */
    return LiteralLayoutRenderer.fromToken(vars);
  }
  throw Exception("??");
}

class LayoutParser {
  final String source;

  final List<Token> _tokens = [];
  int _position = -1;
  Token? _currentToken;

  LayoutParser({required this.source});

  LayoutRenderer parse() {
    final tokenizer = LayoutTokenizer(reader: StringReader(str: source));
    _tokens.clear();
    _tokens.addAll(tokenizer.tokenize());

    final v = _getNextToken();

    return _reifyLayoutParsers(v);
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

  // List<_LayoutVariable> _parseLayoutList() {}

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

    // TODO generate layout
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
    return const [
      DirectorySeparatorLayoutRenderer.name,
      GuidLayoutRenderer.name,
      LevelLayoutRenderer.name,
      LiteralLayoutRenderer.name,
      LoggerNameLayoutRenderer.name,
      NewLineLayoutRenderer.name,
      SequenceIdRenderer.name,
      TimeLayoutRenderer.name,
      ShortDateLayoutRenderer.name,
      LongDateLayoutRenderer.name,
      HostnameLayoutRenderer.name,
      AllEventPropertiesLayoutRenderer.name,
      EventPropertyLayoutRenderer.name,
    ].map((e) => e.toLowerCase()).contains(val.toLowerCase());
  }

  LayoutVariable _parseValue() {
    final t = _currentToken!;
    Object val = 0;
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
      val = t.value;
      ltype = LayoutType.string;
    }
    return LayoutVariable(r"$boundvariable", ltype, val);
  }

  // bool _is
}
