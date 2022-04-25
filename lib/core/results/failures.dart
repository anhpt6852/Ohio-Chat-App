import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class SystemFailure extends Failure {}

class NoInternetConnection extends Failure {}

class NoDataFound extends Failure {}

class DataConsistencyError extends Failure {}

class NoCacheData extends Failure {}

//Error when excute server function
class NoPermission extends Failure {}

// To remove
class AuthFailure extends Failure {
  final String? code;
  AuthFailure({this.code});

  @override
  List<Object?> get props => [code];
}
