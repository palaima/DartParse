part of dart_parse;

class AddUniqueOperation extends ParseFieldOperation {
  List objects;

  AddUniqueOperation(this.objects);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    throw new ArgumentError("not implemented!");
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    JsonObject output = new JsonObject();
    output.putIfAbsent("__op", () => "AddUnique");
    output.putIfAbsent("objects", () =>  ParseEncoder.encode(objects, objectEncoder));
    return output;
  }


}