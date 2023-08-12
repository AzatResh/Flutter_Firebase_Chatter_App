// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatter/components/myButton.dart';
import 'package:flutter_chatter/components/myTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    if(passwordController.text != confirmPasswordController.text && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пароли не одинаковы'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        )
      );
      return;
    }
    try{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text
      );

      _fireStore.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': emailController.text
      });

      if(mounted){
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
                    "Let's create an account!",
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
                    hintText: 'Password', 
                    obscureText: true),
                  SizedBox(height: 10,),

                  // confirm password
                  MyTextField(
                    textController: confirmPasswordController, 
                    hintText: 'Confirm password', 
                    obscureText: true),
                  SizedBox(height: 15,),

                  // sign button
                  MyButton(
                    ontap: signUp,  
                    text: 'Register'),
                  SizedBox(height: 40,),

                  // текст регистрации
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Already a member?'),
                      SizedBox(width: 5,),
                      GestureDetector(
                        child: Text("Login now",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
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
}