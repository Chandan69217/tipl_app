import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool userAlreadyPurchased = false;

  Map<String, dynamic> purchasedPlan = {};

  String? selectedPlan;

  final List<Map<String, dynamic>> membershipPlans = [
    {
      "type": "silver",
      "title": "Silver Membership",
      "range": "₹0 – ₹25,000",
      "price": 2000.0,
      "color": Colors.purpleAccent,
      "icon": "assets/icons/silver_membership.webp",
      "description": "Best for beginners. Access to basic membership benefits.",
    },
    {
      "type": "gold",
      "title": "Gold Membership",
      "range": "₹50,000 – ₹75,000",
      "price": 5000.0,
      "color": Colors.blueAccent,
      "icon": "assets/icons/gold_membership.webp",
      "description":
          "Ideal for active users. Includes premium features and priority support.",
    },
    {
      "type": "platinum",
      "title": "Platinum Membership",
      "range": "₹1,00,000 – ₹5,00,000",
      "price": 10000.0,
      "color": Colors.orangeAccent,
      "icon": "assets/icons/platinum_membership.webp",
      "description":
          "Ultimate VIP access with all benefits unlocked + exclusive rewards.",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  void _showNoMembershipDialog() {
    CustomMessageDialog.show(
      context,
      title: 'No Membership Found',
      message:
          'You have not purchased any membership yet. Please choose a plan.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: const Text("Join Membership")),
      body: Consumer<WalletProvider>(
        builder: (context, value, child) {
          if (!userAlreadyPurchased) {
            if (value.memberships.isEmpty) {
              _showNoMembershipDialog();
            } else {
              WidgetsBinding.instance.addPostFrameCallback((duration) {
                setState(() {
                  purchasedPlan = value.memberships[0];
                  userAlreadyPurchased = true;
                });
              });
            }
          }
          return child ?? SizedBox.shrink();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Show purchased card OR message
            if (userAlreadyPurchased)
              _buildPurchasedCard()
            else
              _buildNoMembershipMessage(),

            const SizedBox(height: 24),

            // Membership Options List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "Membership Packages",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: membershipPlans.length,
                itemBuilder: (context, index) {
                  final p = membershipPlans[index];
                  return _buildPackageCard(p);
                },
              ),
            ),

            _buildBottomPayBar(),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // MESSAGE WHEN NO MEMBERSHIP
  // ==================================================
  Widget _buildNoMembershipMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange.shade700),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "You have not purchased any membership yet.",
              style: TextStyle(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // PURCHASED MEMBERSHIP CARD
  // ==================================================

  Widget _buildPurchasedCard() {
    final dateFormater = DateFormat('MMM yy');
    final createdDate = DateTime.tryParse(purchasedPlan['createdAt'] ?? '');
    final createdDateFormat = createdDate != null
        ? dateFormater.format(createdDate)
        : 'N/A';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(
                  Iconsax.verify5,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Membership",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    purchasedPlan["package_type"] ?? 'N/A',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _detailItem("Status", purchasedPlan["status"] ?? 'N/A'),
              _detailItem("Amount", "₹${purchasedPlan["amount"] ?? '0.0'}"),
              _detailItem("Valid From", createdDateFormat ?? 'N/A'),
              _detailItem("Valid Till", purchasedPlan["expiry_date"] ?? 'N/A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================================================
  // MEMBERSHIP PACKAGE CARD
  // ==================================================

  Widget _buildPackageCard(Map<String, dynamic> plan) {
    final bool isSelected = selectedPlan == plan["type"];

    return GestureDetector(
      onTap: () => setState(() => selectedPlan = plan["type"]),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: plan["color"].withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? plan["color"] : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: plan["color"].withOpacity(0.2),
                  child: Image.asset(plan["icon"], width: 35),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan["type"] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan["description"] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        plan["range"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹ ${plan["price"]}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: plan["color"],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? plan["color"] : Colors.grey,
                  size: 28,
                ),
              ],
            ),
          ),

          // -----------------------
          // LABEL ON SELECTED PLAN
          // -----------------------
          if (isSelected)
            Positioned(
              right: 18,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: plan["color"],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Selected Plan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomPayBar() {
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, refresh) {
        final selected = selectedPlan == null
            ? null
            : membershipPlans.firstWhere((p) => p["type"] == selectedPlan);

        final totalAmount = selected?["price"] ?? 0.0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------------
                // SELECTED PACKAGE DETAILS (Only when a package is selected)
                // ---------------------------------------------------------
                if (selected != null) ...[
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: selected["color"].withOpacity(0.15),
                        child: Image.asset(selected["icon"], width: 36),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected["type"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              selected["range"],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "₹ $totalAmount",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    selected["description"],
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                ],

                // ---------------------------------------------------------
                // PAY BUTTON + LOADER
                // ---------------------------------------------------------
                isLoading
                    ? const CustomCircularIndicator()
                    : CustomButton(
                        text: 'Confirm & pay',
                        color: selected == null
                            ? Colors.grey.shade300
                            : Colors.black,
                        onPressed: selectedPlan == null
                            ? () {}
                            : () async {
                                refresh(() {
                                  isLoading = true;
                                });

                                final password =
                                    await showTransactionPasswordSheet();

                                if (password != null) {
                                  if (selected == null) {
                                    refresh(() {
                                      isLoading = false;
                                    });
                                    return;
                                  }
                                  final data = await WalletApiService()
                                      .purchaseMembership(
                                        packageType: selected['type'],
                                        amount: selected['price'],
                                        password: password,
                                      );

                                  if (data != null) {
                                    final message = data['message'];
                                    CustomMessageDialog.show(
                                      context,
                                      title: 'Membership',
                                      message: message,
                                    );
                                    final isSuccess =
                                        data['isSuccess'] ?? false;
                                    if (isSuccess) {
                                      RecallProvider(context: context);
                                    }
                                  }
                                }

                                refresh(() {
                                  isLoading = false;
                                });
                              },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> showTransactionPasswordSheet() async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const TransactionPasswordSheet(),
    );
  }

  // Future<String?> showTransactionPasswordSheet()async {
  //   final TextEditingController passCtrl = TextEditingController();
  //   return await showModalBottomSheet<String>(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //     ),
  //     builder: (context) {
  //       bool obscure = true;
  //       GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Padding(
  //             padding: EdgeInsets.only(
  //               left: 20,
  //               right: 20,
  //               bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //               top: 20,
  //             ),
  //             child: Form(
  //               key: _formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     width: 40,
  //                     height: 4,
  //                     decoration: BoxDecoration(
  //                         color: Colors.grey.shade400,
  //                         borderRadius: BorderRadius.circular(10)),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   const Text(
  //                     "Enter Transaction Password",
  //                     style: TextStyle(
  //                         fontSize: 18, fontWeight: FontWeight.w700),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     "For security, please confirm your transaction password.",
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         fontSize: 13, color: Colors.grey.shade600),
  //                   ),
  //                   const SizedBox(height: 20),
  //
  //                   // Password Field
  //                   CustomTextField(
  //                     label: 'Transaction Password',
  //                     controller: passCtrl,
  //                     prefixIcon:  Icon(Iconsax.password_check),
  //                     isRequired: true,
  //                     obscureText: obscure,
  //                     textInputType: TextInputType.visiblePassword,
  //                   ),
  //                   const SizedBox(height: 20),
  //
  //                   // Confirm Button
  //                   CustomButton(
  //                     text: 'Confirm Payment',
  //                     onPressed: () {
  //                       if (!(_formKey.currentState?.validate()??false)) {
  //                         return;
  //                       }
  //                       Navigator.pop(context, passCtrl.text.trim());
  //                     },
  //                     color: Colors.black,
  //
  //                   ),
  //                   const SizedBox(height: 20,)
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}

class TransactionPasswordSheet extends StatefulWidget {
  const TransactionPasswordSheet({super.key});

  @override
  State<TransactionPasswordSheet> createState() =>
      _TransactionPasswordSheetState();
}

class _TransactionPasswordSheetState extends State<TransactionPasswordSheet> {
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Enter Transaction Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Text(
              "For security, please confirm your transaction password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'Transaction Password',
              controller: passCtrl,
              prefixIcon: Icon(Iconsax.password_check),
              isRequired: true,
              obscureText: obscure,
              textInputType: TextInputType.visiblePassword,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Confirm Payment',
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;

                Navigator.pop(context, passCtrl.text.trim());
              },
              color: Colors.black,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
