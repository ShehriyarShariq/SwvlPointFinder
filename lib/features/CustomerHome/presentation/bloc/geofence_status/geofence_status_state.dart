part of 'geofence_status_bloc.dart';

abstract class GeofenceStatusState extends Equatable {
  const GeofenceStatusState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GeofenceStatusInitial extends GeofenceStatusState {}

class WithinGeofence extends GeofenceStatusState {}

class OutsideGeofence extends GeofenceStatusState {}
