part of dart_parse;

class SetOperation extends ParseFieldOperation {
  Object value;

  SetOperation(this.value);

  /**
   * @param oldValue dgads
   */
  Object apply(Object oldValue, ParseObject parseObject, String key) {
    return value;
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    return ParseEncoder.encode(value, objectEncoder);
  }


}
