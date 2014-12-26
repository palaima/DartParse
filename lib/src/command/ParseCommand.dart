part of dart_parse;

abstract class ParseCommand {

  final Logger _log = new Logger("ParseCommand");

  var _client = new http.Client();
  JsonObject _data = new JsonObject();

  String getEndPoint();
  String getRequest();
  bool addJson();

  Future<ParseResponse> perform() {
    var completer = new Completer();
    String url = getUrl(getEndPoint() + getRequest());
    _log.info(Uri.decodeQueryComponent(url));
    var header = {ParseConstant.HEADER_APPLICATION_ID : ParseConstant.APPLICATION_ID,
        ParseConstant.HEADER_REST_API_KEY : ParseConstant.REST_API_KEY};
    if (addJson()) {
      header.putIfAbsent(ParseConstant.HEADER_CONTENT_TYPE, () => ParseConstant.CONTENT_TYPE_JSON);
    }
    _client.get(url, headers : header).then((response){
      completer.complete(new ParseResponse(response));
    }).whenComplete(_client.close())
    .catchError((handleFailure){
      _log.shout(handleFailure.toString());
    });
    return completer.future;
  }

  put(String key, Object value) {
    _data[key] = value;
  }

  String getUrl(String endpoint) {
    return ParseConstant.API_ENDPOINT + "/" + ParseConstant.API_VERSION+ "/" + endpoint;
  }
}
