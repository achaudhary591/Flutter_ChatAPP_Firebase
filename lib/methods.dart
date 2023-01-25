import 'package:chat_app_firebase/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async{

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  try{

    User? user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;

    if(user != null){
      print('Account created Successfully');

      await _firebaseFirestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name" : name,
        "email" : email,
        "status" : "Unavailable"
      });
      return user;
    }
    else{
      print('Account creation Failed');
      return user;
    }
  }catch(e){
    print(e);
    return null;
  }

}

Future<User?> logIn(String email, String password) async{

  FirebaseAuth _auth = FirebaseAuth.instance;

  try{
    User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;

    if(user != null){
      print('Login Successfully');
      return user;
    }
    else{
      print('Login Failed');
      return user;
    }
  }catch(e){
    print(e);
    return null;
  }
}

Future<User?> logOut(BuildContext context) async {

  FirebaseAuth _auth = FirebaseAuth.instance;

  try{
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }catch(e){
    print(e);
  }
}