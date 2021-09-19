part of 'geofence_status_bloc.dart';

abstract class GeofenceStatusEvent extends Equatable {
  const GeofenceStatusEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GeofenceEnteredEvent extends GeofenceStatusEvent {}

class GeofenceExitedEvent extends GeofenceStatusEvent {}
