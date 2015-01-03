part of dart_parse;

class ParseQuery<T extends ParseObject> {

  final Logger _log = new Logger("ParseQuery");

  String _endpoint;
  String _className;
  int _skip = 0;
  int _limit = -1;
  String _order;
  Map<String, Object> _where = new Map<String, Object>();

  ParseQuery(this._className);

  whereEqualTo(String key, Object value) {
    _where[key] = value;
  }

  Future<T> get(String objectId) {
    var completer = new Completer();
    whereEqualTo("objectId", objectId);
    find().then((List<T> results){
      if (results.isEmpty) {
        completer.complete(null);
      } else {
        completer.complete(results[0]);
      }
    }, onError: completer.completeError);

    return completer.future;
  }

  Future<List<T>> find([JsonObject query]) {
    if (query == null) {
      query = toRest();
    }
    if (_className != "users" && _className != "roles") {
      _endpoint = "classes/" + _className;
    } else {
      _endpoint = _className;
    }
    var completer = new Completer();
    ParseGetCommand command = new ParseGetCommand(_endpoint);
    query.remove("className");
    command.put("data", query);
    command.perform().then((ParseResponse response){
      if (!response.isFailed()) {
        if(response.getJsonObject() == null) {
          completer.completeError(response.getException());
          return;
        }


        List results = response.getJsonMap()["results"];
        List<T> parseObjects = new List<T>();
        if(results.isEmpty) {
          completer.complete(parseObjects);
        } else {
          results.forEach((Map resultMap) {

            ParseObject parseObject = new ParseObject(_className);
            parseObject.setData(resultMap, false);
            parseObjects.add(parseObject);
            /*_log.info(" result " + resultMap.toString());
            int rez = resultMap["code"];
            _log.info("code: " + rez.toString());
            resultMap.forEach((k,v) {
              _log.info("$k: $v");
            });*/
          });
          completer.complete(parseObjects);
        }

      }
    }).catchError((error) {
      _log.shout(error.toString());
      completer.completeError(error);
    });


    return completer.future;
  }

  ParseQuery<T> addAscendingOrder(String key) {
    _orderASC(key);
    return this;
  }

  ParseQuery<T> addDescendingOrder(String key) {
    _orderDSC(key);
    return this;
  }
  _orderDSC(String key) {
    _orderASC("-" + key);
  }

  _orderASC(String key) {
    if (_order == null)
      _order = key;
    else {
      _order = (_order + ", " + key);
    }
  }

  ParseQuery<T> limit(int newLimit) {
    _limit = newLimit;
    return this;
  }

  ParseQuery<T> skip(int newSkip) {
    _skip = newSkip;
    return this;
  }

  JsonObject toRest() {
    JsonObject params = new JsonObject();
    try {
      params.putIfAbsent("className", () => _className);

      if(_where.length > 0) {
        params.putIfAbsent("where", () => ParseEncoder.encode(_where, PointerEncodingStrategy.get()));
      }

      if (_limit >= 0) {
        params.putIfAbsent("limit", () => _limit);
      }

      if (_skip > 0) {
        params.putIfAbsent("skip", () => _skip);
      }

      if (_order != null) {
        params.putIfAbsent("order", () => _order);
      }
/*
      if (!this.include.isEmpty()) {
        params.putIfAbsent("include", () => Parse.join(this.include, ","));
      }

      if (this.selectedKeys != null) {
        params.putIfAbsent("keys", () => Parse.join(this.selectedKeys, ","));
      }

      for (String key : this.extraOptions.keySet()) {
        params.putIfAbsent(key, () => ParseEncoder.encode(this.extraOptions.get(key), PointerEncodingStrategy.get()));
      }*/

    } on JsonObjectException catch (e) {
      _log.shout(e);
    }

    return params;
  }
}
