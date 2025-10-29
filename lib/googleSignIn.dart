import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> SignInWithGoogle() async {
  final googleUser = await GoogleSignIn().signIn();
  if(googleUser == null ) throw Exception("使用者取消登入");

  final googleAuth = await googleUser.authentication;

  final googleCredential = GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
    accessToken: googleAuth.accessToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(googleCredential);

}