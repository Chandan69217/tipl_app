import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

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
          icon: Icons.person,
          iconColor: Colors.blue,
          title: "Edit Profile",
          subtitle: "Update name, email, phone number",
          onTap: () {},
        ),
        _buildTile(
          icon: Icons.lock,
          iconColor: Colors.orange,
          title: "Change Password",
          subtitle: "Update login security",
          onTap: () {},
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          secondary: const Icon(Icons.security, color: Colors.purple),
          title: const Text("Two-Factor Authentication"),
          subtitle: const Text("Enable extra security"),
          value: true,
          onChanged: (v) {},
        ),

        const Divider(height: 32),

        // ⚙️ Application Section
        const Text(
          "Application",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _buildTile(
          icon: Icons.notifications,
          iconColor: Colors.red,
          title: "Notifications",
          subtitle: "Manage push & email alerts",
          onTap: () {},
        ),
        _buildTile(
          icon: Icons.color_lens,
          iconColor: Colors.teal,
          title: "Theme",
          subtitle: "Light / Dark mode",
          onTap: () {},
        ),
        _buildTile(
          icon: Icons.person_add,
          iconColor: Colors.green,
          title: "New User Registration",
          subtitle: "Register a new member",
          onTap: () {},
        ),
        _buildTile(
          icon: Icons.account_tree,
          iconColor: Colors.indigo,
          title: "Genealogy",
          subtitle: "View user genealogy tree",
          onTap: () {},
        ),

        const Divider(height: 32),

        // 🖥️ System Section
        const Text(
          "System",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        _buildTile(
          icon: Icons.update,
          iconColor: Colors.deepOrange,
          title: "Check for Updates",
          onTap: () {},
        ),
        _buildTile(
          icon: Icons.description,
          iconColor: Colors.brown,
          title: "Terms & Policies",
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {},
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


