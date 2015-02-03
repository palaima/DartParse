import 'package:dart_parse/dart_parse.dart';
import 'package:unittest/unittest.dart';
import 'dart:async';

main() {
  group('object create update detele and primityve fields', () {
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

  group('object relations', () {
    test('single pointer', () {
      ParseObject child = new ParseObject("child");
      child.put("string", "text");
      child.save().then(expectAsync((ParseObject child) {
        expect(child.objectId, isNotNull);
        expect(child.getString("string"), "text");
        ParseObject parent = new ParseObject("test");
        parent.put("int", 55);
        parent.put("single_relation", child);
        return parent.save();
      })).then(expectAsync((ParseObject parent){
        expect(parent.objectId, isNotNull);
        expect(parent.getInt("int"), 55);
        expect(parent.getParseObject("single_relation").getString("string"), "text");
        return parent.getParseObject("single_relation").delete().then(expectAsync((bool deleted) {
          expect(deleted, isTrue);
          return parent.delete();
        }));
      })).then(expectAsync((bool deleted) {
        expect(deleted, isTrue);
      }));
    });
  });

  test('multiple pointer', () {
    ParseObject child1 = new ParseObject("child");
    child1.put("string", "text1");
    ParseObject child2 = new ParseObject("child");
    child2.put("string", "text2");
    ParseObject child3 = new ParseObject("child");
    child3.put("string", "text3");
    List list = [child1, child2, child3];
    ParseObject.saveAll(list).then((_) {
      ParseObject parent = new ParseObject("test");
      parent.put("int", 55);
      parent.put("multiple_relation", list);
      return parent.save();
    }).then(expectAsync((ParseObject parent) {
      expect(parent.getList("multiple_relation"), list);
      expect(parent.getInt("int"), 55);
      return ParseObject.deleteAll([child1, child2, child3, parent]);
    })).then(expectAsync((List<bool> deleted) {
      expect(deleted, [true, true, true, true]);
    }));


  });


}
