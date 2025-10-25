import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/features/navigations/genealogy_screen.dart';
import 'package:tipl_app/features/navigations/suggestion_screen.dart';
import 'package:tipl_app/features/navigations/user/update_profile/update_profile.dart';
import 'package:tipl_app/features/navigations/user/user_home_screen.dart';
import 'package:tipl_app/features/navigations/user/user_profile_screen.dart';
import 'package:tipl_app/features/navigations/wallet_screen.dart';
import 'package:tipl_app/features/notification_screen.dart';



class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _notificationCount = 3;
  int _bottomNavIndex = 0;
  final List<Widget> _screens = [UserHomeScreen(),WalletScreen(),GenealogyScreen(),UserProfileScreen(),SuggestionScreen()];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duraton)async{
      if(!await ProfileAPIService(context: context).isProfileCompleted()){
        UpdateProfile.show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: IndexedStack(
          index: _bottomNavIndex,
          children: _screens,
        ),
      ),

        bottomNavigationBar: _bottomNavigationBar()

    );
  }

  Widget _bottomNavigationBar(){
    return AnimatedBottomNavigationBar.builder(
      itemCount: 5,
      activeIndex: _bottomNavIndex,
      elevation: 0,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      backgroundColor: CustColors.white,
      splashColor: CustColors.majorelleBlue.withValues(alpha: 0.2),
      blurEffect: true,
      tabBuilder: (int index, bool isActive) {
        final icons = [Iconsax.home, Iconsax.wallet,Iconsax.hierarchy,Iconsax.user,Iconsax.message_question];
        final labels = ["Home", "Wallet",'Genealogy','Profile','Suggestion'];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index],
              color: isActive ? CustColors.majorelleBlue : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                color: isActive ? CustColors.majorelleBlue : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
      onTap: (index) async{
        // final canVibrate = await Haptics.canVibrate();
        // if(canVibrate){
        //   Haptics.vibrate(HapticsType.selection);
        // }
        if(!mounted) return;
        Haptics.canVibrate().then((canVibrate){
          if(canVibrate){
            Haptics.vibrate(HapticsType.selection);
          }
        });
        setState(() => _bottomNavIndex = index);
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark
      ),
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Iconsax.profile_circle,color: Colors.black,size: 28,),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Chandan Sharma",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
              Text("chandan@example.com",
                  style: TextStyle(fontSize: 12, color: Colors.black45,)),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {
                  if(mounted)
                    setState(() {
                      _notificationCount = 0;
                      navigateWithAnimation(context, NotificationsScreen());
                    });
                },
                icon: const Icon(Iconsax.notification_bing, size: 25,color: Colors.black,),
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

}




