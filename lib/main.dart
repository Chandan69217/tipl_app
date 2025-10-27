import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'features/splash/splash_screen.dart';
import 'core/theme/app_theme.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityService().initialize(scaffoldMessengerKey);
  await Pref.initialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<UserProfileProvider>(create: (_)=>UserProfileProvider(),lazy: false,),
      ChangeNotifierProvider<AllUserDetailsProvider>(create: (_)=>AllUserDetailsProvider(),lazy: false,)
    ],
    child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    RecallProvider(context: context);
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Sign In',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
