import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:swvl_new_workflow/features/CustomerHome/data/models/route_model.dart';
import '../../../../data/models/booking_model.dart';
import '../../../../data/repositories/customer_home_repository.dart';
import "package:latlong2/latlong.dart" as latLng;

part 'customer_home_event.dart';
part 'customer_home_state.dart';

class CustomerHomeBloc extends Bloc<CustomerHomeEvent, CustomerHomeState> {
  CustomerHomeRepository customerHomeRepository;

  CustomerHomeBloc({required this.customerHomeRepository})
      : super(CustomerHomeLoading());

  @override
  Stream<CustomerHomeState> mapEventToState(
    CustomerHomeEvent event,
  ) async* {
    if (event is LoadBookingDetailsEvent) {
      final failureOrBooking =
          await customerHomeRepository.getBookingDetails(id: event.bookingId);
      yield failureOrBooking.fold((failure) => LoadError(),
          (booking) => CustomerHomeLoadedBooking(booking: booking));
    } else if (event is CustomerHomeLoadNewPathEvent) {
      final failureOrPath = await customerHomeRepository.getPointsBetweenPoints(
          event.point1, event.point2);
      yield failureOrPath.fold((failure) => PathLoadError(),
          (path) => CustomerHomeLoadedPath(route: path));
    }
  }
}
