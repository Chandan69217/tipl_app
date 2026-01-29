import 'package:flutter/material.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/features/navigation/packages/package_transaction_screen.dart';
import 'package:tipl_app/features/navigation/packages/purchase_slide_card.dart';


class PurchasedPlanListScreen extends StatefulWidget {
  final String memberID;
  const PurchasedPlanListScreen({super.key,required this.memberID});

  @override
  State<PurchasedPlanListScreen> createState() =>
      _PurchasedPlanListScreenState();
}

class _PurchasedPlanListScreenState
    extends State<PurchasedPlanListScreen> {

  final TextEditingController _searchController =
  TextEditingController();

  List<dynamic> _plans = [];
  List<dynamic> _filteredPlans = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPurchasedPlans();
  }

  /// ---------------- FETCH API ----------------
  Future<void> _fetchPurchasedPlans() async {
    setState(() => _isLoading = true);

    try {

      _plans = await WalletApiService().getMembershipDetails(memberID:widget.memberID );
      _filteredPlans = _plans;

    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ---------------- SEARCH ----------------
  void _onSearch(String value) {
    setState(() {
      _filteredPlans = _plans.where((plan) {
        final name =
        (plan['package_type'] ?? '').toString().toLowerCase();
        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  /// ---------------- UI STATES ----------------
  Widget _noMembershipMessage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.orange.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "User have not purchased any membership yet.",
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

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearch,
        decoration: InputDecoration(
          hintText: "Search membership",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _loader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Package Purchased"),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,top: 20.0),
              child: Text('Packages List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ),
            _isLoading
                ? CustomCircularIndicator()
                : _plans.isEmpty
                ? _noMembershipMessage()
                : _filteredPlans.isEmpty
                ? const Center(
              child: Text(
                "No matching membership found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            )
                : Expanded(
                  child: RefreshIndicator(
                                onRefresh: _fetchPurchasedPlans,
                                child: ListView.builder(
                  padding:
                  const EdgeInsets.only(bottom: 16),
                  itemCount: _filteredPlans.length,
                  itemBuilder: (context, index) {
                    final plan =
                    _filteredPlans[index];
                    return GestureDetector(
                      onTap: () {
                        navigateWithAnimation(
                          context,
                          PackageTransactionScreen(
                            plan: plan,
                            isAdmin: true,
                            onSuccessPaymentAdd: (){
                              _fetchPurchasedPlans();
                            },
                          ),
                        );
                      },
                      child:
                      PurchasedPlanCard(plan: plan),
                    );
                  },
                                ),
                              ),
                ),
          ],
        ),
      ),
    );
  }
}
