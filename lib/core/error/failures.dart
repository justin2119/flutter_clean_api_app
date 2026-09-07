import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const <dynamic>[]]);
  final List<dynamic> properties;
  @override
  List<Object?> get props => properties;
}
class ServerFailure extends Failure { const ServerFailure([super.properties]); }
class CacheFailure extends Failure { const CacheFailure([super.properties]); }
class NetworkFailure extends Failure { const NetworkFailure([super.properties]); }
class AuthFailure extends Failure { const AuthFailure([super.properties]); }
