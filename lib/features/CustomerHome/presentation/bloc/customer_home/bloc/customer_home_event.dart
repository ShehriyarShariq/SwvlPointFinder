part of 'customer_home_bloc.dart';

abstract class CustomerHomeEvent extends Equatable {
  const CustomerHomeEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadBookingDetailsEvent extends CustomerHomeEvent {
  final String bookingId;

  LoadBookingDetailsEvent({required this.bookingId}) : super([bookingId]);
}

class CustomerHomeLoadNewPathEvent extends CustomerHomeEvent {
  final latLng.LatLng point1;
  final latLng.LatLng point2;

  CustomerHomeLoadNewPathEvent({required this.point1, required this.point2})
      : super([point1, point2]);
}
