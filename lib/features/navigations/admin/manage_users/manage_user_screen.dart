import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';
import 'package:tipl_app/features/navigations/admin/manage_users/update_user_details.dart';
import 'package:tipl_app/features/navigations/admin/manage_users/user_details_screen.dart';





class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {


  String _filter = "All";

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => Provider.of<AllUserDetailsProvider>(context,listen: false).searchUsers(value));
              },
            ),
          ),

          // 📊 Filters Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterChip("All"),
                _buildFilterChip("Active"),
                _buildFilterChip("Inactive"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: Consumer<AllUserDetailsProvider>(
              builder: (context, userProvider, child) {
                final users = userProvider.filteredUsers;
                return  userProvider.filteredUsers.isEmpty
                    ? const Center(
                  child: Text(
                    "No users found",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isActive = user["status"] == "Active";

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomCard(
                        child: ListTile(
                          onTap: (){
                            navigateWithAnimation(context,  UserDetailsScreen(data: user));
                          },
                          contentPadding: EdgeInsets.only(left: 16,top: 4,bottom: 4),
                          leading: CircleAvatar(
                            backgroundColor:
                            isActive ? Colors.green : Colors.red,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            user["full_name"]??'N/A',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(user["email"]!),
                          trailing: PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case "edit":
                                  navigateWithAnimation(context,  UpdateUserDetailsScreen(data: UserProfile.fromJson(user)));
                                  break;
                                case "block":
                                  userProvider.blockAndUnblockUser(userMemberID: user['member_id']??'');
                                  break;
                                case 'unblock':
                                userProvider.blockAndUnblockUser(block: false,userMemberID: user['member_id']??'');
                              break;
                              }
                            },
                            itemBuilder: (context){
                              final String staus = user['status']??'';
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
                                // PopupMenuItem(
                                //   value: "delete",
                                //   child: Text("Delete User"),
                                // ),
                              ];
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }


  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == label,
      onSelected: (_) {
        _filter = label;
        setState(() => Provider.of<AllUserDetailsProvider>(context,listen: false).filterByStatus(_filter));
      },
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: _filter == label ? Colors.blue.shade900 : Colors.black87,
      ),
    );
  }

}

