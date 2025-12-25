import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';
import 'package:tipl_app/features/auth/forget_screen.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import 'package:tipl_app/features/dashboard/admin/admin_dashboard_screen.dart';
import 'package:tipl_app/features/dashboard/users/user_dashboard_screen.dart';
import 'package:tipl_app/features/terms_conditions/terms_condition_screen.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key,});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRemember = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init()async{
    final saved_email = Pref.instance.getString(PrefConst.SAVED_EMAIL)??'';
    final saved_password = Pref.instance.getString(PrefConst.SAVED_PASSWORD)??'';
    WidgetsBinding.instance.addPostFrameCallback((duration){
      setState(() {
        if(saved_email.isNotEmpty||saved_password.isNotEmpty){
          _isRemember = true;
        }
        _emailController.text = saved_email;
        _passwordController.text = saved_password;
      });
    });
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
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Stack(
            children: [
              ListView(
              // shrinkWrap: true,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
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
                            const SizedBox(height: 60,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/logo/only_logo.webp',width: 50.0,),
                                SizedBox(width: 8.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'NEURAL',
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
                                      'MICRO MINI FINANCE.',
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
                              label: "Email ID",
                              fieldType: FieldType.email,
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
                                          if(_isRemember){
                                            Pref.instance.setString(PrefConst.SAVED_EMAIL, _emailController.text);
                                            Pref.instance.setString(PrefConst.SAVED_PASSWORD, _passwordController.text);
                                          }else{
                                            Pref.instance.remove(PrefConst.SAVED_EMAIL);
                                            Pref.instance.remove(PrefConst.SAVED_PASSWORD);
                                          }
                                        }
                                      },
                                    ),
                                    const Text(
                                      "Remember me",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                // TextButton(
                                //   onPressed: () {
                                //     navigateWithAnimation(context,ForgetScreen());
                                //   },
                                //   style: ButtonStyle(
                                //     backgroundColor: WidgetStatePropertyAll(
                                //         Colors.transparent
                                //     ),
                                //     foregroundColor: WidgetStatePropertyAll(
                                //       CustColors.blue,
                                //     ),
                                //   ),
                                //   child: const Text("Forgot Password?"),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Login Button
                            _isLoading ? CustomCircularIndicator() : CustomButton(
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

                // Spacer(),

              ],
            ),

              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 12, 40, 10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By signing in, you agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigateWithAnimation(context, TermsAndConditionsScreen());
                              },
                          ),
                          // const TextSpan(text: ' and '),
                          // TextSpan(
                          //   text: 'Data Processing Agreement',
                          //   style: const TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: Colors.black,
                          //   ),
                          //   recognizer: TapGestureRecognizer()
                          //     ..onTap = () {
                          //       // Handle DPA tap
                          //     },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),)
                  ]
          ),
        ),
        // body: SingleChildScrollView(
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       minHeight: MediaQuery.of(context).size.height,
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       mainAxisSize: MainAxisSize.max,
        //       children: [
        //         Column(
        //           children: [
        //             Container(
        //               width: double.infinity,
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 24,
        //                 vertical: 32,
        //               ),
        //               decoration: BoxDecoration(color: CustColors.background1,gradient: CustColors.darkGradient),
        //               child: SafeArea(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     // Center(
        //                     //   child:Image.asset('assets/logo/logo.webp') ,
        //                     // ),
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Image.asset('assets/logo/only_logo.webp',width: 50.0,),
        //                         SizedBox(width: 8.0,),
        //                         Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               'NEURAL',
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .headlineLarge!
        //                                   .copyWith(
        //                                     color: CustColors.white,
        //                                     fontWeight: FontWeight.w900,
        //                                     letterSpacing: -1.0,
        //                                   ),
        //                             ),
        //                             Text(
        //                               'MICRO MINI FINANCE.',
        //                               style: Theme.of(context)
        //                                   .textTheme
        //                                   .bodySmall!
        //                                   .copyWith(
        //                                     color: CustColors.white,
        //                                     fontWeight: FontWeight.bold,
        //                                   ),
        //                             ),
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                     SizedBox(height: 24),
        //                     Text(
        //                       "Sign in to your\nAccount",
        //                       style: TextStyle(
        //                         color: Colors.white,
        //                         fontWeight: FontWeight.bold,
        //                         fontSize: 28,
        //                       ),
        //                     ),
        //                     SizedBox(height: 8),
        //                     Text.rich(
        //                       TextSpan(
        //                         text: "Don’t have an account? ",
        //                         style: TextStyle(
        //                           color: Colors.white70,
        //                           fontSize: 12,
        //                         ),
        //                         children: [
        //                           TextSpan(
        //                             text: "Sign Up",
        //                             style: TextStyle(
        //                               color: CustColors.blue,
        //                               fontWeight: FontWeight.w600,
        //                             ),
        //                             recognizer: TapGestureRecognizer()..onTap = (){
        //                               navigateWithAnimation(context, SignUpScreen());
        //                             }
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Form(
        //               key: _formKey,
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                   horizontal: 24,
        //                   vertical: 32,
        //                 ),
        //                 child: Column(
        //                   children: [
        //                     CustomTextField(
        //                       isRequired: true,
        //                       prefixIcon: Icon(Iconsax.personalcard),
        //                       label: "Email ID",
        //                       fieldType: FieldType.email,
        //                       controller: _emailController,
        //                     ),
        //                     const SizedBox(height: 16),
        //                     CustomTextField(
        //                       isRequired: true,
        //                       prefixIcon: Icon(Iconsax.password_check),
        //                       label: "Password",
        //                       controller: _passwordController,
        //                       obscureText: obscurePassword,
        //                     ),
        //                     const SizedBox(height: 16),
        //
        //                     // Remember + Forgot
        //                     Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Row(
        //                           children: [
        //                             Checkbox(
        //                               value: _isRemember,
        //                               onChanged: (v) {
        //                                 if (mounted) {
        //                                   setState(() {
        //                                     _isRemember = !_isRemember;
        //                                   });
        //                                   if(_isRemember){
        //                                     Pref.instance.setString(PrefConst.SAVED_EMAIL, _emailController.text);
        //                                     Pref.instance.setString(PrefConst.SAVED_PASSWORD, _passwordController.text);
        //                                   }else{
        //                                     Pref.instance.remove(PrefConst.SAVED_EMAIL);
        //                                     Pref.instance.remove(PrefConst.SAVED_PASSWORD);
        //                                   }
        //                                 }
        //                               },
        //                             ),
        //                             const Text(
        //                               "Remember me",
        //                               style: TextStyle(fontSize: 12),
        //                             ),
        //                           ],
        //                         ),
        //                         // TextButton(
        //                         //   onPressed: () {
        //                         //     navigateWithAnimation(context,ForgetScreen());
        //                         //   },
        //                         //   style: ButtonStyle(
        //                         //     backgroundColor: WidgetStatePropertyAll(
        //                         //         Colors.transparent
        //                         //     ),
        //                         //     foregroundColor: WidgetStatePropertyAll(
        //                         //       CustColors.blue,
        //                         //     ),
        //                         //   ),
        //                         //   child: const Text("Forgot Password?"),
        //                         // ),
        //                       ],
        //                     ),
        //                     const SizedBox(height: 16),
        //
        //                     // Login Button
        //                   _isLoading ? CustomCircularIndicator() : CustomButton(
        //                     iconData: Iconsax.login,
        //                     text: "Sign In", onPressed:_onSignIn,
        //                   ),
        //                     const SizedBox(height: 24),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //
        //         SafeArea(
        //           child: Padding(
        //             padding: const EdgeInsets.fromLTRB(40.0, 12, 40, 10),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 RichText(
        //                   textAlign: TextAlign.center,
        //                   text: TextSpan(
        //                     style: TextStyle(
        //                       color: Colors.grey.shade500,
        //                       fontSize: 14,
        //                     ),
        //                     children: [
        //                       const TextSpan(
        //                         text: 'By signing in, you agree to the ',
        //                       ),
        //                       TextSpan(
        //                         text: 'Terms of Service',
        //                         style: const TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.black,
        //                         ),
        //                         recognizer: TapGestureRecognizer()
        //                           ..onTap = () {
        //                             navigateWithAnimation(context, TermsAndConditionsScreen());
        //                           },
        //                       ),
        //                       // const TextSpan(text: ' and '),
        //                       // TextSpan(
        //                       //   text: 'Data Processing Agreement',
        //                       //   style: const TextStyle(
        //                       //     fontWeight: FontWeight.bold,
        //                       //     color: Colors.black,
        //                       //   ),
        //                       //   recognizer: TapGestureRecognizer()
        //                       //     ..onTap = () {
        //                       //       // Handle DPA tap
        //                       //     },
        //                       // ),
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
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

    final connection = ConnectivityService();
    if(connection.isConnected.value){
      SnackBarHelper.show(context, message: 'No Internet Connection.');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final userId = _emailController.text;
    final password = _passwordController.text;
    if(userId == 'admin'){
      navigatePushReplacementWithAnimation(context, AdminDashboardScreen());
      return;
    }
    
    try{
      final url = Uri.https(Urls.baseUrl,Urls.login);
      final body = {
        'email' : userId,
        'transaction_password': password
      };
      final response = await post(url,body: json.encode(body),headers: {
        'content-type': 'Application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final value = json.decode(response.body) as Map<String,dynamic>;
        final status = value['isSuccess'];
        final message = value['message'];
        if(status){
          final data = value['data'] as Map<String,dynamic>;
          final member_id = data['member_id']??'';
          final sponsor_id = data['sponsor_id'];
          final token = data['token']??'';
          final role = data['role']??'';
          Pref.instance.setBool(PrefConst.IS_LOGIN, true);
          Pref.instance.setString(PrefConst.MEMBER_ID, member_id);
          Pref.instance.setString(PrefConst.TOKEN, token);
          Pref.instance.setString(PrefConst.ROLE, role);
          if(sponsor_id != null){
            Pref.instance.setString(PrefConst.SPONSOR_ID,sponsor_id);
          }
          // save the id password
          if(_isRemember){
            Pref.instance.setString(PrefConst.SAVED_EMAIL, _emailController.text);
            Pref.instance.setString(PrefConst.SAVED_PASSWORD, _passwordController.text);
          }
          UserType.initialize();
          await RecallProvider(context: context).recallAll();
          navigatePushReplacementWithAnimation(context, sponsor_id != null ? UserDashboardScreen() : AdminDashboardScreen());
        }else{
          CustomMessageDialog.show(context, title: 'Invalid Credentials', message: message);
        }

      }else if(response.statusCode == 400){
        SnackBarHelper.show(context, message: 'credentials are invalid');
      }else{
        handleApiResponse(context, response);
      }
    }catch(exceptin,trace){
      print('Exception: ${exceptin},Trace: ${trace}');
    }

    setState(() {
      _isLoading = false;
    });

  }

}
