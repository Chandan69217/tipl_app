import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/features/auth/sign_in_screen.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import 'package:tipl_app/features/change_password/change_password.dart';
import 'package:tipl_app/features/navigations/admin/manage_banks/bank_details_list_screen.dart';
import 'package:tipl_app/features/navigations/genealogy/genealogy_screen.dart';
import 'package:tipl_app/features/navigations/meetings/meeting_screen.dart';
import 'package:tipl_app/features/navigations/user/user_profile_screen.dart';




class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 👤 Account Section
        const Text(
          "Account",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _buildTile(
          icon: Iconsax.user,
          iconColor: Colors.blue,
          title: "View Profile",
          subtitle: "Update name, dob, address",
          onTap: () {
            navigateWithAnimation(context, UserProfileScreen(canPop: true,));
          },
        ),
        _buildTile(
          icon: Iconsax.lock,
          iconColor: Colors.orange,
          title: "Change Password",
          subtitle: "Update login security",
          onTap: () {
            showChangePasswordBottomSheet(context);
          },
        ),
        // SwitchListTile(
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        //   secondary: const Icon(Icons.security, color: Colors.purple),
        //   title: const Text("Two-Factor Authentication"),
        //   subtitle: const Text("Enable extra security"),
        //   value: true,
        //   onChanged: (v) {},
        // ),

        const Divider(height: 32),

        // ⚙️ Application Section
        const Text(
          "Application",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // _buildTile(
        //   icon: Iconsax.notification,
        //   iconColor: Colors.red,
        //   title: "Notifications",
        //   subtitle: "Manage push & email alerts",
        //   onTap: () {},
        // ),
        // _buildTile(
        //   icon: Icons.color_lens,
        //   iconColor: Colors.teal,
        //   title: "Theme",
        //   subtitle: "Light / Dark mode",
        //   onTap: () {},
        // ),

        _buildTile(
          icon: Iconsax.bank,
          iconColor: Colors.teal,
          title: "All Banks",
          subtitle: "manage user banks",
          onTap: () {
            navigateWithAnimation(context, BankDetailsListScreen());
          },
        ),

        _buildTile(
          icon: Iconsax.user_add,
          iconColor: Colors.green,
          title: "New User Registration",
          subtitle: "Register a new member",
          onTap: () {
            navigateWithAnimation(context, SignUpScreen(canPop: true,));
          },
        ),
        _buildTile(
          icon: Iconsax.people,
          iconColor: Colors.green,
          title: "Meetings",
          subtitle: "Manage & schedule meeting",
          onTap: () {
            navigateWithAnimation(context, MeetingListScreen(canPop: true,));
          },
        ),
        _buildTile(
          icon: Iconsax.hierarchy,
          iconColor: Colors.indigo,
          title: "Genealogy",
          subtitle: "View user genealogy tree",
          onTap: () {
            navigateWithAnimation(context, GenealogyScreen(canPop: true,));
          },
        ),

        const Divider(height: 32),

        // 🖥️ System Section
        const Text(
          "System",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // _buildTile(
        //   icon: Icons.update,
        //   iconColor: Colors.deepOrange,
        //   title: "Check for Updates",
        //   onTap: () {},
        // )

        _buildTile(
          icon: Iconsax.information,
          iconColor: Colors.brown,
          title: "Terms & Policies",
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Iconsax.logout, color: Colors.red),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            Pref.Logout();
            navigatePushAndRemoveUntilWithAnimation(context, SignInScreen());
          },
        ),
      ],
    );
  }

  /// 🔹 Reusable ListTile builder with colored icons
  Widget _buildTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}


