import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/googleSignIn.dart';

import 'home.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({super.key});

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try{
        await SignInWithGoogle();
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Home()),
          );
        }
      } catch (e) {
      print("登入失敗: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("登入失敗，請再試一次 QQ")),
      );
    }
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white,width: 1)
        ),
        child: Image.asset("assets/google.png",width: 60,height: 60,),
      ),
    );
  }
}
