import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';



class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Dashboard Stat Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _dashboardCard(Iconsax.people, "Total Consumers", "1200", Colors.blue),
              _dashboardCard(Iconsax.user_tag, "Active Users", "950", Colors.green),
              _dashboardCard(Iconsax.user_remove, "Inactive Users", "250", Colors.red),
              _dashboardCard(Iconsax.wallet, "Total Income", "₹ 15,40,000", Colors.purple),
              _dashboardCard(Iconsax.money, "Total Withdrawals", "₹ 8,20,000", Colors.orange),
              _dashboardCard(Iconsax.activity, "Pending Requests", "34", Colors.teal),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          const Text(
            "Recent Registrations",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _recentTile("Chandan Sharma", "Active", "12 Sep 2025"),
          _recentTile("Anita Verma", "Pending", "11 Sep 2025"),
          _recentTile("Ravi Kumar", "Inactive", "10 Sep 2025"),
          _recentTile("Sneha Gupta", "Active", "09 Sep 2025"),

          const SizedBox(height: 24),

          const Text(
            "Recent Withdrawals",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _recentTile("Amit Singh", "₹ 12,000", "12 Sep 2025"),
          _recentTile("Priya Das", "₹ 8,500", "11 Sep 2025"),
          _recentTile("Karan Mehta", "₹ 5,000", "10 Sep 2025"),
        ],
      ),
    );
  }

  // Dashboard Card
  Widget _dashboardCard(IconData icon, String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  // Recent Activity Tile
  Widget _recentTile(String name, String status, String date) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Iconsax.user, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(status,
                    style: TextStyle(
                        color: status == "Active"
                            ? Colors.green
                            : status == "Inactive"
                            ? Colors.red
                            : Colors.orange,
                        fontSize: 12)),
              ],
            ),
          ),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

}
