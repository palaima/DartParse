part of dart_parse;

class DeleteOperation extends ParseFieldOperation {

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    return null;
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    JsonObject output = new JsonObject();
    output.putIfAbsent("__op", () => "Delete");
    return output;
  }


}