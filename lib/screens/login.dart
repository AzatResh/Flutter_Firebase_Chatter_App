// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatter/components/myButton.dart';
import 'package:flutter_chatter/components/myTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signIn() async {
    try{
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );
      _fireStore.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': emailController.text
      }, SetOptions(merge: true));

      if(user != null && mounted){
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
    catch(error){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 120,),
                  // лого
                  Icon(
                    Icons.message,
                    size: 110,
                    color: Colors.grey[800],
                  ),
                  SizedBox(height: 50,),
                  Text(
                    "Welcome back, We've been waiting you.",
                    style: TextStyle(fontSize:  16),),
                  SizedBox(height: 20,),
                    
                  // email textfield
                  MyTextField(
                    textController: emailController, 
                    hintText: 'Email', 
                    obscureText: false),
                  SizedBox(height: 10,),

                  // password textfield
                  MyTextField(
                    textController: passwordController, 
                    hintText: 'Your password', 
                    obscureText: true),
                  SizedBox(height: 15,),

                  // sign button
                  MyButton(
                    ontap: signIn, 
                    text: 'Sigh in'),
                  SizedBox(height: 40,),

                  // текст регистрации
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Not a member?'),
                      SizedBox(width: 5,),
                      GestureDetector(
                        child: Text("Register now",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                      )
                    ],
                  )
                ],
              )
            ),
          )
        )
      )
    );
  }

  void showsnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}