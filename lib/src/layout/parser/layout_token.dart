import 'package:flog3/src/layout/parser/tokenizer/layout_tokens.dart';

class Token {
  final LayoutTokenType tokenType;
  final int location;
  final String value;

  Token(this.tokenType, this.location, this.value);
}
