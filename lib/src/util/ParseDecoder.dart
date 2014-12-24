part of dart_parse;

class ParseDecoder {

  static Object decode(Object object) {
    if (object is Map) {
      Map map = object;
      if (!map.containsKey("__type")) {
        return map;
      }

      String typeString = map["__type"];

      if (typeString == "Date") {
        return Parse.parseDate(map["iso"]);
      }

      if (typeString == "Pointer") {
        return _decodePointer(map["className"],map["objectId"]);
      }

      /*if (typeString.equals("File")) {
        return new ParseFile(jsonObject.optString("name"),
        jsonObject.optString("url"));
      }

      if (typeString.equals("GeoPoint")) {
        double latitude, longitude;
        try {
          latitude = jsonObject.getDouble("latitude");
          longitude = jsonObject.getDouble("longitude");
        } catch (JSONException e) {
          throw new RuntimeException(e);
        }
        return new ParseGeoPoint(latitude, longitude);
      }

      if (typeString.equals("Relation")) {
        return new ParseRelation(jsonObject);
      }*/

      if (map.containsKey("__op")) {
        return ParseFieldOperations.decode(map);
      }
     /* String opString = jsonObject.optString("__op", null);
      if (opString != null) {
        try {
          return ParseFieldOperations.decode(jsonObject);
        } catch (JSONException e) {
          throw new RuntimeException(e);
        }
      }*/

      return null;
    }

    if (object is List) {
      List list = object;
      return list;
     /* List<Object> result = new List<Object>();
      list.forEach((value) {
        result.add(value);
      });
      return result;*/
    }

    return object;
  }

  static ParseObject _decodePointer(String className, String objectId) {
    return ParseObject.createWithoutData(className, objectId);
  }

  /*static List<Object> _convertJSONArrayToList(JSONArray array) {
    List<Object> list = new List<Object>();
    for (int i = 0; i < array.length(); i++) {
      list.add(decode(array.opt(i)));
    }
    return list;
  }*/

 /* static Map<String, Object> _convertJSONObjectToMap(JSONObject object) {
    Map<String, Object> outputMap = new HashMap<String, Object>();
    Iterator<?> it = object.keys();
  while (it.hasNext()) {
  String key = (String) it.next();
  Object value = object.opt(key);
  outputMap.put(key, decode(value));
  }
  return outputMap;
}*/
}
