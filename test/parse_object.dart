import 'package:dart_parse/dart_parse.dart';
import 'package:unittest/unittest.dart';

main() {
  group('create detele object', () {
    ParseObject object = new ParseObject("test");
    test('create', () {
      object.save().then(expectAsync((ParseObject object) {
        expect(object.objectId, isNotNull);
      }));
    });
    test('delete', () {
      object.delete().then(expectAsync((bool deleted) {
        expect(deleted, isTrue);
      }));
    });

  });
}
