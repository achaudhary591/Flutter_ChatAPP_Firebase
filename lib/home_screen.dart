import 'package:chat_app_firebase/methods.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: TextButton(
        onPressed: () => logOut(context),
        child: Text('LogOut'),
      ),
    );
  }
}
