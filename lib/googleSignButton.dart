import 'package:flutter/material.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({super.key});

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
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
