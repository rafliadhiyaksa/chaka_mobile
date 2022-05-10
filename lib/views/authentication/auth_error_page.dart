import 'package:flutter/material.dart';

class AuthErrorPage extends StatelessWidget {
  const AuthErrorPage(AsyncSnapshot<Object?> snapshot, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Error:'),
      ),
    );
  }
}
