part of dart_parse;

class ParseResponse {

  Logger _log = new Logger("ParseResponse");

  static final String RESPONSE_CODE_JSON_KEY = "code";
  static final String RESPONSE_ERROR_JSON_KEY = "error";

  Response response;

  String responseBody;
  Map headers;
  int contentLength;

  ParseResponse(Response response) {
    this.response = response;
    responseBody = response.body;
    contentLength = response.contentLength;
    headers = response.headers;
    _log.info(responseBody);
  }

  bool isFailed() => hasConnectionFailed() || hasErrorCode();

  bool hasConnectionFailed() => responseBody == null;

  bool hasErrorCode() => response.statusCode < 200 || response.statusCode >= 300;

  JsonObject getJsonObject() => new JsonObject.fromJsonString(responseBody);

  Map getJsonMap() => JSON.decode(responseBody);

  ParseException getException() {

    if (hasConnectionFailed()) {
      return new ParseException(ParseException.CONNECTION_FAILED,
      "Connection to Parse servers failed.");
    }

    if (!hasErrorCode()) {
      return new ParseException(ParseException.OPERATION_FORBIDDEN,
      "getException called with successful response");
    }

    JsonObject response = getJsonObject();

    if (response == null) {
      return new ParseException(ParseException.INVALID_JSON,
      "Invalid response from Parse servers.");
    }

    return _getParseError(response);
  }

  ParseException _getParseError(JsonObject response) {

    int code;
    String error;

    try {
      code = response[RESPONSE_CODE_JSON_KEY];
    } on JsonObjectException catch(e) {
      code = ParseException.NOT_INITIALIZED;
    }

    try {
      error = response[RESPONSE_ERROR_JSON_KEY];
    } on JsonObjectException catch(e) {
      error = "Error undefinted by Parse server.";
    }

    return new ParseException(code, error);
  }
}
