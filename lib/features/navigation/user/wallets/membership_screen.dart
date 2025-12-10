import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/packages_api/packages_api.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/features/navigation/packages/package_card.dart';
import 'package:tipl_app/features/navigation/packages/purchase_slide_card.dart';



class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool userAlreadyPurchased = false;

  List<dynamic> purchasedPlan = [];

  String? selectedPlan;

  final List<Color> membershipPlanCardCorlor = [
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.orangeAccent
  ];
  bool isLoading = true;
  final Map<String,String> packageIcon = {
    "silver": "assets/icons/silver_membership.webp",
    "gold":"assets/icons/gold_membership.webp",
    "platinum" :"assets/icons/platinum_membership.webp"
  };

  List<dynamic> membershipPlans = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init()async{
    membershipPlans = await PackagesApiService().getPackagesType();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      setState(() {
        isLoading = false;
      });
    });
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
                  purchasedPlan = value.memberships;
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
              PurchasedPlanSlider(purchasedPlan: purchasedPlan)
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
            const SizedBox(height: 8,),
            Expanded(
              child: isLoading ? CustomCircularIndicator():membershipPlans.isEmpty ? Center(child: Text('No Packages Available')):ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: membershipPlans.length,
                itemBuilder: (context, index) {
                  final p = membershipPlans[index];
                  final color = membershipPlanCardCorlor[index%3];
                  final icon = packageIcon[(p['package_name']??'').toLowerCase()]??'';
                  return PackageCard(
                    plan: p,
                    color: color,
                    canSelect: true,
                    isSelected: selectedPlan == p["package_name"],
                    onSelect: () {
                      setState(() => selectedPlan = p["package_name"]);
                    },
                  );
                },
              ),
            ),
            if(membershipPlans.isNotEmpty)
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


  Widget _buildBottomPayBar() {
    bool isLoading = false;

    return StatefulBuilder(
      builder: (context, refresh) {
        final selected = selectedPlan == null
            ? null
            : membershipPlans.firstWhere((p) => p["package_name"] == selectedPlan);

        final totalAmount = selected?["amount"] ?? 0.0;

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
                      // CircleAvatar(
                      //   radius: 22,
                      //   backgroundColor: selected["color"].withOpacity(0.15),
                      //   child: Image.asset(selected["icon"], width: 36),
                      // ),
                      // const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected["package_name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              " Duration: ${selected["duration_in_days"]} days",
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
                                        packageType: selected['package_name'],
                                        amount: selected['amount'],
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
                                      setState(() {
                                      });
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








