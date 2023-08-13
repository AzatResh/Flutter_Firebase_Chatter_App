import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/model/user.dart';
import 'package:flutter_chatter/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitState()){
    on<AuthStartedEvent>(start);
    on<AuthSignOutEvent>(signOut);
  }

  start(AuthStartedEvent event, Emitter<AuthState> emit) async {
    UserModel user = await _authRepository.retrieveCurrentUser().first;

    if(user.id != 'empty'){
      emit(AuthSuccessState(userName: user.email));
    } else {
      emit(AuthFailureState());
    }
  }

  signOut(AuthSignOutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(AuthFailureState());
  }
}