part of dart_parse;

class PointerEncodingStrategy extends PointerOrLocalIdEncodingStrategy {
  static final PointerEncodingStrategy instance = new PointerEncodingStrategy();

  static PointerEncodingStrategy get() {
    return instance;
  }

  JsonObject encodeRelatedObject(ParseObject object) {
    if (object.getObjectId == null) {
      throw new ArgumentError(
          "unable to encode an association with an unsaved ParseObject");
    }
    return super.encodeRelatedObject(object);
  }
}
