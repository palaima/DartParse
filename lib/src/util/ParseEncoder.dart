part of dart_parse;

class ParseEncoder {
  static Logger _log = new Logger("ParseEncoder");

  static Object encode(Object value, ParseObjectEncodingStrategy objectEncoder) {
    if (value is ParseObject) {
      return objectEncoder.encodeRelatedObject(value);
    }

    if (value is List) {
      List list = value;
      String data = "blabla";
      list.forEach((val) {
        _log.info(val + " gdsg");
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
      _log.info(json);
      return json;
    }

    if(Parse.isValidType(value)) {
      return value;
    }

    return value;
  }
}
