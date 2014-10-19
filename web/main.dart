import 'test.dart';
import 'package:http/http.dart' as http;
import 'package:json_object/json_object.dart';

import "dart:async";
import 'dart:convert';
import 'dart:core';

import 'ParseQuery.dart';
import 'ParseResponse.dart';
import 'ParseObject.dart';

main() {
  int number = 1<<53;
  int test = 1<<2;
  print(number);
  print("hello");

  String data = "{\"results\":[{\"name\":\"obdeleven\",\"version\":\"0.3.0\",\"version_code\":3000,\"createdAt\":\"2014-09-16T06:35:25.597Z\",\"updatedAt\":\"2014-10-10T17:04:11.300Z\",\"objectId\":\"bo0T7MXJdJ\"}, {\"name\":\"obdeleven\",\"version\":\"0.3.0\",\"version_code\":3000,\"createdAt\":\"2014-09-16T06:35:25.597Z\",\"updatedAt\":\"2014-10-10T17:04:11.300Z\",\"objectId\":\"bo0T7MXJdJ\"}]}";
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
  print(data);
  ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("test");
  query
    ..whereEqualTo("","")
    ..whereEqualTo("","");
  query.find().then((List<ParseObject> results) {
    results.forEach((ParseObject result) {
      print("===============================================");
      print("objectId: " + result.objectId);
      print("createdAt: " + result.createdAt.toString());
      print("updatedAt: " + result.updatedAt.toString());
      if (result.has("array")) {
        List array = result.getList("array");
        array.forEach((val) {
          print("value: $val");
        });
      }
      result.data.forEach((k,v) {
        print("$k: $v");
      });
      print("===============================================");
    });
    /*print("json " + result.getJsonObject().toString());
    print("json " + json[0]);*/
  });
}