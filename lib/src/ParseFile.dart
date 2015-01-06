part of dart_parse;

class ParseFile {
  final Logger _log = new Logger("ParseFile");

  String endPoint;
  bool isDirty = true;
  String name;
  String url;
  String contentType;
  List<int> data;

  ParseFile(this.name, {this.data, this.contentType, this.url}) {
    this.endPoint = "files/";
    if (data.length > ParseConstant.MAX_PARSE_FILE_SIZE) {
      throw new ArgumentError("ParseFile must be less than $ParseConstant.MAX_PARSE_FILE_SIZE bytes, current $data.length");
    }
  }

  Future<ParseFile> save() {
    var completer = new Completer();
    if (isDirty && data != null) {
      ParseUploadCommand command = new ParseUploadCommand(endPoint + name);
      command.setData(data);
      if (contentType == null) {
        String possibleFileExtension = mime(name);
        contentType = possibleFileExtension == null ? "text/plain" : possibleFileExtension;
      }
      command.setContentType(contentType);
      command.perform().then((ParseResponse response) {
        JsonObject jsonResponse = response.getJsonObject();
        if (!response.isFailed() && jsonResponse != null) {
          url = jsonResponse["url"];
          name = jsonResponse["name"];
          isDirty = false;
          completer.complete(this);
        } else {
          completer.completeError(response.getException());
        }
      }, onError: completer.completeError);

    } else {
      completer.complete(this);
    }
    return completer.future;
  }

  //TODO
  Future<ParseFile> getData() {
    var completer = new Completer();
    completer.complete(this);
    return completer.future;
  }

  Future<bool> delete() {
    var completer = new Completer();
    ParseDeleteCommand command = new ParseDeleteCommand(endPoint + name);
    command.perform().then((ParseResponse response) {
      name = null;
      url = null;
      data = null;
      isDirty = false;
      if(response.isFailed()) {
        completer.completeError(response.getException());
      } else {
        completer.complete(true);
      }
    }, onError: completer.completeError);
    return completer.future;
  }

}