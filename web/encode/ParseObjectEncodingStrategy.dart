import 'package:json_object/json_object.dart';
import '../ParseObject.dart';

abstract class ParseObjectEncodingStrategy {
  JsonObject encodeRelatedObject(ParseObject parseObject);
}
