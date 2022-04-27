import 'package:cloud_firestore/cloud_firestore.dart';

import 'geo_location.dart';

DateTime? nullableDateTimeFromTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return null;
  return timestamp.toDate();
}

Timestamp? nullableDateTimeToTimestamp(DateTime? date) =>
    date != null ? Timestamp.fromDate(date) : null;

GeoLocation geoLocationFromGeoPoint(GeoPoint geoPoint) {
  return GeoLocation(
      latitude: geoPoint.latitude, longitude: geoPoint.longitude);
}

GeoPoint geoLocationToGeoPoint(GeoLocation geoLocation) =>
    GeoPoint(geoLocation.latitude, geoLocation.longitude);
