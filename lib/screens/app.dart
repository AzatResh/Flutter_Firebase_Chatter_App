import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/bloc/authentication_bloc/auth_bloc.dart';
import 'package:flutter_chatter/screens/home.dart';
import 'package:flutter_chatter/screens/login.dart';

class App extends StatelessWidget {
const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BlocNavigate();
  }
}

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BlocBuilder<AuthBloc, AuthState>(
      builder:(context, state) {
        if(state is AuthSuccessState){
          return const HomePage();
        }
        else{
          return const LoginPage();
        }
      },
    );
  }
}