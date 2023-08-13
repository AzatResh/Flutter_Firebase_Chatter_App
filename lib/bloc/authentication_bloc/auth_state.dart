part of 'auth_bloc.dart';

abstract class AuthState extends Equatable{}

class AuthInitState extends AuthState{
  
  @override
  List<Object?> get props => [];
}

class AuthSuccessState extends AuthState{
  final String? userName;
  AuthSuccessState({this.userName});

  @override
  List<Object?> get props => [];
}

class AuthFailureState extends AuthState{
  
  @override
  List<Object?> get props => [];
}