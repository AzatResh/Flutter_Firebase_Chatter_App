import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/bloc/formBloc/form_bloc.dart';

class PasswordTextField extends StatefulWidget {

  final bool isConfirmField;

  const PasswordTextField({ Key? key, required this.isConfirmField }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context){
    return BlocBuilder<FormBloc, FormsValidateState>(
      builder:(context, state) {
        return(
          TextField(
            obscureText: !_passwordVisible,
            onChanged: (text) {
              !widget.isConfirmField
                ? context.read<FormBloc>().add(FormPasswordChangedEvent(text))
                : context.read<FormBloc>().add(FormConfirmPasswordChangedEvent(text));
              },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),          
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),          
              ),
              hintText: !widget.isConfirmField
                ? 'Password':
                'Confirm password',
              errorText: !widget.isConfirmField
                ? !state.isPasswordValid
                  ? 'Пароль должен содержать минимум 8 символов с буквами и цифрами'
                  : null
                : !state.isConfirmPasswordValid
                  ? 'Пароли не совпадают'
                  : null,
              errorMaxLines: 2,
              fillColor: Colors.grey[200],
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            ),
          )
        );
      },
    );
  }
}