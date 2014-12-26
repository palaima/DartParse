part of dart_parse;

class ParseGetCommand extends ParseCommand {

  String endPoint;
  String objectId;


  ParseGetCommand(this.endPoint, [this.objectId]);

  String getRequest() {
    String request = "";

    if (_data.containsKey("data")) {
      JsonObject query = _data["data"];
      if (!query.keys.isEmpty) {
        request += "?";
      }
      Iterator it = query.keys.iterator;
      while (it.moveNext()) {
        String key = it.current;
        request += "${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(query[key].toString())}&";
      }

    }
    return request;
  }

  String getEndPoint() {
    return endPoint + (objectId != null ? "/" + objectId : "");
  }

  bool addJson() {
    return false;
  }


}
