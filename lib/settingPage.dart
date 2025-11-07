import 'package:flutter/material.dart';
import 'package:money/googleSignIn.dart';
import 'package:money/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    // ✅ 直接返回內容，不要用 Scaffold
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Setting",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => GoogleSignOut(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 30,
                      color: Theme.of(context).colorScheme.onSurface, // ✅ 加上顏色
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ 加上內邊距
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Theme Change",
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}