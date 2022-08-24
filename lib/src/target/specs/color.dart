import 'package:json_annotation/json_annotation.dart';

enum ColorEnum {
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
  final ColorEnum color;
  final String hexCode;
  final String ansiForeground;
  final String ansiBackground;

  const ColorInfo(this.color, this.hexCode, this.ansiForeground, this.ansiBackground);
}

const List<ColorInfo> colors = [
  ColorInfo(ColorEnum.black, "#000000", "\x1B[30m ", "\x1B[40m"),
  ColorInfo(ColorEnum.blue, "#0000FF", "\x1B[94m ", "\x1B[104m"),
  ColorInfo(ColorEnum.cyan, "#00FFFF", "\x1B[96m ", "\x1B[106m"),
  ColorInfo(ColorEnum.darkBlue, "#000080", "\x1B[34m ", "\x1B[44m"),
  ColorInfo(ColorEnum.darkCyan, "#008080", "\x1B[36m ", "\x1B[46m"),
  ColorInfo(ColorEnum.darkGrey, "#808080", "\x1B[90m ", "\x1B[100m"),
  ColorInfo(ColorEnum.darkGreen, "#008000", "\x1B[32m ", "\x1B[42m"),
  ColorInfo(ColorEnum.darkMagenta, "#800080", "\x1B[35m ", "\x1B[45m"),
  ColorInfo(ColorEnum.darkRed, "#800000", "\x1B[31m ", "\x1B[41m"),
  ColorInfo(ColorEnum.darkYellow, "#808000", "\x1B[33m ", "\x1B[43m"),
  ColorInfo(ColorEnum.grey, "#C0C0C0", "\x1B[37m ", "\x1B[47m"),
  ColorInfo(ColorEnum.green, "#00FF00", "\x1B[92m ", "\x1B[102m"),
  ColorInfo(ColorEnum.magenta, "#FF00FF", "\x1B[95m ", "\x1B[105m"),
  ColorInfo(ColorEnum.red, "#FF0000", "\x1B[91m ", "\x1B[101m"),
  ColorInfo(ColorEnum.white, "#FFFFFF", "\x1b[97m ", "\x1B[107m"),
  ColorInfo(ColorEnum.yellow, "#FFFF00", "\x1B[93m ", "\x1B[103m"),
];
