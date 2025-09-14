import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/auth/forget_screen.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import 'package:tipl_app/features/dashboard/admin/admin_dashboard_screen.dart';
import 'package:tipl_app/features/dashboard/users/user_dashboard_screen.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRemember = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: CustColors.white,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(color: CustColors.background1,gradient: CustColors.darkGradient),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Center(
                            //   child:Image.asset('assets/logo/logo.webp') ,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/logo/only_logo.webp'),
                                Column(
                                  children: [
                                    Text(
                                      'TRSKGALAXY',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            color: CustColors.white,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1.0,
                                          ),
                                    ),
                                    Text(
                                      'INFRASTRUCTURE PVT. TLD.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: CustColors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Text(
                              "Sign in to your\nAccount",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: CustColors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = (){
                                      navigateWithAnimation(context, SignUpScreen());
                                    }
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: Column(
                          children: [
                            CustomTextField(
                              isRequired: true,
                              prefixIcon: Icon(Iconsax.personalcard),
                              label: "Associate ID",
                              controller: _emailController,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              isRequired: true,
                              prefixIcon: Icon(Iconsax.password_check),
                              label: "Password",
                              controller: _passwordController,
                              obscureText: obscurePassword,
                            ),
                            const SizedBox(height: 16),

                            // Remember + Forgot
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isRemember,
                                      onChanged: (v) {
                                        if (mounted) {
                                          setState(() {
                                            _isRemember = !_isRemember;
                                          });
                                        }
                                      },
                                    ),
                                    const Text(
                                      "Remember me",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    navigateWithAnimation(context,ForgetScreen());
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: WidgetStatePropertyAll(
                                      CustColors.blue,
                                    ),
                                  ),
                                  child: const Text("Forgot Password?"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Login Button
                          CustomButton(
                            iconData: Iconsax.login,
                            text: "Sign In", onPressed:_onSignIn,
                          ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 12, 40, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(
                                text: 'By signing up, you agree to the ',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle Terms of Service tap
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Data Processing Agreement',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle DPA tap
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }


  void _onSignIn() async{
    if(!(_formKey.currentState?.validate()??false)){
      return null;
    }

    final userId = _emailController.text;
    if(userId == 'admin'){
      navigatePushReplacementWithAnimation(context, AdminDashboardScreen());
      return;
    }
    navigatePushReplacementWithAnimation(context, UserDashboardScreen());
  }

}
