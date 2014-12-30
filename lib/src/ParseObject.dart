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

  DateTime _updatedAt;
  DateTime _createdAt;

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
  DateTime get getUpdatedAt => _updatedAt;
  DateTime get getCreatedAt => _createdAt;

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

  ParseObject put(String key, Object value, [bool disableChecks = false]){

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

    return this;
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
      _createdAt = Parse.parseDate(value.toString());
    }
    else if ("updatedAt" == key) {
      _updatedAt = Parse.parseDate(value.toString());
    }
  }

  clearData() {
    data.clear();
    dirtyKeys.clear();
    operations.clear();
    isDirty = false;
    objectId = null;
    _createdAt = null;
    _updatedAt = null;
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

  Future<ParseObject> save() {
    var completer = new Completer();
    if (!isDirty) {
      completer.complete(this);
      return completer.future;
    }

    ParseCommand command;
    if(objectId == null) {
      command = new ParsePostCommand(endPoint);
    }
    else {
      command =  new ParsePutCommand(endPoint, objectId);
    }

    command.put("data", getParseData());


    command.perform().then((ParseResponse response) {
      if (!response.isFailed()) {
        JsonObject jsonResponse = response.getJsonObject();
        if (jsonResponse == null) {
          throw response.getException();
        }

        if(objectId == null) {
          objectId = jsonResponse[ParseConstant.FIELD_OBJECT_ID];
          String createdAt = jsonResponse[ParseConstant.FIELD_CREATED_AT];
          _createdAt = Parse.parseDate(createdAt);
          _updatedAt = Parse.parseDate(createdAt);
        }
        else {
          String updatedAt = jsonResponse[ParseConstant.FIELD_UPDATED_AT];
          _updatedAt = Parse.parseDate(updatedAt);
        }

        this.isDirty = false;
        this.operations.clear();
        this.dirtyKeys.clear();
        completer.complete(this);
      }
    });
    return completer.future;
  }

  Future<bool> delete() {
    var completer = new Completer();

    if(objectId == null) {
      completer.complete(true);
      return completer.future;
    }

    ParseCommand command = new ParseDeleteCommand(endPoint, objectId);
    command.perform().then((ParseResponse response) {
      if(response.isFailed()) {
        throw response.getException();
      }

      _updatedAt = null;
      _createdAt = null;
      objectId = null;
      isDirty = false;
      operations.clear();
      dirtyKeys.clear();
      completer.complete(true);
    });



    return completer.future;
}

  JsonObject getParseData() {
    JsonObject parseData = new JsonObject();

    operations.keys.forEach((String key) {
      if(operations[key] is SetFieldOperation) {
        parseData[key] = operations[key].encode(PointerEncodingStrategy.get());
      }
      /*else if(operations[key] is IncrementFieldOperation) {
        parseData.put(key, operation.encode(PointerEncodingStrategy.get()));
      }*/
      else if(operations[key] is DeleteFieldOperation) {
          parseData[key] = operations[key].encode(PointerEncodingStrategy.get());
      }
      /*else if(operations[key] is RelationOperation) {
        parseData.put(key, operation.encode(PointerEncodingStrategy.get()));
      }*/
      else {
        //here we deal will sub objects like ParseObject;
        Object obj = data[key];
        if(obj is ParseObject) {
          parseData[key] = obj.getParseData();
        }
      }
    });

    _log.info("parse data " + parseData.toString());
    return parseData;
  }
}
