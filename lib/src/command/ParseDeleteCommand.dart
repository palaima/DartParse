part of dart_parse;

class ParseDeleteCommand extends ParseCommand {

  String endPoint;
  String objectId;


  ParseDeleteCommand(this.endPoint, [this.objectId]);

  String getRequest() {
    return "";
  }

  String getEndPoint() {
    return endPoint + (objectId != null ? "/" + objectId : "");
  }

  Future<Response> getClient(String url, Map header) {
    return http.delete(url, headers : header);
  }

}
