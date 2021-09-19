import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'geofence_status_event.dart';
part 'geofence_status_state.dart';

class GeofenceStatusBloc
    extends Bloc<GeofenceStatusEvent, GeofenceStatusState> {
  GeofenceStatusBloc() : super(GeofenceStatusInitial());

  @override
  Stream<GeofenceStatusState> mapEventToState(
    GeofenceStatusEvent event,
  ) async* {
    if (event is GeofenceEnteredEvent) {
      yield WithinGeofence();
    } else if (event is GeofenceExitedEvent) {
      yield OutsideGeofence();
    }
  }
}
