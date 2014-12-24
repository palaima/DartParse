part of dart_parse;

class ParseEncoder {

  static Object encode(Object value, ParseObjectEncodingStrategy objectEncoder) {
    if (value is ParseObject) {
      return objectEncoder.encodeRelatedObject(value);
    }

    if (value is List) {
      List list = value;
      String data;
      list.forEach((val) {

      });
      //JsonObject
      /*JSONObject output = new JSONObject();
      output.put("__type", "Bytes");
      output.put("base64", Base64.encodeBase64String(bytes));*/
      return data;
    }

    if(Parse.isValidType(value)) {
      return value;
    }
  }
}
