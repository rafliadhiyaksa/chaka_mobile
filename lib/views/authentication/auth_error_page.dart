import 'package:flutter/material.dart';

class AuthErrorPage extends StatelessWidget {
  AuthErrorPage(AsyncSnapshot<Object?> snapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error:'),
      ),
    );
  }
}
