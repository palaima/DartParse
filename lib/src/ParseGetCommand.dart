part of dart_parse;

class ParseGetCommand extends ParseCommand {

  String endPoint;
  String objectId;


  ParseGetCommand(this.endPoint, [this.objectId]);

  String getRequest() {

  }

  String getEndPoint() {
    return endPoint;
  }


}
