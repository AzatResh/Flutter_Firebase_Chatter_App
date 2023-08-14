import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatter/bloc/authentication_bloc/auth_bloc.dart';
import 'package:flutter_chatter/bloc/formBloc/form_bloc.dart';
import 'package:flutter_chatter/repository/auth_repository.dart';
import 'package:flutter_chatter/screens/app.dart';
import 'package:flutter_chatter/screens/chat.dart';
import 'package:flutter_chatter/screens/home.dart';
import 'package:flutter_chatter/screens/login.dart';
import 'package:flutter_chatter/screens/register.dart';
import 'package:flutter_chatter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:(context) => AuthBloc(AuthRepository())..add(AuthStartedEvent()),),
        BlocProvider(
          create:(context) => FormBloc(AuthRepository()),)
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/app',
        routes: {
          '/app':(context) => const App(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home':(context) => const HomePage(),
        },
      )
    ); 
  }
}
