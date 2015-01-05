part of dart_parse;

class ParseEncoder {
  static Logger _log = new Logger("ParseEncoder");

  static Object encode(Object value, ParseObjectEncodingStrategy objectEncoder) {
    if (value is ParseObject) {
      return objectEncoder.encodeRelatedObject(value);
    }

    if (value is DateTime) {
      JsonObject json = new JsonObject();
      json["__type"] = "Date";
      json["iso"] = value.toIso8601String();
      return json;
    }

    if (value is List) {
      List list = value;
      List data = new List();
      list.forEach((val) {
        data.add(encode(val, objectEncoder));
      });
      //JsonObject
      /*JSONObject output = new JSONObject();
      output.put("__type", "Bytes");
      output.put("base64", Base64.encodeBase64String(bytes));*/
      return data;
    }

    //where clause
    if (value is Map) {
      Map<String, dynamic> map = value;
      JsonObject json = new JsonObject();
      map.keys.forEach((key) {
        json.putIfAbsent(key, () => encode(map[key], objectEncoder));
      });
      return json;
    }

    /*if (value is ParseObject) {
      ParseObject object = value;
      JsonObject json = new JsonObject();
      json["__type"] = "Pointer";
      json["className"] = object.className;
      json["objectId"] = object.objectId;
      return json;
    }*/

    if(Parse.isValidType(value)) {
      return value;
    }

    return value;
  }
}
