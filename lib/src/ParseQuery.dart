part of dart_parse;

class ParseQuery<T extends ParseObject> {

  String endpoint;
  String className;
  int skip = 0;
  int limit = -1;
  Map<String, Object> where = new Map<String, Object>();

  ParseQuery(this.className);

  whereEqualTo(String key, Object value) {
    this.where.putIfAbsent(key, () => value);
  }

  Future<T> get(String objectId) {
    //whereEqualTo("objectId", objectId);

    var completer = new Completer();
    find().then((List<T> results){
      if (results.length > 0) {
        print(" dgsd " + results[0]);
        completer.complete(results[0]);
      }
    });

    return completer.future;
  }

  Future<List<T>> find([JsonObject query]) {
    if (query == null) {
      query = toRest();
    }
    if (className != "users" && className != "roles") {
      endpoint = "classes/" + className;
    } else {
      endpoint = className;
    }
    var completer = new Completer();
    ParseGetCommand command = new ParseGetCommand(endpoint);
    command.perform().then((ParseResponse response){
      if (!response.isFailed()) {
        if(response.getJsonObject() == null) {
          throw response.getException();
        }


        List results = response.getJsonMap()["results"];
        if(results.length == 0) {
          completer.complete(null);
          return;
        }
        List<T> parseObjects = new List<T>();
        results.forEach((Map resultMap) {

          ParseObject parseObject = new ParseObject(className);
          parseObject.setData(resultMap, false);
          parseObjects.add(parseObject);

          print(" result " + resultMap.toString());
          int rez = resultMap["code"];
          print("code: " + rez.toString());
          resultMap.forEach((k,v) {
            print("$k: $v");
          });
        });

        completer.complete(parseObjects);
      }
    });


    return completer.future;
  }

  JsonObject toRest() {
    JsonObject params = new JsonObject();
    try {
      params.putIfAbsent("className", () => this.className);

      if(this.where.length > 0) {
        params.putIfAbsent("where", () => ParseEncoder.encode(this.where, PointerEncodingStrategy.get()));
      }

      if (this.limit >= 0) {
        params.putIfAbsent("limit", () => this.limit);
      }

      if (this.skip > 0) {
        params.putIfAbsent("skip", () => this.skip);
      }

     /* if (this.order != null) {
        params.putIfAbsent("order", () => this.order);
      }

      if (!this.include.isEmpty()) {
        params.putIfAbsent("include", () => Parse.join(this.include, ","));
      }

      if (this.selectedKeys != null) {
        params.putIfAbsent("keys", () => Parse.join(this.selectedKeys, ","));
      }

      if (this.trace) {
        params.putIfAbsent("trace", () => "1");
      }

      for (String key : this.extraOptions.keySet()) {
        params.putIfAbsent(key, () => ParseEncoder.encode(this.extraOptions.get(key), PointerEncodingStrategy.get()));
      }*/

    } on JsonObjectException catch (e) {
      print(e);
    }

    return params;
  }
}
