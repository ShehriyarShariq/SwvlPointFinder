import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PointModel {
  final String name;
  final GeoPoint location;
  final List<String> images;

  PointModel({
    required this.name,
    required this.location,
    required this.images,
  });

  factory PointModel.fromMap(Map<String, dynamic> map) {
    return PointModel(
      name: map['name'],
      location: map['location'],
      images: map.containsKey('images') ? List<String>.from(map['images']) : [],
    );
  }
}
