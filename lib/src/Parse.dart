part of dart_parse;

class Parse {

  static DateTime parseDate(String dateString) {
      return DateTime.parse(dateString).toUtc();
  }

  static bool isInvalidKey(String key) {
    return "objectId" == key || "createdAt" == key
    || "updatedAt" == key;
  }

  static bool isValidType(Object value) {
    return ((value is JsonObject))
    || ((value is List))
    || ((value is String))
    || ((value is num))
    || ((value is bool))
    || ((value is ParseObject))
    //TODO
    /* || ((value instanceof ParseACL))
    || ((value instanceof ParseFile))
    || ((value instanceof ParseRelation))
    || ((value instanceof ParseGeoPoint))*/
    || ((value is DateTime))
    || ((value is Map));
  }
}
