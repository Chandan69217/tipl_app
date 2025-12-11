import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';
import 'package:tipl_app/features/change_password/change_password.dart';
import 'package:tipl_app/features/navigation/genealogy/genealogy_screen.dart';
import 'package:tipl_app/features/navigation/meetings/meeting_screen.dart';
import 'package:tipl_app/features/navigation/user/id_card.dart';
import 'package:tipl_app/features/navigation/user/update_profile/update_profile.dart';
import 'package:tipl_app/features/navigation/user/user_home_screen.dart';
import 'package:tipl_app/features/navigation/user/user_profile_screen.dart';
import 'package:tipl_app/features/navigation/user/wallets/wallet_screen.dart';
import 'package:tipl_app/features/notification_screen.dart';



class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  int _notificationCount = 3;
  int _bottomNavIndex = 0;
  final List<Widget> _screens = [UserHomeScreen(),WalletScreen(),MeetingListScreen(),GenealogyScreen(),UserProfileScreen(),];
  bool _isUpdateProfileOpened = false;

  @override
  void initState() {
    super.initState();
    checkProfileCompleted();
  }

  void checkProfileCompleted() async{
    if (!await ProfileAPIService(context: context).isProfileCompleted() && ! ConnectivityService().isConnected.value) {
    UpdateProfile.show(context);
    _isUpdateProfileOpened = true;
    }
    ConnectivityService().isConnected.addListener(() async {
      if (!ConnectivityService().isConnected.value) {
        if (!await ProfileAPIService(context: context).isProfileCompleted() && !_isUpdateProfileOpened) {
          UpdateProfile.show(context);
          _isUpdateProfileOpened = true;
        }
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
        final icons = [Iconsax.home, Iconsax.wallet,Iconsax.people,Iconsax.hierarchy,Iconsax.user];
        final labels = ["Home", "Wallet",'Meetings','Genealogy','Profile'];

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

  AppBar  _appBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.dark
      ),
      elevation: 0,
      title: Consumer<UserProfileProvider>(
        builder: (context,value,child) {
          final data  = value.data;
          return Row(
            children: [
              GestureDetector(
                onTap: (){
                  navigateWithAnimation(context, UserProfileScreen(canPop: true,));
                },
                child: CustomNetworkImage(
                  width: 36,
                  height: 36,
                  imageUrl: data.profile,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.fullName,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.black)),
                  Text(data.email,
                      style: TextStyle(fontSize: 12, color: Colors.black45,)),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 8.0),
        //   child: Stack(
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           if(mounted)
        //             setState(() {
        //               _notificationCount = 0;
        //               navigateWithAnimation(context, NotificationsScreen());
        //             });
        //         },
        //         icon: const Icon(Iconsax.notification_bing, size: 25,color: Colors.black,),
        //       ),
        //       if (_notificationCount > 0)
        //         Positioned(
        //           right: 8,
        //           top: 8,
        //           child: Container(
        //             padding: const EdgeInsets.all(4),
        //             decoration: const BoxDecoration(
        //               color: Colors.red,
        //               shape: BoxShape.circle,
        //             ),
        //             child: Text(
        //               '$_notificationCount',
        //               style: const TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 10,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ),
        //     ],
        //   ),
        // ),
        if (_bottomNavIndex == 4) ...[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_password') {
                showChangePasswordBottomSheet(context);
              }else if('view_card' == value){
                navigateWithAnimation(context, IdCardScreen());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'view_card',
                child: Text('View Card'),
              ),
              const PopupMenuItem(
                value: 'change_password',
                child: Text('Change Password'),
              ),
            ],
          ),
        ]
      ],
    );
  }

}




