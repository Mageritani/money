import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Stack(
      children: [
        Column(
          children: [
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
                SizedBox(width: 20),
                Spacer(),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 30,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "剩餘總額",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "NT\$ 1,000,000",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // 快速操作按鈕
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickAction(
                        context,
                        Icons.add_circle_outline,
                        "新增",
                        Colors.green,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.remove_circle_outline,
                        "支出",
                        Colors.red,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.analytics_outlined,
                        "統計",
                        Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
