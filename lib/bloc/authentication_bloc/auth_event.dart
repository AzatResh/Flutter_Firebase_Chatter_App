part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable{}

class AuthStartedEvent extends AuthEvent{

  @override
  List<Object?> get props => [];
}

class AuthSignOutEvent extends AuthEvent{

  @override
  List<Object?> get props => [];
}