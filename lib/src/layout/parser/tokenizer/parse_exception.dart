import 'package:flog3/src/layout/parser/layout_token.dart';
import 'package:flog3/src/layout/parser/tokenizer/layout_tokens.dart';

class LayoutTokenizerException implements Exception {
  final String message;
  final LayoutTokenType onToken;
  const LayoutTokenizerException({required this.message, required this.onToken});
}

class LayoutParserException implements Exception {
  final String message;
  final Token? onToken;
  const LayoutParserException(this.message, this.onToken);
}
