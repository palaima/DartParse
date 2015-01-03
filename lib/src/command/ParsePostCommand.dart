part of dart_parse;

class ParsePostCommand extends ParseCommand {

  String endPoint;
  String objectId;


  ParsePostCommand(this.endPoint, [this.objectId]);

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
      return http.post(url, headers : header, body : body.toString());
    }
    return http.post(url, headers : header);
  }

}
