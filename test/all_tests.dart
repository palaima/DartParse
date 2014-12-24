import 'package:unittest/compact_vm_config.dart';
import 'package:unittest/unittest.dart';
import 'package:dart_parse/dart_parse.dart';
import 'package:logging/logging.dart';
import 'query.dart' as query;

main() {
  useCompactVMConfiguration();
  ParseConstant.APPLICATION_ID = "elrYETs0EvHHvEsRa3Lq6HBWGZmWmrTYB9TfGBQ2";
  ParseConstant.REST_API_KEY = "7NRvJx23sChtJTlLsKUkwkrx8Ob79NnW4uXrzqyE";
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
   // print('${rec.level.name}: ${rec.loggerName}: ${rec.time}: ${rec.message}');
  });
  query.main();
}
