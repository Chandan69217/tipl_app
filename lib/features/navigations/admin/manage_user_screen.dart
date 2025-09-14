import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';





class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final List<Map<String, String>> _users = [
    {"name": "John Doe", "email": "john@example.com", "status": "Active"},
    {"name": "Alice Smith", "email": "alice@example.com", "status": "Inactive"},
    {"name": "Robert Brown", "email": "robert@example.com", "status": "Active"},
    {"name": "Sophia Lee", "email": "sophia@example.com", "status": "Inactive"},
  ];

  String _searchQuery = "";
  String _filter = "All"; // All, Active, Inactive

  @override
  Widget build(BuildContext context) {
    // 🔍 Filtered + Searched users
    final filteredUsers = _users.where((user) {
      final matchesSearch = user["name"]!.toLowerCase().contains(_searchQuery) ||
          user["email"]!.toLowerCase().contains(_searchQuery);
      final matchesFilter =
          _filter == "All" || user["status"] == _filter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      children: [
        // 🔍 Search Bar
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
              setState(() => _searchQuery = value.toLowerCase());
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

        // 👥 User List
        Expanded(
          child: filteredUsers.isEmpty
              ? const Center(
            child: Text(
              "No users found",
              style: TextStyle(color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              final isActive = user["status"] == "Active";

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomCard(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      isActive ? Colors.green : Colors.red,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      user["name"]!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(user["email"]!),
                    trailing: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case "view":
                            SnackBarHelper.show(context,message: "Viewing ${user["name"]}");
                            break;
                          case "edit":
                            SnackBarHelper.show(context,message: "Editing ${user["name"]}");
                            break;
                          case "block":
                            setState(() {
                              user["status"] = "Inactive";
                            });
                            SnackBarHelper.show(context,message: "${user["name"]} blocked");
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "view",
                          child: Text("View Details"),
                        ),
                        PopupMenuItem(
                          value: "edit",
                          child: Text("Edit User"),
                        ),
                        PopupMenuItem(
                          value: "block",
                          child: Text("Block User"),
                        ),
                        // PopupMenuItem(
                        //   value: "delete",
                        //   child: Text("Delete User"),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // 🟢 Filter Chip builder
  Widget _buildFilterChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == label,
      onSelected: (_) {
        setState(() => _filter = label);
      },
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: _filter == label ? Colors.blue.shade900 : Colors.black87,
      ),
    );
  }

}

