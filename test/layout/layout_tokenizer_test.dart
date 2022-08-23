import 'package:flog3/src/layout/parser/tokenizer/layout_tokens.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group("Complex Tokenizer Tests", () {
    test("tokenize symbol string", () {
      final tokens = getTokens(r"$shouldBeKeyword");
      assert(tokens.length == 1);
      assert(tokens[0].tokenType == LayoutTokenType.keyword);
      assert(tokens[0].value == r"$shouldBeKeyword");
    });

    test("tokenize compound", () {
      final tokens = getTokens(r"k${longdate}");
      assert(tokens.length == 5);
      assert(tokens[0].tokenType == LayoutTokenType.keyword);
      assert(tokens[0].value == r"k");
      assert(tokens[1].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[2].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[3].tokenType == LayoutTokenType.keyword);
      assert(tokens[4].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize full keyword", () {
      final tokens = getTokens(r"${longdate}");
      assert(tokens.length == 4);
      assert(tokens[0].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[1].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[2].tokenType == LayoutTokenType.keyword);
      assert(tokens[3].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize keyword with parameter keyword", () {
      final tokens = getTokens(r"${level:uppercase=true}");
      assert(tokens.length == 8);
      assert(tokens[0].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[1].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[2].tokenType == LayoutTokenType.keyword);
      assert(tokens[3].tokenType == LayoutTokenType.colon);
      assert(tokens[4].tokenType == LayoutTokenType.keyword);
      assert(tokens[5].tokenType == LayoutTokenType.equalTo);
      assert(tokens[6].tokenType == LayoutTokenType.keyword);
      assert(tokens[7].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize keyword with parameter number", () {
      final tokens = getTokens(r"${cached:inner=1}");
      assert(tokens.length == 8);
      assert(tokens[0].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[1].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[2].tokenType == LayoutTokenType.keyword);
      assert(tokens[3].tokenType == LayoutTokenType.colon);
      assert(tokens[4].tokenType == LayoutTokenType.keyword);
      assert(tokens[5].tokenType == LayoutTokenType.equalTo);
      assert(tokens[6].tokenType == LayoutTokenType.number);
      assert(tokens[7].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize keyword with parameter string", () {
      final tokens = getTokens(r"${message:exceptionSeparator='hello'}");
      assert(tokens.length == 8);
      assert(tokens[0].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[1].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[2].tokenType == LayoutTokenType.keyword);
      assert(tokens[3].tokenType == LayoutTokenType.colon);
      assert(tokens[4].tokenType == LayoutTokenType.keyword);
      assert(tokens[5].tokenType == LayoutTokenType.equalTo);
      assert(tokens[6].tokenType == LayoutTokenType.string);
      assert(tokens[7].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize keyword with escaped", () {
      final tokens = getTokens(r"${literal:text='Some Text with ${ in it'}");
      assert(tokens.length == 8);
      assert(tokens[0].tokenType == LayoutTokenType.dollarsign);
      assert(tokens[1].tokenType == LayoutTokenType.openCurleyBrace);
      assert(tokens[2].tokenType == LayoutTokenType.keyword);
      assert(tokens[3].tokenType == LayoutTokenType.colon);
      assert(tokens[4].tokenType == LayoutTokenType.keyword);
      assert(tokens[5].tokenType == LayoutTokenType.equalTo);
      assert(tokens[6].tokenType == LayoutTokenType.string);
      assert(tokens[7].tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test("tokenize keyword with nested", () {
      final tokens = getTokens(r"${cached:cached=true:Inner=${date:format='yyyy-MM-dd hh.mm.ss'}:CacheKey=${shortdate}}");
      assert(tokens.length == 26);
    });
  });

  group("Simple Tokenizer Tests", () {
    setUp(() {});

    test('tokenize integer', () {
      final first = getTokens(r"105").first;
      assert(first.tokenType == LayoutTokenType.number);
      assert(first.value == "105");
      assert(first.location == 2);
    });

    test('tokenize negative', () {
      final tokens = getTokens(r"-62");
      final first = tokens.first;
      final second = tokens[1];
      assert(first.tokenType == LayoutTokenType.minus);
      assert(second.tokenType == LayoutTokenType.number);
      assert(second.value == "62");
    });

    test('tokenize double', () {
      final tokens = getTokens(r"7.331");
      final first = tokens.first;
      assert(first.tokenType == LayoutTokenType.number);
      assert(first.value == "7.331");
    });

    test('tokenize string', () {
      final tokens = getTokens("'hello3'");
      final first = tokens.first;
      assert(first.tokenType == LayoutTokenType.string);
      assert(first.value == "hello3");
    });

    test('tokenize dot', () {
      final tokens = getTokens('...');
      assert(tokens.length == 3);
      assert(tokens.every((element) => element.tokenType == LayoutTokenType.dot));
    });

    test('tokenize comma', () {
      final tokens = getTokens(',,,');
      assert(tokens.length == 3);
      assert(tokens.every((element) => element.tokenType == LayoutTokenType.comma));
    });

    test('tokenize open curly', () {
      final tokens = getTokens('{');
      assert(tokens.first.tokenType == LayoutTokenType.openCurleyBrace);
    });

    test('tokenize closing curly', () {
      final tokens = getTokens('}');
      assert(tokens.first.tokenType == LayoutTokenType.closingCurlyBrace);
    });

    test('tokenize left paren', () {
      final tokens = getTokens('(');
      assert(tokens.first.tokenType == LayoutTokenType.leftParen);
    });

    test('tokenize right paren', () {
      final tokens = getTokens(')');
      assert(tokens.first.tokenType == LayoutTokenType.rightParen);
    });

    test('tokenize colon', () {
      final tokens = getTokens(":");
      assert(tokens.first.tokenType == LayoutTokenType.colon);
    });

    test('tokenize dollarsign', () {
      final tokens = getTokens(r"$");
      expect(tokens.first.tokenType, LayoutTokenType.keyword, reason: "Dollar signs by themselves are just regular tokens, not the marker to a layout");
    });
  });
}
