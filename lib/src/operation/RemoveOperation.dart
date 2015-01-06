part of dart_parse;

class RemoveOperation extends ParseFieldOperation {
  List objects;

  RemoveOperation(this.objects);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    throw new ArgumentError("not implemented!");
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    JsonObject output = new JsonObject();
    output.putIfAbsent("__op", () => "Remove");
    output.putIfAbsent("objects", () => ParseEncoder.encode(objects, objectEncoder));
    return output;
  }


}