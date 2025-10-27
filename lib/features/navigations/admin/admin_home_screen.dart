import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';
import 'package:tipl_app/features/navigations/admin/manage_users/user_details_screen.dart';



class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key,this.onUpdate});
  final VoidCallback? onUpdate;

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
              Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
                return _dashboardCard(Iconsax.people, "Total Consumers", value.totalUser.toString(), Colors.blue);
              },),
              Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
                return _dashboardCard(Iconsax.user_tag, "Active Users", "${value.activeUser}", Colors.green);
              },),
              Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
                return _dashboardCard(Iconsax.user_remove, "Inactive Users", "${value.inactiveUser}", Colors.red);
              },),

              _dashboardCard(Iconsax.wallet, "Total Income", "₹ 15,40,000", Colors.purple),
              _dashboardCard(Iconsax.money, "Total Withdrawals", "₹ 8,20,000", Colors.orange),
              _dashboardCard(Iconsax.activity, "Pending Requests", "34", Colors.teal),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Registrations",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              TextButton(
                  onPressed: (){
                onUpdate?.call();
              }, child: Text('View all'))
            ],
          ),
          const SizedBox(height: 12),
          Consumer<AllUserDetailsProvider>(
              builder: (context,value,child){
                return ListView.builder(
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: value.users.length < 6 ? value.users.length : 5,
                    itemBuilder: (context,index){
                    final user = value.users[index];
                    final date = DateTime.tryParse(user['createdAt']??'');
                    final formatDate = date != null ? DateFormat('dd MMM yyyy').format(date) : '-';
                    return _recentTile(onTap: (){
                      navigateWithAnimation(context, UserDetailsScreen(data: user));
                    },user['full_name']??'N/A', user['status']??'-', formatDate);
                    }
                );
              }
          ),

          const SizedBox(height: 24),

          const Text(
            "Recent Withdrawals",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
  Widget _recentTile(String name, String status, String date,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
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
      ),
    );
  }

}
