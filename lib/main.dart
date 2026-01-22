import 'package:flutter/material.dart';
import 'package:shopgiaydep_flutter/Provider/auth_provider.dart';
import 'package:shopgiaydep_flutter/Provider/danhmucsanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/dathang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/diachi_provider.dart';
import 'package:shopgiaydep_flutter/Provider/chitietsanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/danhgiasanpham_provider.dart';
import 'package:shopgiaydep_flutter/Provider/favorite_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giamgia_provider.dart';
import 'package:shopgiaydep_flutter/Provider/giohang_provider.dart';
import 'package:shopgiaydep_flutter/Provider/home_provider.dart';
import 'package:shopgiaydep_flutter/Provider/phuongthucthanhtoan_provider.dart';
import 'package:provider/provider.dart';
import 'package:shopgiaydep_flutter/Screen/trangchu_screen.dart';
import 'package:shopgiaydep_flutter/Screen/doimatkhau_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  // try {
  //   await authProvider.loadSaveAuth();
  // } catch (e) {
  //   print("Lỗi khi load auth: $e");
  // }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ChiTietSanPhamProvider()),
        ChangeNotifierProvider(create: (_) => DanhGiaProvider()),
        ChangeNotifierProvider(create: (_) => GioHangProvider()),
        ChangeNotifierProvider(create: (_) => DiachiProvider()),
        ChangeNotifierProvider(create: (_) => GiamgiaProvider()),
        ChangeNotifierProvider(create: (_) => PhuongThucThanhToanProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => DanhMucProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA3FCBC), 
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.asset(
                'assets/images/image.png', 
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Shop Giày Dép',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}