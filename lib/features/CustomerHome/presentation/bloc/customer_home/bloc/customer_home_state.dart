part of 'customer_home_bloc.dart';

abstract class CustomerHomeState extends Equatable {
  const CustomerHomeState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class CustomerHomeLoading extends CustomerHomeState {}

class CustomerHomeLoadedBooking extends CustomerHomeState {
  final BookingModel booking;

  CustomerHomeLoadedBooking({required this.booking}) : super([booking]);
}

class CustomerHomeLoadedPath extends CustomerHomeState {
  final RouteModel route;

  CustomerHomeLoadedPath({required this.route}) : super([route]);
}

class LoadError extends CustomerHomeState {}

class PathLoadError extends CustomerHomeState {}
