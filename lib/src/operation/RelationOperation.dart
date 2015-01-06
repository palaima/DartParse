part of dart_parse;

class RelationOperation extends ParseFieldOperation {
  Object value;

  RelationOperation(this.value);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    return value;
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    return ParseEncoder.encode(value, objectEncoder);
  }


}