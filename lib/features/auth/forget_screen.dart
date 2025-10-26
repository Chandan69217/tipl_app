import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';


class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _associateIdController = TextEditingController();
  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        body: Stack(
          children:[
            SingleChildScrollView(
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
                              SizedBox(height: 24),
                              Text(
                                "Forgot your\nPassword?",
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
                                label: "Member ID",
                                controller: _associateIdController,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                isRequired: true,
                                prefixIcon: Icon(Iconsax.directbox_send),
                                label: "Email",
                                controller: _emailController,
                              ),
                              const SizedBox(height: 32),

                              // Login Button
                              CustomButton(
                                  iconData: Iconsax.key,
                                  text: "Get Password", onPressed: _onGetPassword
                              ),
                              const SizedBox(height: 12),
                              TextButton(onPressed: (){
                                Navigator.of(context).popUntil((route)=>route.isFirst);
                              },
                                  style: TextButton.styleFrom(
                                    foregroundColor: CustColors.blue,

                                  ),
                                  child: Text('Login')
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
            Positioned(
              top: 0,
              left: 8,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _associateIdController.dispose();
    _emailController.dispose();
  }


  void _onGetPassword() async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }
  }

}
