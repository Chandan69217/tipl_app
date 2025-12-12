import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_transactions_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';
import 'package:tipl_app/features/auth/sign_in_screen.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import 'package:tipl_app/features/navigation/admin/admin_home_screen.dart';
import 'package:tipl_app/features/navigation/admin/admin_wallet_screen.dart';
import 'package:tipl_app/features/navigation/admin/manage_transaction/manage_transaction_screen.dart';
import 'package:tipl_app/features/navigation/admin/manage_users/manage_user_screen.dart';
import 'package:tipl_app/features/navigation/admin/reports_screen.dart';
import 'package:tipl_app/features/navigation/admin/settings_screen.dart';
import 'package:tipl_app/features/navigation/user/user_profile_screen.dart';
import 'package:tipl_app/features/notification_screen.dart';



class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _bottomNavIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _init();
    _screens = [
      AdminHomeScreen(onUpdate: (index){
        WidgetsBinding.instance.addPostFrameCallback((duration){
          setState(() {
            _bottomNavIndex = index;
          });
        });
      },),
      AllUserTransactionsScreen(),
      ManageUsersScreen(),
      ReportsScreen(),
      SettingsScreen()
    ];
  }



  void _init() async {
    final transactions = Provider.of<AllTransactionsProvider>(
      context,
      listen: false,
    ).allTransactions;

    if (transactions.isNotEmpty) {
      // Check if ANY transaction is pending
      final hasPending = transactions.any(
            (t) => t.confirmation.toLowerCase() == 'pending',
      );

      if (hasPending) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomMessageDialog.show(
            context,
            title: 'Attention',
            cancelText: 'Cancel',
            onCancel: (){},
            message: 'You have pending transactions awaiting verification. '
                'Please review and confirm them as soon as possible.',
            confirmText: 'Review',
            onConfirm: () {
              WidgetsBinding.instance.addPostFrameCallback((duration){
                setState(() {
                  _bottomNavIndex = 1;
                });
              });
            },
          );
        });
      }
    }
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
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {

    return AnimatedBottomNavigationBar.builder(
        itemCount: 5,
        elevation: 0,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        backgroundColor: CustColors.white,
        splashColor: CustColors.majorelleBlue.withValues(alpha: 0.2),
        blurEffect: true,
        tabBuilder: (index,isActive){
          final icons = [
            Iconsax.home,
            Iconsax.
            briefcase,
            Iconsax.user_edit,
            Iconsax.graph,
            Iconsax.setting
          ];
          final labels = [
            "Home",
            'Transactions',
            "Users",
            "Reports",
            "More"
          ];
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
        activeIndex: _bottomNavIndex,
        onTap: (index){
          if(!mounted) return;
          Haptics.canVibrate().then((canVibrate){
            if(canVibrate){
              Haptics.vibrate(HapticsType.selection);
            }
          });
          setState(() => _bottomNavIndex = index);
        }
    );

  }

  AppBar _appBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: CustColors.white,
      elevation: 0,
      title: Consumer<UserProfileProvider>(
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  navigateWithAnimation(context, UserProfileScreen(canPop: true,));
                },
                child: CustomNetworkImage(
                  width: 36,
                  height: 36,
                  imageUrl: value.data.profile,
                ),
              ),
              // CircleAvatar(
              //   radius: 22,
              //   backgroundColor: Colors.blue.shade50,
              //   child: Icon(Iconsax.shield_tick, color: Colors.blue, size: 26),
              // ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text('${value.data.fullName} (Admin)',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  Text(value.data.email,
                      style: TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        // IconButton(
        //     icon: const Icon(Iconsax.notification,color: Colors.black,),
        //     onPressed: () {
        //       navigateWithAnimation(context, NotificationsScreen());
        //     }
        // ),
        // IconButton(
        //   icon: const Icon(Iconsax.logout, color: Colors.redAccent),
        //   onPressed: () {
        //     Pref.Logout();
        //     navigatePushAndRemoveUntilWithAnimation(context, SignInScreen());
        //   },
        // ),
        SizedBox(width: 20.0,),
      ],
    );
  }

}
