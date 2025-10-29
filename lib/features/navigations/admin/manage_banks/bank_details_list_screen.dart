import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';

import 'bank_details_view_screen.dart';

// class BankDetailsListScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> bankDetails;
//
//   const BankDetailsListScreen({super.key, required this.bankDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("All Banks"),
//       ),
//       body: bankDetails.isEmpty
//           ? const Center(
//         child: Text(
//           "No Bank Details Found",
//           style: TextStyle(color: Colors.black54, fontSize: 16),
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: bankDetails.length,
//         itemBuilder: (context, index) {
//           final bank = bankDetails[index];
//           final createdAt = DateTime.tryParse(bank["createdAt"] ?? "");
//           final date = createdAt != null
//               ? DateFormat('dd MMM yyyy').format(createdAt)
//               : "-";
//
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // top accent
//                 Container(
//                   height: 5,
//                   decoration: const BoxDecoration(
//                     color: Colors.teal,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundColor: Colors.teal,
//                             radius: 18,
//                             child: Icon(Iconsax.bank, color: Colors.white, size: 18),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               bank["account_name"] ?? "N/A",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       _buildInfo(Iconsax.building_4, "Bank", bank["bank_name"]),
//                       _buildInfo(Iconsax.card, "Account No", bank["account_no"]),
//                       _buildInfo(Iconsax.code, "IFSC", bank["ifsc_code"]),
//                       const Divider(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Iconsax.calendar_1, size: 16, color: Colors.teal),
//                               const SizedBox(width: 5),
//                               Text(
//                                 date,
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.black54),
//                               ),
//                             ],
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       BankDetailsViewScreen(data: bank),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal.shade600,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 8),
//                             ),
//                             icon: const Icon(Iconsax.eye, size: 16),
//                             label: const Text("View", style: TextStyle(fontSize: 13)),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfo(IconData icon, String title, String? value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Colors.teal.shade400),
//           const SizedBox(width: 8),
//           Text(
//             "$title: ",
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value?.toString() ?? "N/A",
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w400,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class BankDetailsViewScreen extends StatelessWidget {
//   final Map<String, dynamic> data;
//
//   const BankDetailsViewScreen({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Bank Details")),
//       body: Center(child: Text(data["account_name"] ?? "N/A")),
//     );
//   }
// }



class BankDetailsListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> bankDetails;

  const BankDetailsListScreen({super.key, required this.bankDetails});

  @override
  State<BankDetailsListScreen> createState() => _BankDetailsListScreenState();
}

class _BankDetailsListScreenState extends State<BankDetailsListScreen> {
  late List<Map<String, dynamic>> filteredList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredList = widget.bankDetails;
  }

  void _filterBankDetails(String query) {
    final q = query.toLowerCase();
    setState(() {
      filteredList = widget.bankDetails.where((bank) {
        return (bank["account_name"] ?? "").toLowerCase().contains(q) ||
            (bank["bank_name"] ?? "").toLowerCase().contains(q) ||
            (bank["ifsc_code"] ?? "").toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("All Bank"),
      ),
      body: SafeArea(
        child: Column(
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
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
        
            // 🧾 Bank Details List
            Expanded(
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
        
                  return GestureDetector(
                    onTap: (){
                      navigateWithAnimation(context, BankDetailsViewScreen(data: bank));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Top Row (Account name + View)
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.teal,
                                        child: Icon(Iconsax.user,
                                            color: Colors.white, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          bank["account_name"] ?? "N/A",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    backgroundColor: Colors.teal.shade50,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
        
                            const SizedBox(height: 6),
        
                            // 🏦 Bank Name + IFSC + Account No
                            _infoRow(Iconsax.bank, "Bank", bank["bank_name"], Colors.blueAccent),
                            _infoRow(Iconsax.card, "A/c No", bank["account_no"], Colors.orange),
                            _infoRow(Iconsax.code, "IFSC", bank["ifsc_code"], Colors.purple),
        
                            const SizedBox(height: 4),
        
                            // 💼 Account Type Chip + Date
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                // TextButton.icon(
                                //   onPressed: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (_) =>
                                //             BankDetailsViewScreen(data: bank),
                                //       ),
                                //     );
                                //   },
                                //   icon: const Icon(Iconsax.eye, size: 16),
                                //   label: const Text("View"),
                                //   style: TextButton.styleFrom(
                                //     foregroundColor: Colors.teal.shade700,
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    const Icon(Iconsax.calendar_1,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      date,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
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

  Widget _infoRow(IconData icon, String label, String? value, Color color) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13.5,
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





// class BankDetailsListScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> bankDetails;
//
//   const BankDetailsListScreen({super.key, required this.bankDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     // Predefined color palette (you can customize)
//     final colorPalette = [
//       Colors.teal,
//       Colors.indigo,
//       Colors.deepOrange,
//       Colors.purple,
//       Colors.green,
//       Colors.blueGrey,
//     ];
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text("Bank Details"),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//         elevation: 2,
//       ),
//       body: bankDetails.isEmpty
//           ? const Center(
//         child: Text(
//           "No Bank Details Found",
//           style: TextStyle(color: Colors.black54, fontSize: 16),
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: bankDetails.length,
//         itemBuilder: (context, index) {
//           final bank = bankDetails[index];
//           final color = colorPalette[index % colorPalette.length];
//           final createdAt = DateTime.tryParse(bank["createdAt"] ?? "");
//           final date = createdAt != null
//               ? DateFormat('dd MMM yyyy').format(createdAt)
//               : "-";
//
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.15),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // top accent
//                 Container(
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(16),
//                       topRight: Radius.circular(16),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: color,
//                             radius: 18,
//                             child: const Icon(Iconsax.bank,
//                                 color: Colors.white, size: 18),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               bank["account_name"] ?? "N/A",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       _buildInfo(Iconsax.building_4, "Bank",
//                           bank["bank_name"], color),
//                       _buildInfo(
//                           Iconsax.card, "Account No", bank["account_no"], color),
//                       _buildInfo(Iconsax.code, "IFSC", bank["ifsc_code"], color),
//                       const Divider(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Iconsax.calendar_1,
//                                   size: 16, color: color),
//                               const SizedBox(width: 5),
//                               Text(
//                                 date,
//                                 style: const TextStyle(
//                                     fontSize: 12, color: Colors.black54),
//                               ),
//                             ],
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) =>
//                                       BankDetailsViewScreen(data: bank),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: color,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 8),
//                             ),
//                             icon: const Icon(Iconsax.eye, size: 16),
//                             label: const Text("View",
//                                 style: TextStyle(fontSize: 13)),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfo(IconData icon, String title, String? value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: color.withOpacity(0.8)),
//           const SizedBox(width: 8),
//           Text(
//             "$title: ",
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value?.toString() ?? "N/A",
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w400,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class BankDetailsViewScreen extends StatelessWidget {
//   final Map<String, dynamic> data;
//
//   const BankDetailsViewScreen({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Bank Details")),
//       body: Center(
//         child: Text(
//           data["account_name"] ?? "N/A",
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
