import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';
import 'package:tipl_app/features/auth/sign_up_screen.dart';
import 'package:tipl_app/features/navigation/genealogy/genealogy_screen.dart';
import 'package:tipl_app/features/navigation/genealogy/tree_view_screen.dart';
import 'package:tipl_app/features/navigation/meetings/meeting_screen.dart';
import 'package:tipl_app/features/navigation/packages/pacakge_list_screen.dart';


import 'manage_banks/bank_details_list_screen.dart';
import 'manage_users/user_details_screen.dart';



class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key,this.onUpdate});
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }
    double aspectRatio;
    if (screenWidth < 350) {
      aspectRatio = 0.9;
    } else if (screenWidth < 600) {
      aspectRatio = 1.2;
    } else if (screenWidth < 900) {
      aspectRatio = 1.3;
    } else {
      aspectRatio = 1.5;
    }
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
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspectRatio,
            children: [
              // Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
              //   return _dashboardCard(Iconsax.people, "Total Consumers", value.totalUser.toString(), Colors.blue);
              // },),
              Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
                return _dashboardCard(Iconsax.user_tag, "Active Users", "${value.activeUser}", Colors.green);
              },),
              Consumer<AllUserDetailsProvider>(builder: (context, value, child) {
                return _dashboardCard(Iconsax.user_remove, "Inactive Users", "${value.inactiveUser}", Colors.red);
              },),

              _dashboardCard(Iconsax.wallet, "Total Income", "₹ 15,40,000", Colors.purple),
              _dashboardCard(Iconsax.money, "Total Withdrawals", "₹ 8,20,000", Colors.orange),
              // _dashboardCard(Iconsax.activity, "Pending Requests", "34", Colors.teal),
            ],
          ),
          const SizedBox(height: 20),
          /// Menu Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Menu',style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20,),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: screenWidth > 350 ? 3 : 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: screenWidth > 350 ? 1.2:1,
                children: [
                  _buildMenuCard(
                    context,
                    icon: Iconsax.box,
                    label: "Manage Package",
                    color: Colors.teal,
                    onPressed: () {
                      navigateWithAnimation(context, PackagesListScreen());
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Iconsax.bank,
                    label: "All Banks",
                    color: Colors.deepPurple,
                    onPressed: () {
                      navigateWithAnimation(context, BankDetailsListScreen());
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Iconsax.hierarchy,
                    label: "View Tree",
                    color: Colors.blue,
                    onPressed: () {
                      LeftRightTreeView.show(context);
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Iconsax.user_add,
                    label: "New Registration",
                    color: Colors.red,
                    onPressed: () {
                      navigateWithAnimation(context, SignUpScreen(canPop: true,));
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Iconsax.people,
                    label: "Manage Meetings",
                    color: Colors.green,
                    onPressed: () {
                      navigateWithAnimation(context, MeetingListScreen(canPop: true,));
                    },
                  ),

                  _buildMenuCard(
                    context,
                    icon: Iconsax.hierarchy_square,
                    label: "Genealogy",
                    color: Colors.pinkAccent,
                    onPressed: () {
                      navigateWithAnimation(context, GenealogyScreen(canPop: true,));
                    },
                  ),

                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(),
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.users.length < 5 ? value.users.length : 5,
                  itemBuilder: (context, index) {
                    final reversedUsers = value.users.reversed.toList();
                    final user = reversedUsers[index];

                    final date = DateTime.tryParse(user['createdAt'] ?? '');
                    final formatDate = date != null ? DateFormat('dd MMM yyyy').format(date) : '-';

                    return _recentTile(
                      onTap: () {
                        navigateWithAnimation(context, UserDetailsScreen(data: user));
                      },
                      user['full_name'] ?? 'N/A',
                      user['status'] ?? '-',
                      formatDate,
                    );
                  },
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

  Widget _buildMenuCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular colored background for icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 6),
          // Label
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
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
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 6),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
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
