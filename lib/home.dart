import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money/bottomNavItem.dart';
import 'package:money/cardList.dart';
import 'package:money/dashboard.dart'; // ✅ 新增
import 'package:money/history.dart';
import 'package:money/settingPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
      const Dashboard(), // ✅ 主頁面
      const Cardlist(),  // 卡片列表
      const History(),   // 歷史記錄
      const Setting(),   // 設定
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
              // 頂部導航列
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 可以加入側邊選單功能
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
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
                    "Hi! ${user?.displayName ?? "User"}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectIndex = 3; // ✅ Setting 現在是索引 3
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
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
              SizedBox(height: 20),
              // 頁面內容
              Expanded(
                child: _pages[_selectIndex],
              ),
              SizedBox(height: 16),
              // 底部導航
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