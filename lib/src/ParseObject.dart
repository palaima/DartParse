part of dart_parse;

class ParseObject {
  final Logger _log = new Logger("ParseObject");

  String endPoint;
  String objectId;
  String className;
  bool isDirty = false;
  List<String> dirtyKeys = new List();
  Map operations = new Map();
  Map<String, Object> data = new Map();

  DateTime updatedAt;
  DateTime createdAt;

  ParseObject(this.className) {
    setEndPoint("classes/" + className);
  }

  static ParseObject createWithoutData(String className, String objectId) {
    ParseObject result = new ParseObject(className);
    result.objectId = objectId;
    result.isDirty = false;
    return result;
  }

  String get getObjectId => objectId;
  String get getClassName => className;

  DateTime getDate(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is DateTime)) {
      _log.shout("called getDate(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  bool getBoolean(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is bool)) {
      _log.shout("called getBoolean(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  num getNumber(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is num)) {
      _log.shout("called getNumber(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  int getInt(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is int)) {
      _log.shout("called getInt(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  double getDouble(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is double)) {
      _log.shout("called getDouble(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  String getString(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is String)) {
      _log.shout("called getString(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  List getList(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is List)) {
      _log.shout("called getList(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  setData(Map result, [bool disableChecks = false]) {
    result.forEach((key, value) {
      if(Parse.isInvalidKey(key)) {
        setReservedKey(key, value);
      }
      else {
        put(key, ParseDecoder.decode(value), disableChecks);
      }
    });

    this.isDirty = false;
    this.operations.clear();
    this.dirtyKeys.clear();
  }

  put(String key, Object value, bool disableChecks){

    if (key == null) {
      throw new ArgumentError("key may not be null.");
    }

    if (value == null) {
      throw new ArgumentError("value may not be null.");
    }

    if (value is ParseObject && value.isDirty) {
      throw new ArgumentError("ParseFile must be saved before being set on a ParseObject.");
    }

    /*if (value instanceof ParseFile && !((ParseFile) value).isUploaded() && !disableChecks) {
    throw new IllegalArgumentException(
    "ParseFile must be saved before being set on a ParseObject.");
    }*/

    if (Parse.isInvalidKey(key)) {
      throw new ArgumentError("reserved value for key: " + key);
    }

    if (!Parse.isValidType(value)) {
      throw new ArgumentError("invalid type for value: " + value.runtimeType.toString());
    }

    performOperation(key, new SetFieldOperation(value));

  }

  remove(String key) {

    if(has(key)) {
      if(objectId != null) {
        //if the object was saved before, we need to add the delete operation
        operations[key] = new DeleteFieldOperation();
      }
      else {
        operations.remove(key);
      }
      data.remove(key);
      dirtyKeys.add(key);
      isDirty = true;
    }
  }

  performOperation(String key, ParseFieldOperation operation) {

    //if field already exist, remove field and any pending operation for that field
    if (has(key)) {
      operations.remove(key);
      data.remove(key);
    }

    Object value = operation.apply(null, this, key);
    if (value != null) {
      data[key] = value;
    }
    else {
      data.remove(key);
    }
    operations[key] = operation;
    dirtyKeys.add(key);
    isDirty = true;

  }

  setReservedKey(String key, Object value) {
    if ("objectId" == key) {
      objectId = value.toString();
    }
    else if ("createdAt" == key) {
      createdAt = Parse.parseDate(value.toString());
    }
    else if ("updatedAt" == key) {
      updatedAt = Parse.parseDate(value.toString());
    }
  }

  clearData() {
    data.clear();
    dirtyKeys.clear();
    operations.clear();
    isDirty = false;
    objectId = null;
    createdAt = null;
    updatedAt = null;
  }

  bool has(String key) {
    return containsKey(key);
  }

  bool containsKey(String key) {
    return this.data.containsKey(key);
  }

  setEndPoint(String endPoint) {
    this.endPoint = endPoint;
  }

  save() {
    if (!isDirty) {
      return;
    }

    if (objectId == null) {

    }
  }
}
