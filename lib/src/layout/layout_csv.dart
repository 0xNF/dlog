// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:ffi';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/layout/layout_renderers/directory_separator_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/literal_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/new_line_layout_renderer.dart';
import 'package:flog3/src/layout/layout_simple.dart';
import 'package:flog3/src/layout/layout_with_header_and_footer.dart';
import 'package:flog3/src/layout/options/csv_layout_options.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/string_builder.dart';

class CSVLayout extends LayoutWithHeaderAndFooter {
  late String _doubleQuoteChar;
  final bool withHeader;
  late String _actualColumnDelimeter;
  final String customDelimeter;
  final QuoteEnum quoteMode;
  final DelimeterEnum delimeter;
  final String quoteChar;
  final List<String> _quotableCharacters = [];
  final List<CSVColumn> columns;

  /// Original string used to create this layout
  final String source;

  /// Map  of column renderers that a LogEventInfo must pass through to produce a final output
  final Map<String, Layout> columnRenderers;

  CSVLayout({
    this.customDelimeter = "",
    required this.withHeader,
    required this.delimeter,
    required this.source,
    required super.configuration,
    required super.layout,
    required this.columnRenderers,
    required this.quoteChar,
    required this.quoteMode,
    required this.columns,
  }) {
    header = _CSVHeaderLayout(parent: this, configuration: configuration);
    footer = null;
    layout = this;
  }

  @override
  void initialize(LogConfiguration configuration) {
    for (final layout in columnRenderers.values) {
      if (!withHeader) {
        header = null;
      }

      layout.initialize(configuration);

      switch (delimeter) {
        case DelimeterEnum.custom:
          _actualColumnDelimeter = customDelimeter;
          break;
        case DelimeterEnum.pipe:
          _actualColumnDelimeter = "|";
          break;
        case DelimeterEnum.semicolon:
          _actualColumnDelimeter = ";";
          break;
        case DelimeterEnum.space:
          _actualColumnDelimeter = " ";
          break;
        case DelimeterEnum.tab:
          _actualColumnDelimeter = "\t";
          break;
        case DelimeterEnum.auto:
        // TODO(nf): get current culture text separtaor via `intl`
        case DelimeterEnum.comma:
        default:
          _actualColumnDelimeter = ',';
          break;
      }

      _quotableCharacters.clear();
      _quotableCharacters.addAll(("${quoteChar}\r\n${_actualColumnDelimeter}").split(''));

      _doubleQuoteChar = quoteChar + quoteChar;
    }
    super.initialize(configuration);
  }

  @override
  String? getFormattedMessage(LogEventInfo logEvent) {
    StringBuffer sb = StringBuffer();
    renderFormattedMessage(logEvent, sb);
    return sb.toString();
  }

  @override
  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    for (int i = 0; i < columns.length; i++) {
      final colLayout = columns[i].layout;
      final cl = SimpleLayout.parseLayout(colLayout, configuration);
      _renderColumnLayout(logEvent, cl, columns[i].quoting ?? quoteMode, target, i);
    }
  }

  void _renderColumnLayout(LogEventInfo logEvent, Layout columnLayout, QuoteEnum csvQuotingMode, StringBuffer target, int colIdx) {
    if (colIdx != 0) {
      target.write(_actualColumnDelimeter);
    }
    if (csvQuotingMode == QuoteEnum.all) {
      target.write(quoteChar);
    }
    final orgLength = target.length;
    columnLayout.renderWithBuilder(logEvent, target);
    if ((orgLength != target.length) && _columnValueRequiresQuotes(quoteMode, target, orgLength)) {
      final columnValue = target.substring(orgLength, target.length);
      target.truncate(orgLength);
      if (quoteMode != QuoteEnum.all) {
        target.write(quoteChar);
      }
      target.write(columnValue.replaceAll(quoteChar, _doubleQuoteChar));
      target.write(quoteChar);
    } else {
      if (quoteMode == QuoteEnum.all) {
        target.write(quoteChar);
      }
    }
  }

  void _renderHeader(StringBuffer sb) {
    final logEvent = LogEventInfo.nullEvent;
    for (int i = 0; i < columns.length; i++) {
      final col = columns[i];
      final colLayout = SimpleLayout(configuration: configuration, fixedText: col.name, renderers: [], source: col.name);
      colLayout.initialize(configuration);
      _renderColumnLayout(logEvent, colLayout, col.quoting ?? quoteMode, sb, i);
    }
  }

  bool _columnValueRequiresQuotes(QuoteEnum quoting, StringBuffer sb, int startPosition) {
    switch (quoting) {
      case QuoteEnum.none:
        return false;
      case QuoteEnum.all:
        if (quoteChar.length == 1) {
          return sb.indexOf(quoteChar[0], startPosition) >= 0;
        } else {
          return sb.indexOfAny(_quotableCharacters, startPosition) >= 0;
        }
      case QuoteEnum.auto:
      default:
        return sb.indexOfAny(_quotableCharacters, startPosition) >= 0;
    }
  }

  factory CSVLayout.parseLayout(CSVLayoutOptions options, LogConfiguration configuration) {
    final cr = <String, Layout>{};
    for (final col in options.columns) {
      final lt = Layout.fromText(col.layout, configuration: configuration);
      cr[col.name] = lt;
    }

    // /* Replace runtime, single-evaluation, LogEvent agnostic items with a literal */
    // for (final kvp in cr.entries) {
    //   final columnRenderers = kvp.value;
    //   for (int i = 0; i < columnRenderers.length; i++) {
    //     final lr = columnRenderers[i];
    //     final lit = _transformToLiteral(lr);
    //     if (lit != null) {
    //       columnRenderers[i] = lit;
    //     }
    //   }
    //   String? fixed = _getFixedTextIfPossible(columnRenderers);
    //   if (fixed != null) {
    //     columnRenderers.clear();
    //   }
    // }
    return CSVLayout(
      source: '',
      quoteMode: options.quoting,
      configuration: configuration,
      columnRenderers: cr,
      columns: options.columns,
      delimeter: options.delimeter,
      quoteChar: '"', // TODO(nf): place this on teh Options
      withHeader: options.withHeader,
      customDelimeter: options.customColumnDelimiter,
      layout: SimpleLayout(fixedText: '', configuration: configuration, renderers: [], source: ''),
    );
  }

  // static LiteralLayoutRenderer? _transformToLiteral(LayoutRenderer lr) {
  //   if (lr is LiteralLayoutRenderer) {
  //     return lr;
  //   } else if (lr is NewLineLayoutRenderer || lr is DirectorySeparatorLayoutRenderer) {
  //     return LiteralLayoutRenderer(text: lr.render(LogEventInfo.nullEvent));
  //   }
  //   return null;
  // }

  // static String? _getFixedTextIfPossible(List<LayoutRenderer> lst) {
  //   final l2 = lst.toList();
  //   if (l2.isEmpty) {
  //     return "";
  //   } else {
  //     bool allGood = true;
  //     for (int i = 0; i < l2.length; i++) {
  //       final lr = l2[i];
  //       final lit = _transformToLiteral(lr);
  //       if (lit == null) {
  //         allGood = false;
  //         break;
  //       } else {
  //         l2[i] = lit;
  //       }
  //     }
  //     if (allGood) {
  //       return l2.map((e) => e.render(LogEventInfo.nullEvent)).join('');
  //     }
  //   }
  //   return null;
  // }
}

class _CSVHeaderLayout extends Layout {
  final CSVLayout _parent;
  String? _headerOutput;

  _CSVHeaderLayout({
    required CSVLayout parent,
    required super.configuration,
  }) : _parent = parent;

  @override
  void initialize(LogConfiguration configuration) {
    _headerOutput = null;
    super.initialize(configuration);
  }

  String _getHeaderOutput() {
    _headerOutput ??= _buildHeaderOutput();
    return _headerOutput!;
  }

  String _buildHeaderOutput() {
    final sb = StringBuffer();
    _parent._renderHeader(sb);
    return sb.toString();
  }

  @override
  String getFormattedMessage(LogEventInfo info) {
    return _getHeaderOutput();
  }

  @override
  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    target.write(_getHeaderOutput());
  }
}
