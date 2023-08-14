part of 'form_bloc.dart';
enum Status { signIn, signUp }

abstract class FormEvent extends Equatable {}

class FormInitEVent extends FormEvent {

  @override
  List<Object> get props => [];
}

class FormEmailChangedEVent extends FormEvent {
  final String email;
  FormEmailChangedEVent(this.email);

  @override
  List<Object> get props => [email];
}

class FormNameChangedEVent extends FormEvent {
  final String name;
  FormNameChangedEVent(this.name);

  @override
  List<Object> get props => [name];
}

class FormPasswordChangedEvent extends FormEvent {
  final String password;
  FormPasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class FormConfirmPasswordChangedEvent extends FormEvent {
  final String password;
  FormConfirmPasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class FormSubmitted extends FormEvent {
  final Status value;
  FormSubmitted({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSucceeded extends FormEvent {
  FormSucceeded();

  @override
  List<Object> get props => [];
}