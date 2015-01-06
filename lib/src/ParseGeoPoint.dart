part of dart_parse;

class ParseGeoPoint {
  String endPoint;
  bool isDirty = true;
  double _lat;
  double _lon;

  ParseGeoPoint(this._lat, this._lon) {
    this.endPoint = "PlaceObject/";
    if ((_lat > 90.0) || (_lat < -90.0)) {
      throw new ArgumentError("Latitude must be within the range (-90.0, 90.0).");
    }
    if ((_lon > 180.0) || (_lon < -180.0)) {
      throw new ArgumentError("Longitude must be within the range (-180.0, 180.0).");
    }
  }

  double get latitude => _lat;
  double get longitude => _lon;

}