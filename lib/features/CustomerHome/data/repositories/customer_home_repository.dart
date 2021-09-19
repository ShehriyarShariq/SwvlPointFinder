import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:latlng/latlng.dart';
import 'package:swvl_new_workflow/core/util/constants.dart';
import 'package:swvl_new_workflow/features/CustomerHome/data/models/route_model.dart';
import '../models/point_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/firebase/firebase.dart';
import '../../../../core/network/network_info.dart';
import '../models/booking_model.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:http/http.dart' as http;

class CustomerHomeRepository {
  final NetworkInfo networkInfo;

  CustomerHomeRepository({required this.networkInfo});

  Future<Either<Failure, BookingModel>> getBookingDetails(
      {required String id}) async {
    if (await networkInfo.isConnected) {
      Map<String, dynamic> bookingData = await FirebaseInit.dbRef
          .collection("bookings")
          .doc(id)
          .get()
          .then((value) => value.data() ?? {});

      Map<String, dynamic> pointData = await FirebaseInit.dbRef
          .collection("points")
          .doc(bookingData['start'])
          .get()
          .then((value) => value.data() ?? {});

      return Right(BookingModel(start: PointModel.fromMap(pointData)));
    } else {
      return Left(NetworkFailure());
    }
  }

  Future<Either<Failure, RouteModel>> getPointsBetweenPoints(
      latLng.LatLng point1, latLng.LatLng point2) async {
    if (await networkInfo.isConnected) {
      var response = await http.get(Uri.parse(
          "https://api.mapbox.com/directions/v5/mapbox/walking/${point1.longitude},${point1.latitude};${point2.longitude},${point2.latitude}?overview=full&alternatives=false&geometries=polyline&steps=true&access_token=${Constants.MAPBOX_API_KEY}"));

      print(response.body);

      if (response.body.isNotEmpty) {
        Map<String, dynamic> routeObj = ((json.decode(response.body)
            as Map<String, dynamic>)['routes'] as List<dynamic>)[0];

        List<latLng.LatLng> points = [];

        for (Map<String, dynamic> step in routeObj['legs'][0]['steps']) {
          points.add(latLng.LatLng(
              step['intersections'][0]['location'][1] as double,
              step['maneuver']['location'][0] as double));
          points.add(latLng.LatLng(step['maneuver']['location'][1] as double,
              step['maneuver']['location'][0] as double));
        }

        RouteModel route = RouteModel(
          distance: routeObj["distance"] as double,
          duration: routeObj["duration"] as double,
          points: points,
        );

        return Right(route);
      } else {
        return Right(RouteModel(distance: 0, duration: 0, points: []));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
