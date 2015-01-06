part of dart_parse;

class ParseObject {
  final Logger _log = new Logger("ParseObject");

  String endPoint;
  String _className;
  bool isDirty = true;
  List<String> dirtyKeys = new List();
  Map operations = new Map();
  Map<String, Object> data = new Map();

  String _objectId;
  DateTime _updatedAt;
  DateTime _createdAt;

  ParseObject(this._className) {
    setEndPoint("classes/" + _className);
  }

  static ParseObject createWithoutData(String className, String objectId) {
    ParseObject result = new ParseObject(className);
    result._objectId = objectId;
    return result;
  }

  //TODO batch
  static Future<List<ParseObject>> saveAll(List<ParseObject> objects) {
    List<Future<ParseObject>> futures = new List();
    objects.forEach((ParseObject object) {
      futures.add(object.save());
    });
    return Future.wait(futures);
  }

  //TODO batch
  static Future<List<bool>> deleteAll(List<ParseObject> objects) {
    List<Future<bool>> futures = new List();
    objects.forEach((ParseObject object) {
      futures.add(object.delete());
    });
    return Future.wait(futures);
  }

  String get className => _className;
  String get objectId => _objectId;
  DateTime get createdAt => _createdAt;
  DateTime get updatedAt => _updatedAt;

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

  ParseObject getParseObject(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is ParseObject)) {
      _log.shout("called getParseObject(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  ParseFile getParseFile(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is ParseFile)) {
      _log.shout("called getParseFile(${key}) but the value is ${value.runtimeType}");
      return null;
    }
    return value;
  }

  ParseGeoPoint getParseGeoPoint(String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    Object value = data[key];
    if (!(value is ParseGeoPoint)) {
      _log.shout("called getParseGeoPoint(${key}) but the value is ${value.runtimeType}");
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

  ParseObject add(String key, Object value) {
    return addAll(key, [value]);
  }

  ParseObject addAll(String key, List values) {
    AddOperation operation = new AddOperation(values);
    performOperation(key, operation);
    return this;
  }

  ParseObject addUnique(String key, Object value) {
    return addAllUnique(key, [value]);
  }

  ParseObject addAllUnique(String key, List values) {
    AddUniqueOperation operation = new AddUniqueOperation(values);
    performOperation(key, operation);
    return this;
  }

  ParseObject removeAll(String key, List values) {
    RemoveOperation operation = new RemoveOperation(values);
    performOperation(key, operation);
    return this;
  }

  ParseObject decrement(String key, [num amount = -1]) {
    return increment(key, amount);
  }

  ParseObject increment(String key, [num amount = 1]) {
    if (!amount.isNegative) amount = -amount;
    IncrementOperation operation = new IncrementOperation(amount);
    Object oldValue = data[key];
    Object newValue = operation.apply(oldValue, this, key);
    data[key] = newValue;
    operations[key] = operation;
    dirtyKeys.add(key);
    isDirty = true;
    return this;
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

    if (value is ParseFile && !value.isDirty && !disableChecks) {
      throw new ArgumentError("ParseFile must be saved before being set on a ParseObject.");
    }

    if (Parse.isInvalidKey(key)) {
      throw new ArgumentError("reserved value for key: " + key);
    }

    if (!Parse.isValidType(value)) {
      throw new ArgumentError("invalid type for value: " + value.runtimeType.toString());
    }

    performOperation(key, new SetOperation(value));

    return this;
  }

  remove(String key) {

    if(has(key)) {
      if(objectId != null) {
        //if the object was saved before, we need to add the delete operation
        operations[key] = new DeleteOperation();
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
      _objectId = value.toString();
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
    _objectId = null;
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
      JsonObject jsonResponse = response.getJsonObject();
      if (!response.isFailed() && jsonResponse != null) {

        if(objectId == null) {
          _objectId = jsonResponse[ParseConstant.FIELD_OBJECT_ID];
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
      } else {
        completer.completeError(response.getException());
      }
    }, onError: completer.completeError);
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
      _updatedAt = null;
      _createdAt = null;
      _objectId = null;
      isDirty = false;
      operations.clear();
      dirtyKeys.clear();
      if(response.isFailed()) {
        completer.completeError(response.getException());
      } else {
        completer.complete(true);
      }
    }, onError: completer.completeError);

    return completer.future;
  }

  //TODO tests
  Future<ParseObject> fetch() {
    var completer = new Completer();
    if(objectId == null) {
      completer.complete(this);
      return completer.future;
    }

    ParseCommand command = new ParseGetCommand(endPoint, objectId);
    command.perform().then((ParseResponse response) {
      JsonObject jsonResponse = response.getJsonObject();
      if (!response.isFailed() && jsonResponse != null) {
        completer.complete(parseData(jsonResponse));
      } else {
        completer.completeError(response.getException());
      }
    }, onError: completer.completeError);
    return completer.future;
  }

  ParseObject parseData(JsonObject jsonObject) {

    ParseObject po = new ParseObject(className);

    jsonObject.keys.forEach((String key) {
      Object obj = jsonObject[key];
      if(obj is JsonObject ){
        JsonObject o = obj;
        String type = o["__type"];

        if("Date" == type) {
          DateTime date = Parse.parseDate(o["iso"]);
          po.put(key, date);
        }
        if("Bytes" == type) {
          String base64 = o["base64"];
          po.put(key, base64);
        }
        if("GeoPoint" == type) {
          ParseGeoPoint gp = new ParseGeoPoint(o["latitude"], o["longitude"]);
          po.put(key, gp);
        }
        if("File" == type) {
          ParseFile file = new ParseFile(o["name"], url : o["url"]);
          po.put(key, file);
        }
        if("Pointer" == type) {

        }
      } else {
        if(Parse.isInvalidKey(key)) {
          setReservedKey(key, obj);
        }
        else {
          put(key, ParseDecoder.decode(obj));
        }
      }
    });
    po.isDirty = false;
    return po;
  }

  JsonObject getParseData() {
    JsonObject parseData = new JsonObject();

    operations.keys.forEach((String key) {
      if(operations[key] is SetOperation) {
        parseData[key] = operations[key].encode(PointerEncodingStrategy.get());
      }
      else if(operations[key] is IncrementOperation) {
        parseData[key] = operations[key].encode(PointerEncodingStrategy.get());
      }
      else if(operations[key] is DeleteOperation) {
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

  String toString() {
    JsonObject object = new JsonObject();
    object["objectId"] = objectId;
    object["createdAt"] = _createdAt.toString();
    object["updatedAt"] = _updatedAt.toString();
    data.forEach((String key, var value) {
      if (value is DateTime) {
        object[key] = value.toString();
      } else if (value is ParseObject) {
        object[key] = value.toString();
      } else {
        object[key] = value;
      }
    });
    return object.toString();
  }
}
