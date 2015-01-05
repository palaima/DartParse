import 'package:dart_parse/dart_parse.dart';
import 'package:unittest/unittest.dart';

main() {
  group('create update detele object and primityve fields', () {
    ParseObject object = new ParseObject("test");
    test('int isNotNull', () {
      object.put("int",55);
      expect(object.getInt("int"), 55);
    });
    test('double isNotNull', () {
      object.put("double",55.5);
      expect(object.getDouble("double"), 55.5);
    });
    test('string isNotNull', () {
      object.put("string","text");
      expect(object.getString("string"), "text");
    });
    test('bool isNotNull', () {
      object.put("bool",true);
      expect(object.getBoolean("bool"), isTrue);
    });
    test('num isNotNull', () {
      object.put("num", 11.1);
      expect(object.getNumber("num"), 11.1);
    });
    test('dateTime isNotNull', () {
      object.put("dateTime", new DateTime(1989, DateTime.NOVEMBER, 9));
      expect(object.getDate("dateTime"), new DateTime(1989, DateTime.NOVEMBER, 9));
    });
    test('list of ints isNotNull', () {
      object.put("list_int", [1,2,3]);
      expect(object.getList("list_int"), [1, 2, 3]);
    });
    test('list of double isNotNull', () {
      object.put("list_double", [1.1,2.2,3.3]);
      expect(object.getList("list_double"), [1.1,2.2,3.3]);
    });
    test('list of bool isNotNull', () {
      object.put("list_bool", [true,false,true]);
      expect(object.getList("list_bool"), [true,false,true]);
    });
    test('list of string isNotNull', () {
      object.put("list_string", ["sfs","fSDF","dfg22"]);
      expect(object.getList("list_string"), ["sfs","fSDF","dfg22"]);
    });

    test('objectId isNull', () {
      expect(object.objectId, isNull);
    });
    test('createdAt isNull', () {
      expect(object.createdAt, isNull);
    });
    test('updatedAt isNull', () {
      expect(object.updatedAt, isNull);
    });
    test('create', () {
      object.save().then(expectAsync((ParseObject object) {
        expect(object.objectId, isNotNull);
      }));
    });
    test('objectId isNotNull', () {
      expect(object.objectId, isNotNull);
    });
    test('createdAt isNotNull', () {
      expect(object.createdAt, isNotNull);
    });
    test('updatedAt isNotNull', () {
      expect(object.updatedAt, isNotNull);
    });

    test('before save new_int isNotNull', () {
      object.put("new_int",60);
      expect(object.getInt("new_int"), 60);
    });
    test('before save bool isNotNull', () {
      object.put("bool",false);
      expect(object.getBoolean("bool"), isFalse);
    });
    test('update', () {
      object.save().then(expectAsync((ParseObject object) {
        expect(object.objectId, isNotNull);
      }));
    });

    test('after save new_int isNotNull', () {
      expect(object.getInt("new_int"), 60);
    });
    test('after save bool isNotNull', () {
      expect(object.getBoolean("bool"), false);
    });

    test('delete', () {
      object.delete().then(expectAsync((bool deleted) {
        expect(deleted, isTrue);
      }));
    });
    test('objectId isNull', () {
      expect(object.objectId, isNull);
    });
    test('createdAt isNull', () {
      expect(object.createdAt, isNull);
    });
    test('updatedAt isNull', () {
      expect(object.updatedAt, isNull);
    });
  });


}
