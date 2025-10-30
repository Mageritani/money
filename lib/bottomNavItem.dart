import 'package:flutter/material.dart';

class BottomNavItem extends StatefulWidget {
  const BottomNavItem({super.key});

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
      SafeArea(
        child: Container(
          height: 56,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(24)),
        ),
      ),
    );
  }
}
