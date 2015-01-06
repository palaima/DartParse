part of dart_parse;

class ParseUploadCommand extends ParseCommand {



  String endPoint;
  String contentType;
  List<int> bytes;

  ParseUploadCommand(this.endPoint);

  String getRequest() {
    return "";
  }

  String getEndPoint() {
    return endPoint;
  }

  setContentType(contentType) {
    this.contentType = contentType;
  }

  //TODO
  Future<Response> getClient(String url, Map header) {

    /*FileReader reader = new FileReader();
    reader.onLoad.listen((e) {
      HttpRequest.request("http://localhost:8080/files/ method: 'POST',
      sendData: reader.result).then((request) {
        // Does something witht he response
      });
    });
    reader.readAsArrayBuffer(input.files[i]);
    */
    if (contentType != null) {
      header.putIfAbsent(ParseConstant.HEADER_CONTENT_TYPE, () => contentType);
    }
    return http.post(url, headers : header, body : bytes);
  }

  setData(List<int> bytes) {
    this.bytes = bytes;
  }

}
