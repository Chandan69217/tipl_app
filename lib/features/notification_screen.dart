import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "Wallet Credited",
      "message": "₹500 has been credited to user John Doe's wallet.",
      "time": "2 min ago",
      "icon": Icons.add_card,
      "color": Colors.green,
      "unread": true,
    },
    {
      "title": "Wallet Debited",
      "message": "₹200 has been debited from Alice's wallet.",
      "time": "10 min ago",
      "icon": Icons.remove_circle,
      "color": Colors.red,
      "unread": true,
    },
    {
      "title": "New User Registration",
      "message": "Robert Brown has registered as a new member.",
      "time": "1 hr ago",
      "icon": Icons.person_add,
      "color": Colors.blue,
      "unread": false,
    },
    {
      "title": "System Update",
      "message": "App v1.2.0 is available for update.",
      "time": "Yesterday",
      "icon": Icons.system_update,
      "color": Colors.orange,
      "unread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // TODO: Clear all notifications
            },
          )
        ],
      ),
      body: Column(
        children: [
          // 🔹 Filter Chips Row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("All", true),
                  _buildFilterChip("Unread", false),
                  _buildFilterChip("System", false),
                  _buildFilterChip("Transactions", false),
                ],
              ),
            ),
          ),

          // 🔹 Notifications List
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return Dismissible(
                  key: Key(notif["title"] + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // TODO: remove notification
                  },
                  child: Card(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notif["color"].withOpacity(0.15),
                        child: Icon(
                          notif["icon"],
                          color: notif["color"],
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              notif["title"],
                              style: TextStyle(
                                fontWeight: notif["unread"]
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (notif["unread"])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            )
                        ],
                      ),
                      subtitle: Text(notif["message"]),
                      trailing: Text(
                        notif["time"],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        // TODO: mark as read or open detail
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (val) {},
        selectedColor: Colors.teal.shade100,
        checkmarkColor: Colors.teal,
      ),
    );
  }
}
