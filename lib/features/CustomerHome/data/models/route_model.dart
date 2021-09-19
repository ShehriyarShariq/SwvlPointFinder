import 'package:cloud_firestore/cloud_firestore.dart';
import "package:latlong2/latlong.dart" as latLng;

class RouteModel {
  final double duration;
  final double distance;
  final List<latLng.LatLng> points;

  RouteModel(
      {required this.duration, required this.distance, required this.points});
}
