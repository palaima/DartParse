part of dart_parse;

abstract class ParseCommand {

  final Logger _log = new Logger("ParseCommand");

  var _client = new http.Client();
  JsonObject _data = new JsonObject();

  String getEndPoint();
  String getRequest();
  Future<Response> getClient(http.Client client, String url, Map header);

  Future<ParseResponse> perform() {
    var completer = new Completer();
    String url = _getUrl(getEndPoint() + getRequest());
    _log.info(Uri.decodeQueryComponent(url));
    Map header = {ParseConstant.HEADER_APPLICATION_ID : ParseConstant.APPLICATION_ID,
        ParseConstant.HEADER_REST_API_KEY : ParseConstant.REST_API_KEY};


    //_client.send(new HttpRequest("GET", url, headers : header));
    //_client.get(url, headers : header).then((response){
    getClient(_client, url, header).then((response){
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

  String _getUrl(String endpoint) {
    return ParseConstant.API_ENDPOINT + "/" + ParseConstant.API_VERSION+ "/" + endpoint;
  }
}
