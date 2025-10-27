import 'package:flutter/material.dart';

import 'InfoCard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Icon(Icons.menu,color: Colors.white,),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Text("Hi ! ",style: TextStyle(color: Colors.white),),
                  Spacer(),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10)
                      ),
                       child: Icon(Icons.settings,color: Colors.white,),
                    ),
                  ),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
