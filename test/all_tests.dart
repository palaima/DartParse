import 'package:unittest/compact_vm_config.dart';
import 'package:unittest/unittest.dart';
import 'query.dart' as query;
//import 'package:test_dart/ParseConstant.dart';

main() {
  useCompactVMConfiguration();
  /*setUp(() {
    ParseConstant
  });*/
  query.main();
}
