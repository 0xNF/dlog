import 'package:flog3/src/target/file/base_file_appener.dart';
import 'package:flog3/src/target/file/icreate_file_parameters.dart';

/// Interface implemented by all factories capable of creating file appenders.
abstract class IFileAppenderFactory {
  /// Opens the appender for given file name and parameters.
  BaseFileAppender open(String fileName, ICreateFileParameters parameters);
}
