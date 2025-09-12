import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';


class GenealogyScreen extends StatefulWidget {
  const GenealogyScreen({super.key});

  @override
  State<GenealogyScreen> createState() => _GenealogyScreenState();
}

class _GenealogyScreenState extends State<GenealogyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search members...",
              prefixIcon: const Icon(Iconsax.search_normal),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              // 👉 Add search logic here
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
                Tab(icon: Icon(Iconsax.user_add, size: 18), text: "Direct"),
                Tab(icon: Icon(Iconsax.people, size: 18), text: "All Team"),
                Tab(icon: Icon(Iconsax.user_remove, size: 18), text: "Inactive"),
                Tab(icon: Icon(Iconsax.diagram, size: 18), text: "Tree View"),
              ],
            ),
          ),
        ),

        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _directMembers(),
              _allTeam(),
              _inactiveTeam(),
              _treeView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _directMembers() => _listWrapper(children: [
    _memberCard("John Doe", "ID: 12345", active: true),
    _memberCard("Alice Smith", "ID: 67890", active: true),
    _memberCard("Robert Brown", "ID: 54321", active: true),
  ]);

  Widget _allTeam() => _listWrapper(children: [
    _memberCard("Sophia Lee", "Level 2", active: true),
    _memberCard("David Kim", "Level 3", active: false),
    _memberCard("Emma Wilson", "Level 4", active: true),
    _memberCard("Mark Taylor", "Level 5", active: true),
  ]);

  Widget _inactiveTeam() => _listWrapper(children: [
    _memberCard("James Bond", "Inactive since: 10 Sep 2025", active: false),
    _memberCard("Sarah Connor", "Inactive since: 02 Sep 2025", active: false),
  ]);

  Widget _treeView() {
    return Container(
      decoration: BoxDecoration(
        gradient: CustColors.treeBackground
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _treeNode("You", active: true),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _treeNode("John", active: true),
                  _treeNode("Alice", active: true),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _treeNode("Robert", active: false),
                  _treeNode("Sophia", active: true),
                  _treeNode("David", active: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listWrapper({required List<Widget> children}) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: children,
    );
  }

  Widget _memberCard(String name, String subtitle, {bool active = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: active
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          child: Icon(
            active ? Iconsax.user : Iconsax.user_remove,
            color: active ? Colors.green : Colors.red,
            size: 28,
          ),
        ),
        title: Text(name,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xff1f3f3f))),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        trailing: Icon(Iconsax.arrow_right_3,
            color: Colors.grey.shade400, size: 20),
        onTap: () {},
      ),
    );
  }

  Widget _treeNode(String name, {bool active = true}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: active ? Colors.green.shade200 : Colors.red.shade200,
          child: Icon(
            Iconsax.user,
            color: active ? Colors.green : Colors.red,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(name,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1f3f3f))),
      ],
    );
  }
}
