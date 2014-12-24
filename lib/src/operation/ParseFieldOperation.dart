part of dart_parse;

abstract class ParseFieldOperation {
  Object apply(Object oldValue, ParseObject parseObject, String key);
  Object encode(ParseObjectEncodingStrategy objectEncoder);
}
