import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/model/user.dart';
import 'package:flutter_chatter/repository/auth_repository.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormsValidateState>{
  final AuthRepository _authRepository;

  FormBloc(this._authRepository)  : super(const FormsValidateState(
            id: "",
            name: '',
            email: "example@gmail.com",
            password: "",
            confirmPassword: "",
            isEmailValid: true,
            isNameValid: true,
            isPasswordValid: true,
            isConfirmPasswordValid: true,
            isFormValid: false,
            isEmailSended: false,
            isLoading: false,
            isFormValidateFailed: false)){
    on<FormInitEVent>(_onInit);
    on<FormEmailChangedEVent>(_onEmailChanged);
    on<FormNameChangedEVent>(_onNameChanged);
    on<FormPasswordChangedEvent>(_onPasswordChanged);
    on<FormConfirmPasswordChangedEvent>(_onConfirmPasswordChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
  }

  _onInit(FormInitEVent event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(
      id: "",
      name: '',
      email: "example@gmail.com",
      password: "",
      confirmPassword: "",
      isEmailValid: true,
      isNameValid: true,
      isPasswordValid: true,
      isConfirmPasswordValid: true,
      isFormValid: false,
      isLoading: false,
      isFormValidateFailed: false,
      isEmailSended: false,
      errorMessage: "")
    );
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-].{8,}$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }
  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }
  bool _isPasswordValid(String password){
    return _passwordRegExp.hasMatch(password);
  }

  bool _isConfirmPasswordValid(String password, String confirmPassword){
    return _passwordRegExp.hasMatch(password) && password == confirmPassword;
  }

  _onEmailChanged(FormEmailChangedEVent event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onNameChanged(FormNameChangedEVent event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      name: event.name,
      isNameValid: _isNameValid(event.name),
    ));
  }

  _onPasswordChanged(FormPasswordChangedEvent event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: _isPasswordValid(event.password),
    ));
  }

  _onConfirmPasswordChanged(FormConfirmPasswordChangedEvent event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      confirmPassword: event.password,
      isConfirmPasswordValid: _isConfirmPasswordValid(state.password, event.password),
    ));
  }

  _onFormSubmitted(FormSubmitted event, Emitter<FormsValidateState> emit) async {
    UserModel user = UserModel(
        name: state.name,
        email: state.email,
        password: state.password
      );

    if (event.value == Status.signUp) {
      await _signUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, user);
    }
  }

  _signUp(FormSubmitted event, Emitter<FormsValidateState> emit, UserModel user) async {
    emit(state.copyWith(
      errorMessage: "",
      isFormValid: 
        _isConfirmPasswordValid(state.password, state.confirmPassword) && 
        _isEmailValid(state.email) &&
        _isNameValid(state.name),
      isLoading: true));

    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authRepository.signUp(user);
        UserModel updatedUser = user.copyWith(
            id: authUser!.user!.uid, 
            isEmailVerified: authUser.user!.emailVerified
        );
        
        if (updatedUser.isEmailVerified!) {
          emit(state.copyWith(
            isLoading: false, 
            errorMessage: "" ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            isFormValid: false,
            isEmailSended: true,
            errorMessage: "Мы отправили письмо на вашу почту. Для подтверждения аккаунта перейдите по ссылке в письме.",
            )); }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, 
            errorMessage: e.message, 
            isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, 
          isFormValid: false, 
          isFormValidateFailed: true
        )
      );
    }
  }

  _authenticateUser(FormSubmitted event, Emitter<FormsValidateState> emit, UserModel user) async{
    emit(state.copyWith(
      errorMessage: "",
      isFormValid: _isPasswordValid(state.password) && _isEmailValid(state.email),
      isLoading: true
    ));

    if(state.isFormValid){
      try{
        UserCredential? authUser = await _authRepository.signIn(user);
        UserModel updatedUser = user.copyWith(
          id: authUser!.user!.uid,
          isEmailVerified: authUser.user!.emailVerified
        );

        if (updatedUser.isEmailVerified!) {
          emit(state.copyWith(
            isLoading: false, 
            errorMessage: ""));
        } else {
          emit(state.copyWith(
            isLoading: false,
            isFormValid: false,
            isEmailSended: true,
            errorMessage: "Мы отправили письмо на вашу почту. Для подтверждения аккаунта перейдите по ссылке в письме."));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
          isLoading: false, 
          errorMessage: e.message, 
          isFormValid: false));
      }
      } else {
        emit(state.copyWith(
          isLoading: false, 
          isFormValid: false, 
          isFormValidateFailed: true));
    }
  }
  
  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidateState> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}