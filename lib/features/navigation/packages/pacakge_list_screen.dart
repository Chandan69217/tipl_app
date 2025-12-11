import 'package:flutter/material.dart';
import 'package:tipl_app/api_service/packages_api/packages_api.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/features/navigation/packages/create_update_package_screen.dart';
import 'package:tipl_app/features/navigation/packages/package_card.dart';

class PackagesListScreen extends StatefulWidget {
  const PackagesListScreen({super.key});

  @override
  State<PackagesListScreen> createState() => _PackagesListScreenState();
}

class _PackagesListScreenState extends State<PackagesListScreen> {
  List<dynamic> _membershipPlans = [];
  List<dynamic> _filteredPlans = [];

  final TextEditingController searchController = TextEditingController();
  late Future<void> _futureLoad;

  @override
  void initState() {
    super.initState();
    _futureLoad = loadData();
  }

  // ---------------- LOAD DATA ----------------
  Future<void> loadData() async {
    final result = await PackagesApiService().getPackagesType();

    setState(() {
      _membershipPlans = result;
      _filteredPlans = result; // important
    });
  }

  // ----------------- SEARCH FUNCTION -----------------
  void searchPackage(String query) {
    query = query.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredPlans = _membershipPlans;
      } else {
        _filteredPlans = _membershipPlans.where((plan) {
          final type = (plan['package_name'] ?? '').toString().toLowerCase();
          return type.contains(query);
        }).toList();
      }
    });
  }

  // ----------------- REFRESH -----------------
  Future<void> refresh() async {
    searchController.clear();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      setState(() {
        _futureLoad = loadData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Membership Packages"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: TextButton(onPressed: (){
              navigateWithAnimation(context, CreateUpdatePackageScreen(
                onSuccess: (){
                  refresh();
                },
              ));
            },
                child: Text("Add"),
            ),
          )
        ],
      ),

      body: FutureBuilder(
        future: _futureLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCircularIndicator();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- SEARCH BAR ----------------
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: TextField(
                  controller: searchController,
                  onChanged: searchPackage,
                  decoration: InputDecoration(
                    hintText: "Search by package type...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
              ),

              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("List of Packages",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
              ),
              const SizedBox(height: 2),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: _filteredPlans.isEmpty
                      ? const Center(
                    child: Text(
                      'No Packages Found',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPlans.length,
                    itemBuilder: (context, index) {
                      final p = _filteredPlans[index];
                      final color = Colors.primaries[index % Colors.primaries.length];

                      return PackageCard(
                        plan: p,
                        color: color,
                        canEdit: true,
                        canDelete: true,
                        onEdit: (){
                          navigateWithAnimation(context, CreateUpdatePackageScreen(
                            isEdit: true,
                            existingData: p,
                            onSuccess: (){
                              refresh();
                            },
                          )
                          );
                        },
                        onDelete: ()async{
                          refresh();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
