import 'package:flog3/src/layout/parser/layout_token.dart';
import 'package:flog3/src/layout/parser/tokenizer/layout_tokens.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';

class LayoutTokenizer {
  static const int _maxAsciiCharacter = 128;

  static final List<LayoutTokenType> charIndexToTokenType = _buildCharIndexToTokenType();

  final List<Token> tokens = [];

  final StringReader _stringReader;

  /// Gets the type of the token.
  LayoutTokenType get tokenType => _tokenType;
  LayoutTokenType _tokenType = LayoutTokenType.beginningOfInput;

  /// Gets the token value.
  String get tokenValue => _tokenValue;
  String _tokenValue = "";

  /// Gets the value of a string token.
  String get stringTokenValue {
    String s = _tokenValue;
    /* double quotes -> single quotes */
    return s.substring(1, s.length - 1).replaceAll('"', "'");
  }

  LayoutTokenizer({required StringReader reader}) : _stringReader = reader {
    _getNextToken();
  }

  List<Token> tokenize() {
    tokens.clear();
    _stringReader.reset();
    _tokenValue = "";
    _tokenType = LayoutTokenType.beginningOfInput;
    while (!_isEOF()) {
      _getNextToken();
    }
    return tokens;
  }

  /// Asserts current token type and advances to the next token.
  void _expect(LayoutTokenType tokenType) {
    if (_tokenType != tokenType) {
      throw LayoutTokenizerException(message: "Expected token of type: $tokenType, got $_tokenType ($_tokenValue).", onToken: tokenType);
    }
    _getNextToken();
  }

  /// Asserts that current token is a keyword and returns its value and advances to the next token.
  String _eatKeyword() {
    if (_tokenType != LayoutTokenType.keyword) {
      throw LayoutTokenizerException(message: "Expected identifier", onToken: tokenType);
    }
    String s = _tokenValue;
    _getNextToken();
    return s;
  }

  /// Gets or sets a value indicating whether current keyword is equal to the specified value.
  bool _isKeyword(String keyword) {
    if (_tokenType != LayoutTokenType.keyword) {
      return false;
    }
    return _tokenValue == keyword;
  }

  /// Gets or sets a value indicating whether the tokenizer has reached the end of the token stream.
  bool _isEOF() {
    return _tokenType == LayoutTokenType.endOfInput;
  }

  /// Gets or sets a value indicating whether current token is a number.
  bool _isNumber() {
    return _tokenType == LayoutTokenType.number;
  }

  /// Gets or sets a value indicating whether the specified token is of specified type.
  bool _isToken(LayoutTokenType tokenType) {
    return _tokenType == tokenType;
  }

  bool _isDoubleEscape(String ch) {
    if (ch == r"$") {
      final i = _peek2Char();
      if (!i.isNegative && String.fromCharCode(_peek2Char()) == "{") {
        return true;
      }
    }
    return false;
  }

  /// Gets the next token and sets [TokenType] and [TokenValue] properties.
  void _getNextToken() {
    if (_tokenType == LayoutTokenType.endOfInput) {
      throw LayoutTokenizerException(message: "Cannot read past end of stream.", onToken: _tokenType);
    }
    _skipWhitespace();

    int i = _peekChar();
    if (i == -1) {
      _tokenType = LayoutTokenType.endOfInput;
      return;
    }

    String ch = String.fromCharCode(i);

    if (_isDigit(ch)) {
      _parseNumber(ch);
      return;
    }

    if (ch == r"'") {
      _parseSingleQuotedString(ch);
      return;
    }

    if (!_isDoubleEscape(ch) && (_isSymbol(ch) || _isLetter(ch))) {
      _parseKeyword(ch);
      return;
    }

    _tokenValue = ch;

    bool success;
    // success  = _tryGetComparisonToken(ch);
    // if (success) {
    //   return;
    // }

    success = _tryGetLogicalToken(ch);
    if (success) {
      return;
    }

    final chCp = ch.codeUnitAt(0);
    if (chCp >= 32 && chCp < _maxAsciiCharacter) {
      final tt = charIndexToTokenType[chCp];
      if (tt != LayoutTokenType.invalid) {
        _tokenType = tt;
        _tokenValue = ch; // fyi(nf): new string(ch, 1);
        tokens.add(Token(_tokenType, _stringReader._pointer, _tokenValue));
        _readChar();
        return;
      } else {
        throw LayoutTokenizerException(message: "Invalid punctuation $ch", onToken: tokenType);
      }
    }
    throw LayoutTokenizerException(message: "Invalid token $ch", onToken: tokenType);
  }

  // /// Try the comparison tokens (greater, smaller, greater-equals, smaller-equals)
  // bool _tryGetComparisonToken(String ch) {
  //   if (ch == "<") {
  //     _readChar();
  //     int nextChar = _peekChar();
  //     if (String.fromCharCode(nextChar) == ">") {
  //       _tokenType = LayoutTokenType.notEqual;
  //       _tokenValue = "<>";
  //       _readChar();
  //       return true;
  //     } else if (String.fromCharCode(nextChar) == "=") {
  //       _tokenType = LayoutTokenType.lessThanOrEqualTo;
  //       _tokenValue = "<=";
  //       _readChar();
  //       return true;
  //     } else {
  //       _tokenType = LayoutTokenType.lessThan;
  //       _tokenValue = "<";
  //       return true;
  //     }
  //   }
  //   if (ch == ">") {
  //     _readChar();
  //     int nextChar = _peekChar();
  //     if (String.fromCharCode(nextChar) == "=") {
  //       _tokenType = LayoutTokenType.greaterThanOrEqualTo;
  //       _tokenValue = ">=";
  //       _readChar();
  //       return true;
  //     } else {
  //       _tokenType = LayoutTokenType.greaterThan;
  //       _tokenValue = ">";
  //       return true;
  //     }
  //   }

  //   return false;
  // }

  /// Try the logical tokens (and, or, not, equals)
  bool _tryGetLogicalToken(String ch) {
    // if (ch == "!") {
    //   _readChar();
    //   int nextChar = _peekChar();
    //   if (String.fromCharCode(nextChar) == "=") {
    //     _tokenType = LayoutTokenType.notEqual;
    //     _tokenValue = "!=";
    //     _readChar();
    //     return true;
    //   } else {
    //     _tokenType = LayoutTokenType.not;
    //     _tokenValue = "!";
    //     return true;
    //   }
    // }
    // if (ch == "&") {
    //   _readChar();
    //   int nextChar = _peekChar();
    //   if (String.fromCharCode(nextChar) == "&") {
    //     _tokenType = LayoutTokenType.and;
    //     _tokenValue = "&&";
    //     _readChar();
    //     return true;
    //   } else {
    //     throw const LayoutParserException(message: "Expected '&&' but got '&'");
    //   }
    // }

    // if (ch == "|") {
    //   _readChar();
    //   int nextChar = _peekChar();
    //   if (String.fromCharCode(nextChar) == "|") {
    //     _tokenType = LayoutTokenType.or;
    //     _tokenValue = "||";
    //     _readChar();
    //     return true;
    //   } else {
    //     throw const LayoutParserException(message: "Expected '||' but got '|'");
    //   }
    // }

    if (ch == "=") {
      _readChar();
      int nextChar = _peekChar();
      if (String.fromCharCode(nextChar) == "=") {
        _tokenType = LayoutTokenType.equalTo;
        _tokenValue = "==";
        tokens.add(Token(_tokenType, _stringReader._pointer, _tokenValue));
        _readChar();
        return true;
      } else {
        _tokenType = LayoutTokenType.equalTo;
        _tokenValue = "=";
        tokens.add(Token(_tokenType, _stringReader._pointer, _tokenValue));

        return true;
      }
    }

    return false;
  }

  void _parseSingleQuotedString(String ch) {
    int i = 0;
    _tokenType = LayoutTokenType.string;
    final sb = StringBuffer();
    sb.write(ch);
    _readChar();

    while ((i = _peekChar()) != -1) {
      ch = String.fromCharCode(i);
      sb.write(ch);
      if (ch == "'") {
        final next = _peekChar();
        if (next.isNegative) {
          break;
        } else {
          if (String.fromCharCode(_peekChar()) == "'") {
            _readChar();
            break;
          } else {
            break;
          }
        }
      } else {
        _readChar();
      }

      if (i == -1) {
        throw LayoutTokenizerException(message: "String literal is missing a closing quote character.", onToken: tokenType);
      }
    }
    _tokenValue = sb.toString();
    tokens.add(Token(_tokenType, _stringReader._pointer, stringTokenValue));
  }

  void _parseKeyword(String ch) {
    int i = 0;
    _tokenType = LayoutTokenType.keyword;
    final sb = StringBuffer();
    sb.write(ch);
    _readChar();

    while ((i = _peekChar()) != -1) {
      String s = String.fromCharCode(i);
      if (s == r"$") {
        int peek2 = _peek2Char();
        if (peek2 != -1 && String.fromCharCode(peek2) == "{") {
          break;
        }
      }
      if (s == "_" || s == "-" || _isAlphaNumeric(s) || _isSymbol(s)) {
        final s2 = String.fromCharCode(_readChar());
        sb.write(s2);
      } else {
        break;
      }
    }
    _tokenValue = sb.toString();
    tokens.add(Token(_tokenType, _stringReader._pointer, _tokenValue));
  }

  void _parseNumber(String ch) {
    int i = 0;
    _tokenType = LayoutTokenType.number;
    final sb = StringBuffer();
    sb.write(ch);
    _readChar();

    while ((i = _peekChar()) != -1) {
      String s = String.fromCharCode(i);
      if (_digits.contains(s)) {
        String s2 = String.fromCharCode(_readChar());
        sb.write(s2);
      } else if (s == ".") {
        _readChar();
        sb.write('.');
        final i = _peekChar();
        if (i.isNegative || !_digits.contains(String.fromCharCode(i))) {
          throw LayoutTokenizerException(message: "Float literal missing fractional component", onToken: _tokenType);
        }
      } else {
        break;
      }
    }
    _tokenValue = sb.toString();
    tokens.add(Token(_tokenType, _stringReader._pointer, _tokenValue));
  }

  void _skipWhitespace() {
    int ch = 0;
    while ((ch = _peekChar()) != -1) {
      if (String.fromCharCode(ch).isNotEmpty) {
        break;
      }
      _readChar();
    }
  }

  int _peekChar() {
    return _stringReader.peek();
  }

  int _peek2Char() {
    return _stringReader.peek2();
  }

  int _readChar() {
    return _stringReader.read();
  }

  static const List<String> _digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  static const List<String> _charactersLower = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
  static const List<String> _charactersUpper = ["A", "B", "C", "D", "E", "F", "G", "h", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

  static bool _isDigit(String ch) {
    return _digits.contains(ch);
  }

  static bool _isLowerCase(String ch) {
    return _charactersLower.contains(ch);
  }

  static bool _isUpperCase(String ch) {
    return _charactersUpper.contains(ch);
  }

  static bool _isLetter(String ch) {
    return _charactersLower.contains(ch) || _charactersUpper.contains(ch);
  }

  static bool _isAlphaNumeric(String ch) {
    return _isLetter(ch) || _isDigit(ch);
  }

  static bool _isSymbol(String ch) {
    return _symbols.contains(ch);
  }

  static const _symbols = <String>[
    "_",
    "!",
    "@",
    "#",
    "%",
    "^",
    "&",
    "*",
    "~",
    "|",
    "[",
    "]",
    "<",
    ">",
    "/",
    r"\",
    "+",
    r"$",
    // "=",
    // "{",
    // "}",
  ];

  static List<LayoutTokenType> _buildCharIndexToTokenType() {
    const charTokenTypes = <_CharTokenType>[
      _CharTokenType(character: '(', tokenType: LayoutTokenType.leftParen),
      _CharTokenType(character: ')', tokenType: LayoutTokenType.rightParen),
      _CharTokenType(character: '.', tokenType: LayoutTokenType.dot),
      _CharTokenType(character: ',', tokenType: LayoutTokenType.comma),
      _CharTokenType(character: ':', tokenType: LayoutTokenType.colon),
      _CharTokenType(character: '{', tokenType: LayoutTokenType.openCurleyBrace),
      _CharTokenType(character: '}', tokenType: LayoutTokenType.closingCurlyBrace),
      _CharTokenType(character: r'$', tokenType: LayoutTokenType.dollarsign),
      // _CharTokenType(character: '!', tokenType: LayoutTokenType.not),
      _CharTokenType(character: '-', tokenType: LayoutTokenType.minus),
    ];

    final result = List.filled(_maxAsciiCharacter, LayoutTokenType.invalid);
    for (final cht in charTokenTypes) {
      final cnum = cht.character.codeUnits[0];
      result[cnum] = cht.tokenType;
    }
    return result;
  }
}

class _CharTokenType {
  final String character;
  final LayoutTokenType tokenType;

  const _CharTokenType({required this.character, required this.tokenType});
}

class StringReader {
  final String str;
  int _pointer = -1;

  StringReader({required this.str});

  int peek() {
    int np = _pointer + 1;
    if (np >= str.length) {
      return -1;
    }
    return str.codeUnitAt(np);
  }

  int peek2() {
    int np = _pointer + 2;
    if (np >= str.length) {
      return -1;
    }
    return str.codeUnitAt(np);
  }

  int read() {
    _pointer += 1;
    if (_pointer >= str.length) {
      return -1;
    }
    return str.codeUnitAt(_pointer);
  }

  reset() {
    _pointer = -1;
  }
}
