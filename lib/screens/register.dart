// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/bloc/authentication_bloc/auth_bloc.dart';
import 'package:flutter_chatter/bloc/formBloc/form_bloc.dart';
import 'package:flutter_chatter/components/errorDialog.dart';
import 'package:flutter_chatter/components/myButton.dart';
import 'package:flutter_chatter/components/textFields/PasswordTextField.dart';
import 'package:flutter_chatter/components/textFields/emailTextField.dart';
import 'package:flutter_chatter/components/textFields/nameTextField.dart';
import 'package:flutter_chatter/screens/home.dart';
import 'package:flutter_chatter/screens/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<FormBloc, FormsValidateState>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                if(state.isEmailSended){
                  showDialog(
                    context: context,
                    builder: (context) =>
                      ErrorDialog(title: "Проверьте email", errorMessage: state.errorMessage, navigateToLogin: true,));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) =>
                      ErrorDialog(title: "Ошибка", errorMessage: state.errorMessage, navigateToLogin: false,));
                }
              } else if (state.isFormValid && !state.isLoading) {
                context.read<AuthBloc>().add(AuthStartedEvent());
                context.read<FormBloc>().add(FormSucceeded());
              } else if (state.isFormValidateFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Исправьте все ошибки в полях!'), backgroundColor: Colors.red,));
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false);
              }
            },
          ),
        ],
      child: Scaffold(
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 80,),
                    // лого
                    Icon(
                      Icons.message,
                      size: 110,
                      color: Colors.grey[800],
                    ),
                    SizedBox(height: 50,),
                    Text(
                      "Let's create an account!",
                      style: TextStyle(fontSize:  16),),
                    SizedBox(height: 20,),
                      
                    // name textfield
                    NameTextField(),
                    SizedBox(height: 10,),

                    // email textfield
                    EmailTextField(),
                    SizedBox(height: 10,),

                    // password textfield
                    PasswordTextField(isConfirmField: false),
                    SizedBox(height: 10,),

                    // confirm password
                    PasswordTextField(isConfirmField: true),
                    SizedBox(height: 15,),

                    // sign button
                    BlocBuilder<FormBloc, FormsValidateState>(
                      builder: (context, state) {
                        return state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MyButton(
                          ontap: !state.isFormValid
                            ? () => context.read<FormBloc>().add(FormSubmitted(value: Status.signUp))
                            : null,
                          text: 'Register'
                        );
                      }
                    ),

                    // текст регистрации
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Already a member?'),
                        SizedBox(width: 5,),
                        BlocBuilder<FormBloc, FormsValidateState>(
                        builder: (context, state) {
                          return GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: 80,
                              color: Colors.transparent,
                              child: Text("Login now",
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                              onTap: () {
                                context.read<FormBloc>().add(FormInitEVent());
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                            );
                          }
                        )
                      ],
                    )
                  ],
                )
              ),
            )
          )
        )
      )
    );
  }
}