part of dart_parse;

class SetFieldOperation extends ParseFieldOperation {
  Object value;

  SetFieldOperation(this.value);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    return value;
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    return ParseEncoder.encode(value, objectEncoder);
  }


}
