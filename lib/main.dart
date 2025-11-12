import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money/home.dart';
import 'package:money/login.dart';
import 'package:money/model/transaction_provider.dart';
import 'package:money/theme/theme_provider.dart'; // 新增
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // 使用 MultiProvider 管理多個 Provider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: InitializationWrapper(),
    );
  }
}

// 初始化包裝器
class InitializationWrapper extends StatefulWidget {
  InitializationWrapper({super.key});

  @override
  State<InitializationWrapper> createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  // 非同步初始化 Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Firebase 初始化失敗: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 顯示錯誤
    if (_hasError) {
      return const Scaffold(
        body: Center(
          child: Text('Firebase 初始化失敗\n請重新啟動應用', textAlign: TextAlign.center),
        ),
      );
    }

    // 等待初始化
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    // 初始化完成，顯示啟動畫面
    return SplashScreen();
  }
}

// 啟動畫面
class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    // 啟動畫面顯示 2 秒後載入資料並導航
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _loadDataAndNavigate();
    });
  }

  // 載入交易資料後再導航
  Future<void> _loadDataAndNavigate() async {
    // 先載入交易資料
    await context.read<TransactionProvider>().loadTransactions();

    if (!mounted) return;

    // 檢查使用者登入狀態
    final user = FirebaseAuth.instance.currentUser;
    Widget destination = user != null ? Home() : Login();

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => destination));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/mm.png", width: 200, height: 200),
              const SizedBox(height: 16),
              const Text(
                "Let's save your money",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
