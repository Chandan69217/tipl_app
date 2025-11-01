import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/genealogy_provider/genealogy_provider.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/features/navigations/genealogy/member_card.dart';
import 'package:tipl_app/features/navigations/genealogy/tree_view_screen.dart';


class GenealogyScreen extends StatefulWidget {
  final bool canPop;
  const GenealogyScreen({this.canPop = false,super.key});

  @override
  State<GenealogyScreen> createState() => _GenealogyScreenState();
}

class _GenealogyScreenState extends State<GenealogyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _tabController.index >= 0 &&
          _tabController.index < _tabController.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final provider = Provider.of<GenealogyProvider>(context, listen: false);
          provider.search(_searchQuery, _tabController.index);
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.canPop ? AppBar(
        title: Text('Genealogy'),
      ):null,
      body: Consumer<GenealogyProvider>(
        builder: (context,genealogy,child){
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search by name,member id",
                    prefixIcon: const Icon(Iconsax.search_normal),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (query){
                    _searchQuery = query;
                    genealogy.search(_searchQuery, _tabController.index);
                  },
                ),
              ),

              // TabBar full width
              Container(
                decoration: BoxDecoration(
                  gradient: CustColors.tabBarGradient,
                ),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // reduce vertical padding
                child: SizedBox(
                  height: 48, // control TabBar height
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    dividerHeight: 0,
                    indicator: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    labelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    tabs: const [
                      Tab(icon: Icon(Iconsax.people, size: 18), text: "All Team"),
                      Tab(icon: Icon(Iconsax.user_add, size: 18), text: "Direct"),
                      Tab(icon: Icon(Iconsax.user_remove, size: 18), text: "Active"),
                      Tab(icon: Icon(Iconsax.user_remove, size: 18), text: "Inactive"),
                    ],
                  ),
                ),
              ),

              // TabBarView
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
                  child: TabBarView(
                    controller: _tabController,
                    viewportFraction: 1,
                    children: [
                      // All Members
                      genealogy.filterAllTeams.isNotEmpty ?
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: genealogy.filterAllTeams.length,
                          itemBuilder: (context,index){
                          final member = genealogy.filterAllTeams[index] as Map<String,dynamic>;
                          return MemberCard(name: member['full_name']??'N/A', subtitle: '${member['member_id']??'--'} - ${member['position']??''}',active: '${member['status']??''}'.toLowerCase() == 'active',);
                          }
                      ):Center(
                        child: Text('No members available'),
                      ),

                      // Direct Members
                      genealogy.filterDirectTeams.isNotEmpty ?
                      ListView.builder(
                        shrinkWrap: true,
                          itemCount: genealogy.filterDirectTeams.length,
                          itemBuilder: (context,index){
                            final member = genealogy.filterDirectTeams[index] as Map<String,dynamic>;
                            return MemberCard(name: member['full_name']??'N/A', subtitle: '${member['member_id']??'--'} - ${member['position']??''}',active: '${member['status']??''}'.toLowerCase() == 'active',);
                          }
                      ):Center(
                        child: Text('No members available'),
                      ),

                      // Active Members
                      genealogy.filterActiveTeams.isNotEmpty ?
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: genealogy.filterActiveTeams.length,
                          itemBuilder: (context,index){
                            final member = genealogy.filterActiveTeams[index] as Map<String,dynamic>;
                            return MemberCard(name: member['full_name']??'N/A', subtitle: '${member['member_id']??'--'} - ${member['position']??''}',active: '${member['status']??''}'.toLowerCase() == 'active',);
                          }
                      ):Center(
                        child: Text('No members available'),
                      ),
                      // Inactive Members
                      genealogy.filterInactiveTeams.isNotEmpty ?
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: genealogy.filterInactiveTeams.length,
                          itemBuilder: (context,index){
                            final member = genealogy.filterInactiveTeams[index] as Map<String,dynamic>;
                            return MemberCard(name: member['full_name']??'N/A', subtitle: '${member['member_id']??'--'} - ${member['position']??''}',active: '${member['status']??''}'.toLowerCase() == 'active',);
                          }
                      ):Center(
                        child: Text('No members available'),
                      ),
                      // _treeView(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Iconsax.hierarchy),
        label: const Text(
          'View Tree',
          style: TextStyle(
            fontSize: 16
          ),
        ),
        onPressed: () {
          LeftRightTreeView.show(context);
        },
      ),

    );
  }


  @override
  void dispose() {
    _tabController.removeListener((){});
    super.dispose();
  }

}



