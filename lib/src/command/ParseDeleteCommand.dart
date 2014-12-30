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

  Future<Response> getClient(http.Client client, String url, Map header) {
    return client.delete(url, headers : header);
  }

}
