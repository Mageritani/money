import 'package:flutter/material.dart';

class FaceBookSignIn extends StatefulWidget {
  const FaceBookSignIn({super.key});

  @override
  State<FaceBookSignIn> createState() => _FaceBookSignInState();
}

class _FaceBookSignInState extends State<FaceBookSignIn> {
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
        child: Image.asset("assets/facebook.png",width: 60,height: 60,),
      ),
    );
  }
}
