part of dart_parse;

class IncrementOperation extends ParseFieldOperation {
  num amount;
  bool increase = true;

  IncrementOperation(this.amount);

  Object apply(Object oldValue, ParseObject parseObject, String key) {
    if (oldValue == null) {
      increase = false;
      return amount;
    }

    if ((oldValue is num)) {
      return oldValue + amount;
    }
    throw new ArgumentError("You cannot increment a non-number. Key type ["+oldValue.runtimeType.toString()+"]");
  }

  Object encode(ParseObjectEncodingStrategy objectEncoder) {
    if(increase) {
      JsonObject output = new JsonObject();
      output.putIfAbsent("__op", () => "Increment");
      output.putIfAbsent("amount", () => this.amount);
      return output;
    }
    else {
      return amount;
    }
  }


}