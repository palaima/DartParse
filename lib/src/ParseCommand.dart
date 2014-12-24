part of dart_parse;

abstract class ParseCommand {

  var client = new http.Client();

  String getEndPoint();
  String getRequest();

  ParseCommand() {
    var client = new http.Client();
  }

  Future<ParseResponse> perform() {
    var completer = new Completer();
    String url = getUrl(getEndPoint());
    print(url);
    var header = {ParseConstant.HEADER_APPLICATION_ID : ParseConstant.APPLICATION_ID,
        ParseConstant.HEADER_REST_API_KEY : ParseConstant.REST_API_KEY,
        ParseConstant.HEADER_CONTENT_TYPE : ParseConstant.CONTENT_TYPE_JSON};
    client.get(url, headers : header)
    .then((response){
      completer.complete(new ParseResponse(response));
    })
    .whenComplete(client.close())
    .catchError((handleFailure){

    });
    return completer.future;
  }

  void setupHeaders() {

  }

  String getUrl(String endpoint) {
    return ParseConstant.API_ENDPOINT + "/" + ParseConstant.API_VERSION+ "/" + endpoint;
  }
}
