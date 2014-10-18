import '../ParseObject.dart';
import '../encode/ParseObjectEncodingStrategy.dart';

abstract class ParseFieldOperation {
  Object apply(Object oldValue, ParseObject parseObject, String key);
  Object encode(ParseObjectEncodingStrategy objectEncoder);
}
