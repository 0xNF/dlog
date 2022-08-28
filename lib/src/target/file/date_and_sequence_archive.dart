import 'package:intl/intl.dart';

/// A descriptor for an archive created with the [DateAndSequence] numbering mode.
class DateAndSequenceArchive {
  final DateFormat dateFormat;

  /// The full name of the archive file.
  final String fileName;

  /// The parsed date contained in the file name.
  final DateTime date;

  /// The parsed sequence number contained in the file name.
  final int sequence;

  /// Determines whether [date] produces the same string as the current instance's date once formatted with the current instance's date format.
  ///
  /// Date: The date to compare the current object's date to.
  ///
  /// Retruns: `True` if the formatted dates are equal, otherwise `False`.
  bool hasSameFormattedDate(DateTime checkDate) {
    final first = dateFormat.format(checkDate);
    final second = dateFormat.format(date);
    return first == second;
  }

  DateAndSequenceArchive({
    required this.date,
    required String dateFormat,
    required this.sequence,
    required this.fileName,
  }) : dateFormat = DateFormat(dateFormat);
}
