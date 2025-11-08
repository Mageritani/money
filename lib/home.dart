import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/bottomNavItem.dart';
import 'package:money/cardList.dart';
import 'package:money/dashboard.dart'; // ✅ 新增
import 'package:money/history.dart';
import 'package:money/settingPage.dart';

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
    _pages = [
      Dashboard(), // ✅ 主頁面
      Cardlist(), // 卡片列表
      History(), // 歷史記錄
      Setting(), // 設定
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(child: _pages[_selectIndex]),
              SizedBox(height: 16),
              BottomNavItem(
                selectedIndex: _selectIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
