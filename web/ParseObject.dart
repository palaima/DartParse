import 'Parse.dart';
import 'operation/SetFieldOperation.dart';
import 'operation/ParseFieldOperation.dart';
import 'util/ParseDecoder.dart';

class ParseObject {
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
    if (data.containsKey(key) && data[key] is DateTime) {
      return data[key];
    }
    return null;
  }

  bool getBoolean(String key) {
    if (data.containsKey(key) && data[key] is bool) {
      return data[key];
    }
    return null;
  }

  num getNumber(String key) {
    if (data.containsKey(key) && data[key] is num) {
      return data[key];
    }
    return null;
  }

  int getInt(String key) {
    if (data.containsKey(key) && data[key] is int) {
      return data[key];
    }
    return null;
  }

  double getDouble(String key) {
    if (data.containsKey(key) && data[key] is double) {
      return data[key];
    }
    return null;
  }

  String getString(String key) {
    if (data.containsKey(key) && data[key] is String) {
      return data[key];
    }
    return null;
  }

  List getList(String key) {
    if (data.containsKey(key) && data[key] is List) {
      return data[key];
    }
    return null;
  }

  setData(Map result, [bool disableChecks]) {
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

  performOperation(String key, ParseFieldOperation operation) {

    //if field already exist, remove field and any pending operation for that field
    if (has(key)) {
      operations.remove(key);
      data.remove(key);
    }

    Object value = operation.apply(null, this, key);
    if (value != null) {
      data.putIfAbsent(key, ()=> value);
    }
    else {
      data.remove(key);
    }
    operations.putIfAbsent(key, ()=> operation);
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
    this.dirtyKeys.clear();
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
}
