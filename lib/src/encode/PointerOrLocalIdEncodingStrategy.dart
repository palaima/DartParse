part of dart_parse;

class PointerOrLocalIdEncodingStrategy extends ParseObjectEncodingStrategy {

  final Logger log = new Logger("PointerOrLocalIdEncodingStrategy");

  JsonObject encodeRelatedObject(ParseObject parseObject) {
    JsonObject json = new JsonObject();
    try {
      if (parseObject.objectId != null) {
        json.putIfAbsent("__type", () => "Pointer");
        json.putIfAbsent("className", () => parseObject.className);
        json.putIfAbsent("objectId", () => parseObject.objectId);
      } else {
        json.putIfAbsent("__type", () => "Pointer");
        json.putIfAbsent("className", () => parseObject.className);
        json.putIfAbsent("localId", () => createTempId());
      }
    } on JsonObjectException catch (e) {
      log.shout(e);
    }
    return json;
  }

  String createTempId() {
    Random random = new Random();
    int maxInt = 1<<53;
    int localIdNumber = random.nextInt(maxInt);
    String localId = "local_" + localIdNumber.toRadixString(16);

    if (!isLocalId(localId)) {
      throw new ArgumentError(
          "Generated an invalid local id: \""
          + localId
          + "\". "
          + "This should never happen. Contact us at https://parse.com/help");
    }

    return localId;
  }

  bool isLocalId(String localId) {
    if (!localId.startsWith("local_")) {
      return false;
    }
    for (int i = 6; i < localId.length; i++) {
      int c = localId.codeUnitAt(i);
      if (((c < '0'.codeUnitAt(0)) || (c > '9'.codeUnitAt(0))) && ((c < 'a'.codeUnitAt(0)) || (c > 'f'.codeUnitAt(0)))) {
        return false;
      }
    }
    return true;
  }

}
