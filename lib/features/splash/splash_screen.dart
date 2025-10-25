import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/features/dashboard/admin/admin_dashboard_screen.dart';
import 'package:tipl_app/features/dashboard/users/user_dashboard_screen.dart';
import '../auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      final isLogin = Pref.instance.getBool(PrefConst.IS_LOGIN)??false;
      final sponsor_id = Pref.instance.getString(PrefConst.SPONSOR_ID);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => isLogin ? sponsor_id == null ? AdminDashboardScreen(): UserDashboardScreen(): const SignInScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo/logo.webp')),
    );
  }
}
