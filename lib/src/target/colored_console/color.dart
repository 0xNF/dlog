import 'package:json_annotation/json_annotation.dart';

enum ConsoleColor {
  @JsonValue("NoChange")
  noChange,

  @JsonValue("Black")
  black,

  @JsonValue("Blue")
  blue,

  @JsonValue("Cyan")
  cyan,

  @JsonValue("DarkBlue")
  darkBlue,

  @JsonValue("DarkCyan")
  darkCyan,

  @JsonValue("DarkGrey")
  darkGrey,

  @JsonValue("DarkGreen")
  darkGreen,

  @JsonValue("DarkMagenta")
  darkMagenta,

  @JsonValue("DarkRed")
  darkRed,

  @JsonValue("DarkYellow")
  darkYellow,

  @JsonValue("Grey")
  grey,

  @JsonValue("Green")
  green,

  @JsonValue("Magenta")
  magenta,

  @JsonValue("Red")
  red,

  @JsonValue("White")
  white,

  @JsonValue("Yellow")
  yellow,
}

class ColorInfo {
  final ConsoleColor color;
  final String hexCode;
  final String ansiForeground;
  final String ansiBackground;
  final int asciCode;

  const ColorInfo(this.color, this.hexCode, this.ansiForeground, this.ansiBackground, this.asciCode);
}

const List<ColorInfo> consoleColors = [
  ColorInfo(ConsoleColor.noChange, "#FFFFFF", "\x1B[39m\x1B[22m", "\x1B[49m", 16),
  ColorInfo(ConsoleColor.black, "#000000", "\x1B[30m ", "\x1B[40m", 0),
  ColorInfo(ConsoleColor.blue, "#0000FF", "\x1B[94m ", "\x1B[104m", 9),
  ColorInfo(ConsoleColor.cyan, "#00FFFF", "\x1B[96m ", "\x1B[106m", 11),
  ColorInfo(ConsoleColor.darkBlue, "#000080", "\x1B[34m ", "\x1B[44m", 1),
  ColorInfo(ConsoleColor.darkCyan, "#008080", "\x1B[36m ", "\x1B[46m", 3),
  ColorInfo(ConsoleColor.darkGrey, "#808080", "\x1B[90m ", "\x1B[100m", 8),
  ColorInfo(ConsoleColor.darkGreen, "#008000", "\x1B[32m ", "\x1B[42m", 2),
  ColorInfo(ConsoleColor.darkMagenta, "#800080", "\x1B[35m ", "\x1B[45m", 5),
  ColorInfo(ConsoleColor.darkRed, "#800000", "\x1B[31m ", "\x1B[41m", 4),
  ColorInfo(ConsoleColor.darkYellow, "#808000", "\x1B[33m ", "\x1B[43m", 6),
  ColorInfo(ConsoleColor.grey, "#C0C0C0", "\x1B[37m ", "\x1B[47m", 7),
  ColorInfo(ConsoleColor.green, "#00FF00", "\x1B[92m ", "\x1B[102m", 10),
  ColorInfo(ConsoleColor.magenta, "#FF00FF", "\x1B[95m ", "\x1B[105m", 13),
  ColorInfo(ConsoleColor.red, "#FF0000", "\x1B[91m ", "\x1B[101m", 12),
  ColorInfo(ConsoleColor.white, "#FFFFFF", "\x1b[97m ", "\x1B[107m", 15),
  ColorInfo(ConsoleColor.yellow, "#FFFF00", "\x1B[93m ", "\x1B[103m", 14),
];

const Map<ConsoleColor, ColorInfo> consoleColorMap = {
  ConsoleColor.noChange: ColorInfo(ConsoleColor.noChange, "#FFFFFF", "\x1B[39m\x1B[22m", "\x1B[49m", 16),
  ConsoleColor.black: ColorInfo(ConsoleColor.black, "#000000", "\x1B[30m ", "\x1B[40m", 0),
  ConsoleColor.blue: ColorInfo(ConsoleColor.blue, "#0000FF", "\x1B[94m ", "\x1B[104m", 9),
  ConsoleColor.cyan: ColorInfo(ConsoleColor.cyan, "#00FFFF", "\x1B[96m ", "\x1B[106m", 11),
  ConsoleColor.darkBlue: ColorInfo(ConsoleColor.darkBlue, "#000080", "\x1B[34m ", "\x1B[44m", 1),
  ConsoleColor.darkCyan: ColorInfo(ConsoleColor.darkCyan, "#008080", "\x1B[36m ", "\x1B[46m", 3),
  ConsoleColor.darkGrey: ColorInfo(ConsoleColor.darkGrey, "#808080", "\x1B[90m ", "\x1B[100m", 8),
  ConsoleColor.darkGreen: ColorInfo(ConsoleColor.darkGreen, "#008000", "\x1B[32m ", "\x1B[42m", 2),
  ConsoleColor.darkMagenta: ColorInfo(ConsoleColor.darkMagenta, "#800080", "\x1B[35m ", "\x1B[45m", 5),
  ConsoleColor.darkRed: ColorInfo(ConsoleColor.darkRed, "#800000", "\x1B[31m ", "\x1B[41m", 4),
  ConsoleColor.darkYellow: ColorInfo(ConsoleColor.darkYellow, "#808000", "\x1B[33m ", "\x1B[43m", 6),
  ConsoleColor.grey: ColorInfo(ConsoleColor.grey, "#C0C0C0", "\x1B[37m ", "\x1B[47m", 7),
  ConsoleColor.green: ColorInfo(ConsoleColor.green, "#00FF00", "\x1B[92m ", "\x1B[102m", 10),
  ConsoleColor.magenta: ColorInfo(ConsoleColor.magenta, "#FF00FF", "\x1B[95m ", "\x1B[105m", 13),
  ConsoleColor.red: ColorInfo(ConsoleColor.red, "#FF0000", "\x1B[91m ", "\x1B[101m", 12),
  ConsoleColor.white: ColorInfo(ConsoleColor.white, "#FFFFFF", "\x1b[97m ", "\x1B[107m", 15),
  ConsoleColor.yellow: ColorInfo(ConsoleColor.yellow, "#FFFF00", "\x1B[93m ", "\x1B[103m", 14),
};
