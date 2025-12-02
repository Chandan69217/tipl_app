import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/navigations/incomes/income_screen.dart';
import 'package:tipl_app/features/navigations/investment/investment_screen.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>  with SingleTickerProviderStateMixin{
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffb6d9e8), Color(0xffd9f0e9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Available Balance",
                          style: TextStyle(
                              fontSize: 12, color: Colors.black54)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Image.network(
                            //   "https://upload.wikimedia.org/wikipedia/commons/4/41/Flag_of_India.svg",
                            //   width: 20,
                            //   height: 14,
                            //   fit: BoxFit.cover,
                            // ),
                            const Icon(Iconsax.empty_wallet, size: 16),
                            const SizedBox(width: 5),
                            const Text("₹ Indian Rupees",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            // const Icon(Iconsax.empty_wallet, size: 16),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("\₹817,432.09",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _balanceButton(
                          label: "Withdraw",
                          color: const Color(0xff1f3f3f),
                          textColor: Colors.white,
                          icon: Icons.north_east),
                      const SizedBox(width: 10),
                      _balanceButton(
                          label: "History",
                          color: Colors.white,
                          textColor: const Color(0xff1f3f3f),
                          icon: Iconsax.clock,
                          border: true),
                      const SizedBox(width: 10),
                      _balanceButton(
                          label: "",
                          onTap: (){
                            if(mounted){
                              setState(() {
                                _showMore = !_showMore;
                              });
                            }
                          },
                          color: Colors.white,
                          textColor: const Color(0xff1f3f3f),
                          icon: Icons.more_horiz,
                          border: true,
                          isIconOnly: true),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _showMore
                        ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: [
                          // _menuItem(Iconsax.setting, "Settings"),
                          _menuItem(Iconsax.info_circle, "Wallet Details"),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffe6f0eb),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _quickAction(Iconsax.crown, "Membership"),
                  _quickAction(Iconsax.wallet_add, "Add Fund"),
                  // _quickAction(Icons.add_circle, "Add Fund",
                  //     bgColor: const Color(0xff1f3f3f),
                  //     iconColor: Colors.white,
                  // ),
                  _quickAction(Iconsax.add, "Top-up",
                  onTap: (){
                    navigateWithAnimation(context, InvestmentScreen());
                  }
                  ),
                  _quickAction(Iconsax.receipt, "Statement",
                    onTap: (){
                    navigateWithAnimation(context, IncomeScreen());
                    }
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Center(
              child: Container(
                width: 60,
                height: 1,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),

            // Transaction Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Transaction history",
                    style: TextStyle(fontSize: 14)),
                TextButton(
                  onPressed: () {},
                  child: const Text("View all",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                )
              ],
            ),

            // Transaction List
            Expanded(
              child: ListView(
                children: [
                  _transactionItem(
                      "Octavia Devi",
                      "12 Des, 10:32 AM",
                      "-\₹15.89",
                      Colors.red,
                      "https://storage.googleapis.com/a1aa/image/148b6e74-e6c3-4a00-ac48-a786cbc90c2d.jpg"),
                  _transactionItem(
                      "Aditya Anugrah",
                      "7 Des, 03:08 PM",
                      "+\₹129.21",
                      Colors.green,
                      "https://storage.googleapis.com/a1aa/image/b7875a6b-9af5-4ae9-478e-2266ac3a97d5.jpg"),
                  _transactionItem(
                      "Melasari",
                      "5 Des, 12:12 AM",
                      "-\₹15.89",
                      Colors.red,
                      "https://storage.googleapis.com/a1aa/image/bedf956c-d722-453c-f24e-8d4ca2a78b4a.jpg"),
                  _transactionItem(
                      "Judha Wijaya",
                      "18 Des, 08:24 AM",
                      "+\₹89.73",
                      Colors.green,
                      "https://storage.googleapis.com/a1aa/image/c0a39a37-32aa-40d0-abb5-7972431d0070.jpg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---
  Widget _balanceButton({
    required String label,
    required Color color,
    required Color textColor,
    required IconData icon,
    bool border = false,
    VoidCallback? onTap,
    bool isIconOnly = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isIconOnly ? 48 : 120,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          border: border ? Border.all(color: Colors.grey.shade300) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 16),
              if (!isIconOnly) ...[
                const SizedBox(width: 5),
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label,
      {Color bgColor = Colors.white,
        Color iconColor = const Color(0xff1f3f3f),
        Color textColor = const Color(0xff1f3f3f),
        VoidCallback? onTap
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textColor,
              ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title,{VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _transactionItem(String name, String date, String amount, Color color,
      String imageUrl) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(date, style: const TextStyle(fontSize: 12)),
      trailing: Text(amount,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: color)),
    );
  }
}


