part of dart_parse;

class ParseEncoder {
  static Logger _log = new Logger("ParseEncoder");

  static Object encode(Object value, ParseObjectEncodingStrategy objectEncoder) {
    if (value is ParseObject) {
      return objectEncoder.encodeRelatedObject(value);
    }

    if (value is ParseFile) {
      ParseFile file = value;
      JsonObject json = new JsonObject();
      json["__type"] = "File";
      json["name"] = file.name;
      json["url"] = file.url;
      return json;
    }

    if (value is ParseGeoPoint) {
      ParseGeoPoint point = value;
      JsonObject json = new JsonObject();
      json["__type"] = "GeoPoint";
      json["latitude"] = point.latitude;
      json["longitude"] = point.longitude;
      return json;
    }

    if (value is DateTime) {
      DateTime date = value;
      JsonObject json = new JsonObject();
      json["__type"] = "Date";
      json["iso"] = date.toIso8601String();
      return json;
    }

    if (value is List) {
      List list = value;
      List data = new List();
      list.forEach((val) {
        data.add(encode(val, objectEncoder));
      });
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
