part of 'internet_cubit.dart';

@immutable
abstract class InternetState extends Equatable {
  const InternetState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {}

class InternetDisconnected extends InternetState {}
