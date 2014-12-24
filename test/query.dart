import 'package:dart_parse/dart_parse.dart';
import 'package:unittest/unittest.dart';

main() {

  test('Query test', () {
    ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
    query.find().then(expectAsync((List<ParseObject> results){
      expect(results, hasLength(2));
    }));
  });

  test('Addition test', () {
    expect(2 + 2, equals(4));
  });


  /*final Logger log = new Logger('Query test');
  ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
  query.find().then((List<ParseObject> results) {
    results.forEach((ParseObject result) {
      log.fine("===============================================");
      log.fine("objectId: " + result.objectId);
      log.fine("createdAt: " + result.createdAt.toString());
      log.fine("updatedAt: " + result.updatedAt.toString());
      if (result.has("array")) {
        List array = result.getList("array");
        array.forEach((String val) {
          log.fine("value: $val");
        });
      }
      result.data.forEach((k,v) {
        log.fine("$k: $v");
      });
      log.fine("===============================================");
    });
  });*/

}
