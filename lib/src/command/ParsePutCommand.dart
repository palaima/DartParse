part of dart_parse;

class ParsePutCommand extends ParseCommand {

  String endPoint;
  String objectId;


  ParsePutCommand(this.endPoint, [this.objectId]);

  String getRequest() {
    return "";
  }

  String getEndPoint() {
    return endPoint + (objectId != null ? "/" + objectId : "");
  }

  Future<Response> getClient(String url, Map header) {
    header.putIfAbsent(ParseConstant.HEADER_CONTENT_TYPE, () => ParseConstant.CONTENT_TYPE_JSON);
    if (_data.containsKey("data")) {
      JsonObject body = _data["data"];
      return http.put(url, headers : header, body : body.toString());
    }
    return http.put(url, headers : header);
  }

}
