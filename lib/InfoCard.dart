import 'package:flutter/material.dart';

class infoCard extends StatefulWidget {
  final String name;
  final IconData icon;
  infoCard({super.key,required this.name, required this.icon});

  @override
  State<infoCard> createState() => _infoCardState();
}

class _infoCardState extends State<infoCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle
              ),
              child: Icon(widget.icon),
            ),
            Text(widget.name,style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}