import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';
import 'package:tipl_app/features/navigations/admin/manage_users/update_user_details.dart';



class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const UserDetailsScreen({super.key, required this.data});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final String status = widget.data["status"] ?? "N/A";
    final bool isActive = status.toLowerCase() == "active";

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value)async {
              switch (value) {
                case "edit":
                  navigatePushReplacementWithAnimation(context,  UpdateUserDetailsScreen(data: UserProfile.fromJson(widget.data)));
                  break;
                case "block":
                  final isBlocked =  await Provider.of<AllUserDetailsProvider>(context,listen: false).blockAndUnblockUser(userMemberID: widget.data['member_id']??'');
                  if(isBlocked){
                    setState(() {
                      widget.data['status'] = 'Inactive';
                    });
                  }
                  break;
                case 'unblock':
                  final isUnblocked = await Provider.of<AllUserDetailsProvider>(context,listen: false).blockAndUnblockUser(block: false,userMemberID: widget.data['member_id']??'');
                  if(isUnblocked){
                    setState(() {
                      widget.data['status'] = 'Active';
                    });
                  }
                  break;
              }
            },
            itemBuilder: (context){
              final String staus = widget.data['status']??'';
              final isActive = staus.toLowerCase() == 'active';
              return   [
                PopupMenuItem(
                  value: "edit",
                  child: Text("Edit User"),
                ),
                PopupMenuItem(
                  value: isActive ? "block" : 'unblock',
                  child: Text(isActive ? "Block User": 'Unblock User'),
                ),
                PopupMenuItem(
                  value: "delete",
                  child: Text("Delete User"),
                ),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                CustomNetworkImage(
                  imageUrl: widget.data['photo'],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.data["full_name"] ?? "N/A",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  widget.data["email"] ?? "N/A",
                  style: const TextStyle(color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 8.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withValues(alpha: 0.7)
                            : Colors.red.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    widget.data['package_type'] != null ?
                    Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.data['package_type']??'',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ) : SizedBox.shrink()
                  ],
                ),
                const SizedBox(height: 20),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    profileInfoCard(
                      icon: widget.data["gender"].toString().toLowerCase() == "female"
                          ? Iconsax.woman
                          : Iconsax.man,
                      label: "Gender",
                      value: widget.data["gender"] ?? "N/A",
                      iconColor: Colors.blueAccent,
                    ),
                    // DOB
                    profileInfoCard(
                      icon: Iconsax.cake,
                      label: 'DOB',
                      value: widget.data['date_of_birth']??'N/A',
                      iconColor: Colors.green,
                    ),

                    // Marital
                    profileInfoCard(
                        icon: Iconsax.heart,
                        label: 'Marital',
                        value: widget.data['marital_status']??'N/A',
                        iconColor: Colors.purpleAccent
                    ),
                    profileInfoCard(
                      icon: Iconsax.mobile,
                      label: "Mobile",
                      value: widget.data["mobile_no"] ?? "N/A",
                      iconColor: Colors.orangeAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
            const SizedBox(height: 10),
            // Sponsor & Position Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileListTile(
                  icon: Iconsax.key,
                  title: "Member ID",
                  value: widget.data['member_id']??'N/A',
                  iconColor: Colors.green,
                ),
                if(widget.data['sponsor_id'] != null)...[
                  const Divider(),
                  profileListTile(
                    icon: Iconsax.key,
                    title: "Sponsor ID",
                    value: widget.data['sponsor_id']??'N/A',
                    iconColor: Colors.teal,
                  ),
                ],
                if(widget.data['sponsor_name'] != null)...[
                  const Divider(),
                  profileListTile(
                    icon: Iconsax.user_edit,
                    title: "Sponsor Name",
                    value: widget.data["sponsor_name"] ?? "N/A",
                    iconColor: Colors.deepPurple,
                  ),
                ],
                const Divider(),
                profileListTile(
                  icon: Iconsax.element_equal,
                  title: "Position",
                  value: widget.data["position"] ?? "N/A",
                  iconColor: Colors.pinkAccent,
                ),
                const Divider(),
                profileListTile(
                  icon: Iconsax.element_equal,
                  title: "Pan Number",
                  value: widget.data["pan_number"] ?? "N/A",
                  iconColor: Colors.pinkAccent,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Address Info
            addressDetailCard(widget.data),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget profileListTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    required Color iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value),
    );
  }

  Widget profileInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.purpleAccent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: CustColors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addressDetailCard(Map<String, dynamic> user) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.teal, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Static rows
          _detailRow("Address", user['address']??'N/A',),
          _detailRow("State", user['state']??'N/A',),
          _detailRow("District", user['district']??'N/A',),
          _detailRow("Pin Code", user['pin_code']??'N/A',),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

