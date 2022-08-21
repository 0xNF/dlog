import 'dart:convert';
import 'dart:io';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/configuration/configuration_spec.dart';
import 'package:flog3/src/layout/parser/layout_token.dart';
import 'package:flog3/src/layout/parser/tokenizer/layout_tokenizer.dart';

ConfigurationSpec loadConfigSpec(String specName) {
  File f = File("./test/data/$specName");
  final s = f.readAsStringSync();
  Map<String, dynamic> c = JsonDecoder().convert(s) as Map<String, dynamic>;
  final cc = ConfigurationSpec.fromJson(c);
  return cc;
}



List<Token> getTokens(String og) {
  final sb = StringReader(str: og);
  final LayoutTokenizer tokenizer = LayoutTokenizer(reader: sb);
  final tokens = tokenizer.tokenize();
  return tokens;
}