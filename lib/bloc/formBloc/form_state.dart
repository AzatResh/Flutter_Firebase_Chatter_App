part of 'form_bloc.dart';

class FormsValidateState extends Equatable {
  const FormsValidateState(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.isEmailValid,
      required this.isNameValid,
      required this.isPasswordValid,
      required this.isConfirmPasswordValid,
      required this.isFormValid,
      required this.isEmailSended,
      required this.isLoading,
      this.errorMessage = "",
      required this.isFormValidateFailed,
      this.isFormSuccessful = false});

  final String id;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isEmailValid;
  final bool isNameValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isFormValid;
  final bool isFormValidateFailed;
  final bool isEmailSended;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  FormsValidateState copyWith(
      {String? email,
      String? id,
      String? name,
      String? password,
      String? confirmPassword,
      bool? isEmailValid,
      bool? isNameValid,
      bool? isPasswordValid,
      bool? isConfirmPasswordValid,
      bool? isFormValid,
      bool? isLoading,
      String? errorMessage,
      bool? isFormValidateFailed,
      bool? isEmailSended,
      bool? isFormSuccessful}) {
    return FormsValidateState(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isNameValid: isNameValid ?? this.isNameValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isEmailSended: isEmailSended ?? this.isEmailSended,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        confirmPassword,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isLoading,
        errorMessage,
        isFormValidateFailed,
        isFormSuccessful
      ];
}