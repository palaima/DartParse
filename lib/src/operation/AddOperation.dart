part of dart_parse;

class AddOperation extends ParseFieldOperation {
  List objects;

  AddOperation(this.objects);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    throw new ArgumentError("not implemented!");
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    JsonObject output = new JsonObject();
    output.putIfAbsent("__op", () => "Add");
    output.putIfAbsent("objects", () => ParseEncoder.encode(objects, objectEncoder));
    return output;
  }


}