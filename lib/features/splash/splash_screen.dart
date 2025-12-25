import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/features/dashboard/admin/admin_dashboard_screen.dart';
import 'package:tipl_app/features/dashboard/users/user_dashboard_screen.dart';
import '../auth/sign_in_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 2), () {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       final isLogin = Pref.instance.getBool(PrefConst.IS_LOGIN)??false;
//       final isAdmin = UserRole.admin == UserType.role;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => isLogin ? isAdmin ? AdminDashboardScreen(): UserDashboardScreen(): const SignInScreen()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset('assets/logo/logo.webp')),
//     );
//   }
// }

import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _beatController;
  late Animation<double> _beat;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final String _text = "NEURAL FINANCE";
  String _visibleText = "";

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // ❤️ Heartbeat animation (thump → relax)
    _beatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _beat = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30),
    ]).animate(_beatController);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _startTyping();
  }

  Future<void> _startTyping() async {
    for (int i = 0; i <= _text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 110));
      if (!mounted) return;
      setState(() {
        _visibleText = _text.substring(0, i);
      });
    }
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _isLoading = true;
    });
    await RecallProvider(context: context).recallAll();
    setState(() {
      _isLoading = false;
    });
    _navigate();
  }

  void _navigate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    final isLogin = Pref.instance.getBool(PrefConst.IS_LOGIN) ?? false;
    final isAdmin = UserRole.admin == UserType.role;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: isLogin
                ? isAdmin
                      ? const AdminDashboardScreen()
                      : const UserDashboardScreen()
                : const SignInScreen(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _beatController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _beat,
          builder: (_, __) {
            final glowStrength = (_beat.value - 0.9) * 120;

            return Stack(
              alignment: Alignment.center,
              children: [
                // ❤️ Heartbeat Neural Circle
                Transform.scale(
                  scale: _beat.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFD4AF37,
                          ).withValues(alpha: 0.20),
                          blurRadius: 40 + glowStrength,
                          spreadRadius: 20 + glowStrength / 3,
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔤 Brand Text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          'assets/logo/only_logo.webp',
                          width: 80,
                        ),
                      ),
                    ),

                    // ShaderMask(
                    //           shaderCallback: (bounds) {
                    //             return const LinearGradient(
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight,
                    //               colors: [
                    //                 Color(0xFFE6D8A3),
                    //                 Color(0xFFB59A30),
                    //                 Color(0xFF7A5C12),
                    //                 Color(0xFFD4AF37),
                    //               ],
                    //               stops: [0.0, 0.45, 0.8, 1.0],
                    //             ).createShader(bounds);
                    //           },
                    //           child: Text(
                    //             _visibleText,
                    //             style: GoogleFonts.creepster(
                    //               fontSize: 42,
                    //               fontWeight: FontWeight.w800,
                    //               letterSpacing: 3,
                    //               color: Colors.white, // IMPORTANT for ShaderMask
                    //             ),
                    //           ),
                    //         ),
                    Text(
                      _visibleText,
                      style: GoogleFonts.creepster(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3,
                        color: const Color(0xFFD4AF37),
                      ),
                    ),

                    Text(
                      "MICRO MINI FINANCE",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.75),
                      ),
                    ),

                    if (_isLoading)...[
                      const SizedBox(height: 6,),
                      CustomCircularIndicator(
                        colors: [
                          Color(0xFFE6D8A3),
                          Color(0xFFB59A30),
                          Color(0xFF7A5C12),
                          Color(0xFFD4AF37),
                        ],
                      ),
                    ]

                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
