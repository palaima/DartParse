import 'package:http/http.dart' as http;
import 'package:json_object/json_object.dart';
import 'package:logging/logging.dart';

import "dart:async";
import 'dart:core';
import 'dart:io';


import 'package:dart_parse/dart_parse.dart';




main() {

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.loggerName}: ${rec.time}: ${rec.message}');
  });

  final Logger log = new Logger('Main');

  int number = 1<<53;
  int test = 1<<2;
  print(number);
  print("hello");

  //log.info(new File('file.txt').readAsStringSync());

  /*String data = "{\"results\":[{\"name\":\"obdeleven\",\"version\":\"0.3.0\",\"version_code\":3000,\"createdAt\":\"2014-09-16T06:35:25.597Z\",\"updatedAt\":\"2014-10-10T17:04:11.300Z\",\"objectId\":\"bo0T7MXJdJ\"}, {\"name\":\"obdeleven\",\"version\":\"0.3.0\",\"version_code\":3000,\"createdAt\":\"2014-09-16T06:35:25.597Z\",\"updatedAt\":\"2014-10-10T17:04:11.300Z\",\"objectId\":\"bo0T7MXJdJ\"}]}";
  String data3 = "[1,2]";
  print(data);
  Map json = JSON.decode(data);
  json.forEach((key, value){
    print(key);
    print(value is List);
    if(value is List) {
      List list = value;
      list.forEach((data){
        print(data);
        JsonObject object = new JsonObject.fromMap(data);

        print(object.toString());
      });
    }
  });
  print(data);*/
  ParseConstant.APPLICATION_ID = "elrYETs0EvHHvEsRa3Lq6HBWGZmWmrTYB9TfGBQ2";
  ParseConstant.REST_API_KEY = "7NRvJx23sChtJTlLsKUkwkrx8Ob79NnW4uXrzqyE";

  create(log);
  //query(log);

  //test2.delete();
  //we2tuyhEDZ
  //getObject(log, "we2tuyhEDZ");
  //deleteObject(log, "we2tuyhEDZ");

}

getObject(Logger log, String id) {
  ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
  query.get(id).then((ParseObject object) {
    log.info(object.toString());
  }).catchError((error) {
    log.shout(error.toString());
  });
}

deleteObject(Logger log, String id) {
  ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
  query.get(id).then((ParseObject object) {
    log.info(object.toString());
    return object.delete();
  }).then((bool deleted) {
    log.info("deleted $deleted");
  }).catchError((error) {
    log.shout(error.toString());
  });
}

create(Logger log) {
  ParseObject relation = new ParseObject("relationTestClass");
  relation.put("data", 55);
  relation.save().then((ParseObject object) {
    ParseObject test2 = new ParseObject("testNewClass");
    test2.put("date", new DateTime(1989, DateTime.NOVEMBER, 9));
    test2.put("code", 1);
    test2.put("list", [1,2,3]);
    test2.put("list_string", ["1","car","3"]);
    test2.put("list_double", [1.1, 2.2, 3.3]);
    test2.put("list_boolean", [true, true, false]);
    test2.put("relation", object);
    return test2.save();
  }).then((ParseObject object){
    log.info("retrieved " + object.getParseObject("relation").toString());
  }).catchError((e) {
    log.info(e.toString());
    return 42;
  }).then((value) {
    log.info("The value is $value");
  }).whenComplete(() => log.info("Done!"));

}

query(Logger log) {
  ParseObject test1 = new ParseObject("test");
  test1.put("name", "mantas")
    ..put("code", 1);
  test1.save().then((ParseObject parseObject) {
    ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
    query
    //..whereEqualTo("objectId","t2LtuexRoN")
    //..whereEqualTo("code", 2)
      ..addDescendingOrder("code")
      ..find().then((List<ParseObject> results) {
      results.forEach((ParseObject result) {
        log.fine("===============================================");
        log.fine("objectId: " + result.objectId);
        log.fine("createdAt: " + result.getUpdatedAt.toString());
        log.fine("updatedAt: " + result.getUpdatedAt.toString());
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
    });
  });
}