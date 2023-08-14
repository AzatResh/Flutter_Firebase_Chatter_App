
import 'package:flutter/material.dart';
import 'package:flutter_chatter/screens/login.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String? errorMessage;
  final bool navigateToLogin;
  
  const ErrorDialog({Key? key, required this.title, required this.errorMessage, required this.navigateToLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => navigateToLogin
              ? Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false)
              : Navigator.of(context).pop(),
        )
      ],
    );
  }
}