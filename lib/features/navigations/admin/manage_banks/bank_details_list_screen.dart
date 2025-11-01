import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/bank_service_api.dart';
import 'package:tipl_app/api_service/meeting_api/meeting_api_service.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

import 'bank_details_view_screen.dart';



class BankDetailsListScreen extends StatefulWidget {

  const BankDetailsListScreen({super.key,});

  @override
  State<BankDetailsListScreen> createState() => _BankDetailsListScreenState();
}

class _BankDetailsListScreenState extends State<BankDetailsListScreen> {
  List<dynamic> filteredList = [];
  List<dynamic> bankRecords = [];
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _isSelectionMode = false;
  Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      init();
    });
  }

  void init()async {
    setState(() {
      _isLoading = true;
    });
    bankRecords =  await BankServiceAPI(context: context).getAllBankRecords();
    if(bankRecords.isNotEmpty){
      filteredList = bankRecords;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _filterBankDetails(String query) {
    final q = query.toLowerCase();
    setState(() {
      filteredList = bankRecords.where((bank) {
        return (bank["account_name"] ?? "").toLowerCase().contains(q) ||
            (bank["bank_name"] ?? "").toLowerCase().contains(q) ||
            (bank["ifsc_code"] ?? "").toLowerCase().contains(q);
      }).toList();
    });
  }
  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _isSelectionMode = false;
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _onLongPress(String id) {
    setState(() {
      _isSelectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _clearSelection() async {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  void _deleteSelection() async{
    if(_selectedIds.isEmpty){
      SnackBarHelper.show(context, message: 'Select a bank from the list to continue.');
      return;
    }
    setState(() {
      _isDeleting = true;
    });

    final api = BankServiceAPI(context: context);

    await for(final deletedId in api.deleteBankRecords(_selectedIds)){
      if(deletedId != null){
        setState(() {
          bankRecords.removeWhere((e) => e["member_id"] == deletedId);
          filteredList.removeWhere((e) => e["member_id"] == deletedId);
        });
      }
    }
    setState(() {
      _isDeleting = false;
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
    title: _isSelectionMode
    ? Text("${_selectedIds.length} selected")
        : const Text("All Bank"),
    leading: _isSelectionMode
    ? IconButton(
    icon: const Icon(Icons.close),
    onPressed: _clearSelection,
    )
        : null,
    actions: _isSelectionMode
    ? [
    _isDeleting ? Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: CustomCircularIndicator(),
    ):IconButton(
    icon: Icon(Iconsax.trash,color: Colors.red,),
    onPressed: _deleteSelection),
    ]
        : [
          TextButton(onPressed: (){
            setState((){
              _isSelectionMode = true;
            });
          }, child: Text('Select')),
      const SizedBox(width: 16),
    ],
    ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: _filterBankDetails,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.search_normal, color: Colors.teal),
                  hintText: "Search bank, account or IFSC...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Text('All user banks',style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900
              ),),
            ),
            // 🧾 Bank Details List
            _isLoading ? CustomCircularIndicator() : Expanded(
              child: filteredList.isEmpty
                  ? const Center(
                child: Text(
                  "No Bank Details Found",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final bank = filteredList[index];
                  final createdAt = DateTime.tryParse(bank["createdAt"] ?? "");
                  final date = createdAt != null
                      ? DateFormat('dd MMM yyyy').format(createdAt)
                      : "-";

                  final member_id = bank["member_id"].toString();
                  final selected = _selectedIds.contains(member_id);

                  return GestureDetector(
                    onLongPress: () => _onLongPress(member_id),
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(member_id);
                      } else {
                        navigateWithAnimation(context, BankDetailsViewScreen(data: bank,));
                      }
                    },
                    child:AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? Colors.teal.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: selected ? Border.all(color: Colors.teal, width: 2) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.15),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.green,
                                              child: Icon(Iconsax.bank,
                                                  color: Colors.white, size: 16),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bank["bank_name"] ?? "N/A",
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 6,),
                                                  _infoRow(Iconsax.card,"A/c No", bank["account_no"], Colors.orange),
                                                  _infoRow(Iconsax.code, "IFSC", bank["ifsc_code"], Colors.purple),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (bank["account_type"] != null)
                                        Chip(
                                          label: Text(
                                            bank["account_type"].toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: Colors.teal.shade50,
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadiusGeometry.circular(30)
                                          ),
                                        ),
                                    ],
                                  ),
                              
                                  // const SizedBox(height: 8),
                                  //
                                  //
                                  // // const SizedBox(height: 4),
                                  //
                                  // // 💼 Account Type Chip + Date
                                  // Row(
                                  //   mainAxisAlignment:
                                  //   MainAxisAlignment.end,
                                  //   children: [
                                  //     // TextButton.icon(
                                  //     //   onPressed: () {
                                  //     //     Navigator.push(
                                  //     //       context,
                                  //     //       MaterialPageRoute(
                                  //     //         builder: (_) =>
                                  //     //             BankDetailsViewScreen(data: bank),
                                  //     //       ),
                                  //     //     );
                                  //     //   },
                                  //     //   icon: const Icon(Iconsax.eye, size: 16),
                                  //     //   label: const Text("View"),
                                  //     //   style: TextButton.styleFrom(
                                  //     //     foregroundColor: Colors.teal.shade700,
                                  //     //   ),
                                  //     // ),
                                  //     Row(
                                  //       children: [
                                  //         const Icon(Iconsax.calendar_1,
                                  //             size: 14, color: Colors.grey),
                                  //         const SizedBox(width: 4),
                                  //         Text(
                                  //           date,
                                  //           style: const TextStyle(
                                  //               fontSize: 12, color: Colors.grey),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            if (_isSelectionMode)
                              Padding(
                                padding: const EdgeInsets.only(right: 8,left: 8),
                                child: Icon(
                                  selected ? Icons.check_circle : Icons.circle_outlined,
                                  color: selected ? Colors.teal : Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData? icon, String? label, String? value, Color color) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(icon != null)
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  if(label != null)
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

