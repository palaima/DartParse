part of dart_parse;

class DeleteFieldOperation extends ParseFieldOperation {

  /**
   * @param oldValue dgads
   */
  Object apply(Object oldValue, ParseObject parseObject, String key) {
    return null;
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    //Map output = new Map();
    //output["__op"] = "Delete";
    return {"__op" : "Delete"};
  }


}