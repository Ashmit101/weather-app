class GeoLocation {
  int? id;
  String name;
  String country;
  String? state;
  double lat;
  double lon;

  GeoLocation.fromJsonMap(Map<String, dynamic> locationMap)
      : name = locationMap['name'] as String,
        country = locationMap['country'] as String,
        state = locationMap['state'],
        lat = locationMap['lat'] as double,
        lon = locationMap['lon'] as double;

  toString() {
    if (state == null) {
      return '$name, $country';
    } else {
      return '$name, $state, $country';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'state': state,
      'country': country,
      'lat': lat,
      'lon': lon
    };
  }

  GeoLocation.fromMap(Map<String, dynamic> geoLocationMap)
      : name = geoLocationMap['name'],
        state = geoLocationMap['state'],
        country = geoLocationMap['country'],
        lat = geoLocationMap['lat'],
        lon = geoLocationMap['lon'];
}
