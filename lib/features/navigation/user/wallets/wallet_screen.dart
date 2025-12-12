import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/change_password/change_password.dart';
import 'package:tipl_app/features/navigation/incomes/income_screen.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_confirmation.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_item.dart';



import 'add_fund_screen.dart';
import 'membership_screen.dart';
import 'top_up_screen.dart';
import 'transaction_history_screen.dart';

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
            Consumer<WalletProvider>(
              builder: (context, value,child) {
                final balance = value.balance;
                final createAt = value.createdAt;
                final updatedAt = value.updatedAt;

                return Container(
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
                                const Icon(Iconsax.empty_wallet, size: 16),
                                const SizedBox(width: 5),
                                const Text("₹ Indian Rupees",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("\₹${balance}",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // _balanceButton(
                          //     label: "Withdraw",
                          //     color: const Color(0xff1f3f3f),
                          //     textColor: Colors.white,
                          //     icon: Icons.north_east),
                          // const SizedBox(width: 10),
                          _balanceButton(
                              label: "History",
                              // color: Colors.white,
                              // textColor: const Color(0xff1f3f3f),
                              color: Color(0xff1f3f3f),
                              textColor: Colors.white,
                              icon: Iconsax.clock,
                              border: true,
                              onTap: (){
                                navigateWithAnimation(context, TransactionHistoryScreen(transactions: value.transaction));
                              }
                          ),
                          const SizedBox(width: 10),
                          _balanceButton(
                              label: "Update",
                              onTap: (){
                                ChangePasswordScreen.show(context,updateForTnx: true);
                              },
                              color: Colors.white,
                              textColor: const Color(0xff1f3f3f),
                              icon: Iconsax.key,
                              border: true,

                          ),

                          // _balanceButton(
                          //     label: "",
                          //     onTap: (){
                          //       if(mounted){
                          //         setState(() {
                          //           _showMore = !_showMore;
                          //         });
                          //       }
                          //     },
                          //     color: Colors.white,
                          //     textColor: const Color(0xff1f3f3f),
                          //     icon: Icons.more_horiz,
                          //     border: true,
                          //     isIconOnly: true),
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
                              _menuItem(Iconsax.key, "Update Transaction Password",onTap: (){
                                ChangePasswordScreen.show(context,updateForTnx: true);
                              }),
                            ],
                          ),
                        )
                            : const SizedBox.shrink(),
                      )
                    ],
                  ),
                );
              },
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
                  _quickAction(
                      Iconsax.crown,
                      "Membership",
                    onTap: (){
                        navigateWithAnimation(context, MembershipScreen());
                    }
                  ),
                  _quickAction(
                    Iconsax.wallet_add, "Add Fund",
                    onTap: (){
                      navigateWithAnimation(context, AddFundScreen());
                    }
                  ),
                  // _quickAction(Icons.add_circle, "Add Fund",
                  //     bgColor: const Color(0xff1f3f3f),
                  //     iconColor: Colors.white,
                  // ),
                  // _quickAction(Iconsax.add, "Top-up",
                  // onTap: (){
                  //   // TopUpScreen.show(context);
                  //   navigateWithAnimation(context, TopUpScreen());
                  // }
                  // ),
                  _quickAction(Iconsax.received, "Income",
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
            Expanded(
              child: Consumer<WalletProvider>(
                builder: (context, value,child) {
                  return  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Transaction history",
                              style: TextStyle(fontSize: 14)),
                          TextButton(
                            onPressed: () {
                              navigateWithAnimation(context, TransactionHistoryScreen(transactions: value.transaction,));
                            },
                            child: const Text("View all",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
              
                      // Transaction List
                      Expanded(
                        child: value.transaction.isEmpty ? Center(child: Text("No transaction available")):ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.transaction.length < 10 ?value.transaction.length : 10,
                          itemBuilder: (BuildContext context, int index) {
                            return TransactionItem(
                             data:  value.transaction[index]
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              
              ),
            )
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
                Text(
                    label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor
                    )
                ),
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


}


