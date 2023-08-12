import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final TextEditingController textController;
  final String hintText;
  final bool obscureText;

  const MyTextField({ Key? key, 
    required this.textController, 
    required this.hintText, 
    required this.obscureText }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: textController,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200),          
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),          
        ),
        fillColor: Colors.grey[200],
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey)
      ),
    );
  }
}