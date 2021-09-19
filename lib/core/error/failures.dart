import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class AuthFailure extends Failure {
  final String errorMsg;

  AuthFailure({this.errorMsg = "Some error occurred"});
}

class NetworkFailure extends Failure {}
