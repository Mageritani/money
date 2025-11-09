import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money/bottomNavItem.dart';
import 'package:money/cardList.dart';
import 'package:money/dashboard.dart';
import 'package:money/history.dart';
import 'package:money/add.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [Dashboard(), Add(), Cardlist(), History()];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false, // 不為底部添加安全區域，讓導航欄可以貼底
        child: Stack(
          children: [
            // 主內容區域
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: IndexedStack(index: _selectIndex, children: _pages),
            ),

            // 懸浮的底部導航欄
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: BottomNavItem(
                selectedIndex: _selectIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
