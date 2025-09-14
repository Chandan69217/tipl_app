import 'package:flutter/material.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';

// class AdminWalletScreen extends StatelessWidget {
//   const AdminWalletScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final transactions = [
//       {"user": "John Doe", "type": "Deposit", "amount": 5000.0, "status": "Completed"},
//       {"user": "Alice Smith", "type": "Withdrawal", "amount": 2000.0, "status": "Pending"},
//       {"user": "Robert Brown", "type": "Deposit", "amount": 3000.0, "status": "Completed"},
//       {"user": "Sophia Lee", "type": "Withdrawal", "amount": 1000.0, "status": "Rejected"},
//     ];
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 💰 Wallet Overview Cards
//           Row(
//             children: [
//               Expanded(
//                 child: _walletCard(
//                   title: "Total Balance",
//                   amount: "₹ 1,25,000",
//                   color: Colors.blue,
//                   icon: Icons.account_balance_wallet,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _walletCard(
//                   title: "Total Deposits",
//                   amount: "₹ 80,000",
//                   color: Colors.green,
//                   icon: Icons.arrow_downward,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: _walletCard(
//                   title: "Total Withdrawals",
//                   amount: "₹ 45,000",
//                   color: Colors.orange,
//                   icon: Icons.arrow_upward,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _walletCard(
//                   title: "Pending Requests",
//                   amount: "₹ 5,000",
//                   color: Colors.red,
//                   icon: Icons.pending,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // 📑 Recent Transactions header with menu
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 "Recent Transactions",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               PopupMenuButton<String>(
//                 onSelected: (value) {
//                   if (value == "refresh") {
//                     // Refresh logic
//                   } else if (value == "export") {
//                     // Export logic
//                   } else if (value == "settings") {
//                     // Open wallet settings
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   const PopupMenuItem(value: "refresh", child: Text("Refresh Data")),
//                   const PopupMenuItem(value: "export", child: Text("Export Data")),
//                   const PopupMenuItem(value: "settings", child: Text("Wallet Settings")),
//                 ],
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//
//           // 📑 Transaction List
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: transactions.length,
//             itemBuilder: (context, index) {
//               final txn = transactions[index];
//               final isDeposit = txn["type"] == "Deposit";
//               Color statusColor;
//               switch (txn["status"]) {
//                 case "Completed":
//                   statusColor = Colors.green;
//                   break;
//                 case "Pending":
//                   statusColor = Colors.orange;
//                   break;
//                 case "Rejected":
//                   statusColor = Colors.red;
//                   break;
//                 default:
//                   statusColor = Colors.grey;
//               }
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: isDeposit ? Colors.green : Colors.red,
//                     child: Icon(
//                       isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text("${txn["user"]} • ${txn["type"]}"),
//                   subtitle: Text("Amount: ₹${txn["amount"]}"),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == "view") {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => UserWalletDetailsScreen(
//                               user: txn["user"]!.toString(),
//                               balance: 15000,
//                               transactions: transactions
//                                   .where((t) => t["user"] == txn["user"])
//                                   .toList(),
//                             ),
//                           ),
//                         );
//                       } else if (value == "credit") {
//                         // Credit wallet logic
//                       } else if (value == "debit") {
//                         // Debit wallet logic
//                       } else if (value == "freeze") {
//                         // Freeze/unfreeze wallet
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(value: "view", child: Text("View User Transactions")),
//                       const PopupMenuItem(value: "credit", child: Text("Credit Wallet")),
//                       const PopupMenuItem(value: "debit", child: Text("Debit Wallet")),
//                       const PopupMenuItem(value: "freeze", child: Text("Freeze/Unfreeze Wallet")),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _walletCard({
//     required String title,
//     required String amount,
//     required Color color,
//     required IconData icon,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 8),
//           Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
//           const SizedBox(height: 4),
//           Text(
//             amount,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
//           ),
//         ],
//       ),
//     );
//   }
// }

class AdminWalletScreen extends StatelessWidget {
  AdminWalletScreen({super.key});
      final transactions = [
      {"user": "John Doe", "type": "Deposit", "amount": 5000.0, "status": "Completed"},
      {"user": "Alice Smith", "type": "Withdrawal", "amount": 2000.0, "status": "Pending"},
      {"user": "Robert Brown", "type": "Deposit", "amount": 3000.0, "status": "Completed"},
      {"user": "Sophia Lee", "type": "Withdrawal", "amount": 1000.0, "status": "Rejected"},
    ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Admin Wallet Control",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          /// Wallet Overview Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _walletCard(
                        title: "Total Balance",
                        amount: "₹ 1,25,000",
                        color: Colors.blue,
                        icon: Icons.account_balance_wallet,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _walletCard(
                        title: "Total Deposits",
                        amount: "₹ 80,000",
                        color: Colors.green,
                        icon: Icons.arrow_downward,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _walletCard(
                        title: "Total Withdrawals",
                        amount: "₹ 45,000",
                        color: Colors.orange,
                        icon: Icons.arrow_upward,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _walletCard(
                        title: "Pending Requests",
                        amount: "₹ 5,000",
                        color: Colors.red,
                        icon: Icons.pending,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Menu Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu',style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 20,),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.3,
                  children: [
                    _buildMenuCard(
                      context,
                      icon: Icons.account_circle,
                      label: "View Details",
                      color: Colors.deepPurple,
                      onPressed: () {
                        navigateWithAnimation(context, ConsumerDetailsScreen());
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.add_card,
                      label: "Credit Wallet",
                      color: Colors.green,
                      onPressed: () {
                        navigateWithAnimation(context, CreditWalletScreen());
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.remove_circle,
                      label: "Debit Wallet",
                      color: Colors.red,
                      onPressed: () {
                        navigateWithAnimation(context, DebitWalletScreen());
                      },
                    ),
                    _buildMenuCard(
                      context,
                      icon: Icons.lock_open,
                      label: "Freeze/Unfreeze Wallet",
                      color: Colors.orange,
                      onPressed: () {
                        navigateWithAnimation(context, FreezeWalletScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20,),

          /// Recent Transactions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.add_card),
                            title: const Text("Credit Wallet"),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreditWalletScreen(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.remove_circle),
                            title: const Text("Debit Wallet"),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DebitWalletScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          /// Transactions List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final txn = transactions[index];
                final isDeposit = txn["type"] == "Deposit";
                Color statusColor;
                switch (txn["status"]) {
                  case "Completed":
                    statusColor = Colors.green;
                    break;
                  case "Pending":
                    statusColor = Colors.orange;
                    break;
                  case "Rejected":
                    statusColor = Colors.red;
                    break;
                  default:
                    statusColor = Colors.grey;
                }

                return CustomCard(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDeposit ? Colors.green : Colors.red,
                      child: Icon(
                        isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("${txn["user"]} • ${txn["type"]}"),
                    subtitle: Text("Amount: ₹${txn["amount"]}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "view") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserWalletDetailsScreen(
                                user: txn["user"]!.toString(),
                                balance: 15000,
                                transactions: transactions
                                    .where((t) => t["user"] == txn["user"])
                                    .toList(),
                              ),
                            ),
                          );
                        } else if (value == "credit") {
                          // Credit wallet logic
                        } else if (value == "debit") {
                          // Debit wallet logic
                        } else if (value == "freeze") {
                          // Freeze/unfreeze wallet
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "view", child: Text("View User Transactions")),
                        const PopupMenuItem(value: "credit", child: Text("Credit Wallet")),
                        const PopupMenuItem(value: "debit", child: Text("Debit Wallet")),
                        const PopupMenuItem(value: "freeze", child: Text("Freeze/Unfreeze Wallet")),
                      ],
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

  Widget _walletCard({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
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
              color: color.withOpacity(0.15),
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


}






class ConsumerDetailsScreen extends StatelessWidget {
  const ConsumerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Name: John Doe"),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Phone: +91-9876543210"),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email: john@example.com"),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text("Wallet Balance: ₹5000"),
          ),
        ],
      ),
    );
  }
}



class CreditWalletScreen extends StatelessWidget {
  const CreditWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount to Credit",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // credit logic
              },
              icon: const Icon(Icons.check_circle),
              label: const Text("Credit Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}



class DebitWalletScreen extends StatelessWidget {
  const DebitWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount to Debit",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // debit logic
              },
              icon: const Icon(Icons.remove_circle),
              label: const Text("Debit Wallet"),
            ),
          ],
        ),
      ),
    );
  }
}


class FreezeWalletScreen extends StatelessWidget {
  const FreezeWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // freeze logic
          },
          icon: const Icon(Icons.lock),
          label: const Text("Freeze Wallet"),
        ),
      ),
    );
  }
}

class UnfreezeWalletScreen extends StatelessWidget {
  const UnfreezeWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // unfreeze logic
          },
          icon: const Icon(Icons.lock_open),
          label: const Text("Unfreeze Wallet"),
        ),
      ),
    );
  }
}


// 👤 User Wallet Details Screen
class UserWalletDetailsScreen extends StatelessWidget {
  final String user;
  final double balance;
  final List<Map<String, dynamic>> transactions;

  const UserWalletDetailsScreen({
    super.key,
    required this.user,
    required this.balance,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$user Wallet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Balance: ₹$balance",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("Transactions:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final txn = transactions[index];
                  return ListTile(
                    leading: Icon(
                      txn["type"] == "Deposit" ? Icons.arrow_downward : Icons.arrow_upward,
                      color: txn["type"] == "Deposit" ? Colors.green : Colors.red,
                    ),
                    title: Text("${txn["type"]} • ₹${txn["amount"]}"),
                    subtitle: Text("Status: ${txn["status"]}"),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


