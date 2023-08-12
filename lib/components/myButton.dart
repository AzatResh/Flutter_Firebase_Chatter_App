import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final String text;
  final void Function()? ontap;

  const MyButton({ Key? key , required this.ontap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          ),
        ) 
      ),
    );
  }
}