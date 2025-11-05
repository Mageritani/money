import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/bottomNavItem.dart';
import 'package:money/cardList.dart';
import 'package:money/history.dart';
import 'package:money/settingPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User = FirebaseAuth.instance.currentUser;
  int _selectIndex = 0;

  final List<Widget> _pages = [Home(), Cardlist(), History(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Hi !  ${User?.displayName ?? "User"}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => Setting()),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 200,
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Text(
                      "剩餘總額：",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "1,000,000",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                // 改用 Expanded
                child: _pages[_selectIndex],
              ),
              SizedBox(height: 16), // 給底部導航留空間
              BottomNavItem(
                selectedIndex: _selectIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectIndex = index;
                  });
                },
              ), // 現在會顯示了
            ],
          ),
        ),
      ),
    );
  }
}
