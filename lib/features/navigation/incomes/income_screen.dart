// import 'package:flutter/material.dart';
//
// class IncomeScreen extends StatelessWidget {
//   const IncomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> incomes = [
//       {"title": "Salary", "amount": 50000, "date": "2025-11-01"},
//       {"title": "Freelance Project", "amount": 15000, "date": "2025-10-25"},
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Incomes"),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.green,
//         icon: const Icon(Icons.add),
//         label: const Text("Add Income"),
//         onPressed: () {
//           // Navigate to add-income form (future)
//         },
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: ListView.builder(
//           itemCount: incomes.length,
//           itemBuilder: (context, index) {
//             final income = incomes[index];
//             return Card(
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               child: ListTile(
//                 leading: const Icon(Icons.attach_money, color: Colors.green),
//                 title: Text(
//                   income["title"],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text("Date: ${income["date"]}"),
//                 trailing: Text(
//                   "₹${income["amount"]}",
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class IncomeScreen extends StatefulWidget {
//   const IncomeScreen({super.key});
//
//   @override
//   State<IncomeScreen> createState() => _IncomeScreenState();
// }
//
// class _IncomeScreenState extends State<IncomeScreen>
//     with SingleTickerProviderStateMixin {
//
//   late TabController _tabController;
//
//   final List<String> tabs = [
//     "All",
//     "Direct",
//     "Level",
//     "Cashback",
//     "Matching",
//     "Daily",
//     "Salary",
//     "Rewards",
//   ];
//
//   /// ---------------- STATIC DATA ----------------
//   final List<Map<String, dynamic>> incomeData = [
//     {
//       "id": 1,
//       "income_type": "Direct",
//       "amount": 100,
//       "source_member_id": "NERUPL100020",
//       "createdAt": "2025-12-03T15:51:26.000Z",
//     },
//     {
//       "id": 2,
//       "income_type": "Level",
//       "amount": 150,
//       "source_member_id": "NERUPL100019",
//       "createdAt": "2025-12-03T15:29:10.000Z",
//     },
//     {
//       "id": 3,
//       "income_type": "Cashback",
//       "amount": 50,
//       "source_member_id": "NERUPL100018",
//       "createdAt": "2025-12-03T06:58:32.000Z",
//     },
//     {
//       "id": 4,
//       "income_type": "Matching",
//       "amount": 300,
//       "source_member_id": "NERUPL100017",
//       "createdAt": "2025-11-07T16:02:11.000Z",
//     },
//     {
//       "id": 5,
//       "income_type": "Daily",
//       "amount": 20,
//       "source_member_id": "SYSTEM",
//       "createdAt": "2025-12-04T08:45:11.000Z",
//     },
//     {
//       "id": 6,
//       "income_type": "Salary",
//       "amount": 5000,
//       "source_member_id": "COMPANY",
//       "createdAt": "2025-12-01T09:00:00.000Z",
//     },
//     {
//       "id": 7,
//       "income_type": "Rewards",
//       "amount": 1000,
//       "source_member_id": "ADMIN",
//       "createdAt": "2025-12-01T10:15:00.000Z",
//     },
//   ];
//
//   @override
//   void initState() {
//     _tabController = TabController(length: tabs.length, vsync: this);
//     super.initState();
//   }
//
//   /// Filter income by type
//   List<dynamic> filterIncome(String type) {
//     if (type == "All") return incomeData;
//     return incomeData
//         .where((item) =>
//     (item['income_type'] ?? '').toString().toLowerCase() ==
//         type.toLowerCase())
//         .toList();
//   }
//
//   /// Format date
//   String formatDate(String date) {
//     try {
//       final dt = DateTime.parse(date);
//       return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
//     } catch (_) {
//       return date;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//
//       /// ---------------- APP BAR ----------------
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "All Income",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//
//       /// ---------------- BODY ----------------
//       body: Column(
//         children: [
//           /// ---------- TAB BAR ----------
//           Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               labelColor: Colors.black,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.black,
//               indicatorWeight: 3,
//               tabs: tabs.map((e) => Tab(text: e)).toList(),
//             ),
//           ),
//
//           const SizedBox(height: 8),
//
//           /// ---------- TAB VIEW ----------
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: tabs.map((category) {
//                 final filteredList = filterIncome(category);
//
//                 if (filteredList.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "No income found",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   );
//                 }
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     final item = filteredList[index];
//
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 12),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 6,
//                             color: Colors.grey.shade300,
//                             offset: const Offset(0, 3),
//                           )
//                         ],
//                       ),
//
//                       /// ---------------- CARD ----------------
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           /// LEFT SECTION
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item["income_type"],
//                                 style: const TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//
//                               Text(
//                                 "From: ${item["source_member_id"]}",
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.grey.shade700),
//                               ),
//                               const SizedBox(height: 4),
//
//                               Text(
//                                 formatDate(item["createdAt"]),
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600),
//                               ),
//                             ],
//                           ),
//
//                           /// RIGHT SECTION
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.green.shade50,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               "₹${item["amount"]}",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class IncomeScreen extends StatefulWidget {
//   const IncomeScreen({super.key});
//
//   @override
//   State<IncomeScreen> createState() => _IncomeScreenState();
// }
//
// class _IncomeScreenState extends State<IncomeScreen> {
//   final List<String> categories = [
//     "All",
//     "Direct",
//     "Level",
//     "Cashback",
//     "Matching",
//     "Daily",
//     "Salary",
//     "Rewards",
//   ];
//
//   String selectedCategory = "All";
//
//   final List<Map<String, dynamic>> incomeData = [
//     {
//       "income_type": "Direct",
//       "amount": 100,
//       "source_member_id": "NERUPL100020",
//       "createdAt": "2025-12-03T15:51:26.000Z",
//     },
//     {
//       "income_type": "Level",
//       "amount": 150,
//       "source_member_id": "NERUPL100019",
//       "createdAt": "2025-12-03T15:29:10.000Z",
//     },
//     {
//       "income_type": "Cashback",
//       "amount": 50,
//       "source_member_id": "NERUPL100018",
//       "createdAt": "2025-12-03T06:58:32.000Z",
//     },
//     {
//       "income_type": "Rewards",
//       "amount": 800,
//       "source_member_id": "ADMIN",
//       "createdAt": "2025-12-03T02:15:32.000Z",
//     },
//   ];
//
//   String formatDate(String date) {
//     try {
//       final d = DateTime.parse(date);
//       return DateFormat("dd MMM yyyy, hh:mm a").format(d);
//     } catch (_) {
//       return date;
//     }
//   }
//
//   List<Map<String, dynamic>> get filteredIncome {
//     if (selectedCategory == "All") return incomeData;
//     return incomeData
//         .where((e) =>
//     e["income_type"].toString().toLowerCase() ==
//         selectedCategory.toLowerCase())
//         .toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//
//       appBar: AppBar(
//         title: const Text(
//           "Income Summary",
//           style: TextStyle(
//               color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//
//       body: Row(
//         children: [
//           /// ---------------- LEFT CATEGORY PANEL ----------------
//           Container(
//             width: 120,
//             color: Colors.white,
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 final cat = categories[index];
//                 final bool selected = (cat == selectedCategory);
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() => selectedCategory = cat);
//                   },
//                   child: Container(
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//                     margin:
//                     const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: selected ? Colors.black : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       cat,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: selected ? Colors.white : Colors.black,
//                         fontWeight:
//                         selected ? FontWeight.w700 : FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           /// ---------------- RIGHT CONTENT AREA ----------------
//           Expanded(
//             child: filteredIncome.isEmpty
//                 ? const Center(
//               child: Text(
//                 "No income found",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: filteredIncome.length,
//               itemBuilder: (context, index) {
//                 final item = filteredIncome[index];
//
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(14),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 5,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//
//                   /// --------- CARD CONTENT ----------
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       /// LEFT SIDE
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             item["income_type"],
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//
//                           Text(
//                             "From: ${item["source_member_id"]}",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//
//                           Text(
//                             formatDate(item["createdAt"]),
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       /// RIGHT SIDE (amount)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 6, horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "₹${item["amount"]}",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class IncomeScreen extends StatefulWidget {
//   const IncomeScreen({super.key});
//
//   @override
//   State<IncomeScreen> createState() => _IncomeScreenState();
// }
//
// class _IncomeScreenState extends State<IncomeScreen>
//     with SingleTickerProviderStateMixin {
//   // ---------------- CATEGORIES ----------------
//   final List<Map<String, dynamic>> categories = [
//     {"name": "All", "icon": Icons.grid_view_rounded},
//     {"name": "Direct", "icon": Icons.person_add_alt},
//     {"name": "Level", "icon": Icons.stacked_line_chart},
//     {"name": "Cashback", "icon": Icons.wallet_giftcard},
//     {"name": "Matching", "icon": Icons.join_inner},
//     {"name": "Daily", "icon": Icons.calendar_today},
//     {"name": "Salary", "icon": Icons.payments},
//     {"name": "Rewards", "icon": Icons.card_giftcard},
//   ];
//
//   String selectedCategory = "All";
//   String searchQuery = "";
//   String selectedMonth = "All";
//
//   // ---------------- STATIC INCOME DATA ----------------
//   final List<Map<String, dynamic>> incomeData = [
//     {
//       "income_type": "Direct",
//       "amount": 100,
//       "source_member_id": "NERUPL100020",
//       "createdAt": "2025-12-03T15:51:26.000Z",
//     },
//     {
//       "income_type": "Level",
//       "amount": 150,
//       "source_member_id": "NERUPL100019",
//       "createdAt": "2025-11-03T15:29:10.000Z",
//     },
//     {
//       "income_type": "Rewards",
//       "amount": 800,
//       "source_member_id": "ADMIN",
//       "createdAt": "2025-10-03T02:15:32.000Z",
//     },
//     {
//       "income_type": "Cashback",
//       "amount": 40,
//       "source_member_id": "SYSTEM",
//       "createdAt": "2025-12-01T12:40:32.000Z",
//     },
//   ];
//
//   // ---------------- MONTHS ----------------
//   final List<String> months = [
//     "All",
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December"
//   ];
//
//   // ---------------- FILTERING ----------------
//   List<Map<String, dynamic>> get filteredData {
//     List<Map<String, dynamic>> temp = incomeData;
//
//     // Category filter
//     if (selectedCategory != "All") {
//       temp = temp
//           .where((e) =>
//       e["income_type"].toString().toLowerCase() ==
//           selectedCategory.toLowerCase())
//           .toList();
//     }
//
//     // Month filter
//     if (selectedMonth != "All") {
//       temp = temp.where((e) {
//         DateTime d = DateTime.parse(e["createdAt"]);
//         return months[d.month] == selectedMonth;
//       }).toList();
//     }
//
//     // Search filter
//     if (searchQuery.isNotEmpty) {
//       temp = temp.where((e) {
//         return e["source_member_id"]
//             .toString()
//             .toLowerCase()
//             .contains(searchQuery.toLowerCase()) ||
//             e["income_type"]
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchQuery.toLowerCase());
//       }).toList();
//     }
//
//     return temp;
//   }
//
//   // ---------------- FORMAT DATE ----------------
//   String formatDate(String value) {
//     final dt = DateTime.parse(value);
//     return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
//   }
//
//   // ---------------- BUILD UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//
//       appBar: AppBar(
//         title: const Text(
//           "Income Summary",
//           style: TextStyle(
//               fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 1,
//       ),
//
//       body: Row(
//         children: [
//           // ---------------- LEFT CATEGORY PANEL ----------------
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             width: 110,
//             color: Colors.white,
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 final cat = categories[index];
//                 final bool selected = cat["name"] == selectedCategory;
//
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedCategory = cat["name"];
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: selected ? Colors.black : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(12),
//                       border: selected
//                           ? Border.all(color: Colors.greenAccent, width: 2)
//                           : null,
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(
//                           cat["icon"],
//                           color: selected ? Colors.white : Colors.black,
//                           size: 22,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           cat["name"],
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: selected ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           // ---------------- RIGHT PANEL ----------------
//           Expanded(
//             child: Column(
//               children: [
//                 // SEARCH FIELD
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search income...",
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() => searchQuery = value);
//                     },
//                   ),
//                 ),
//
//                 // MONTH FILTER DROPDOWN
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: DropdownButtonFormField(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none),
//                     ),
//                     value: selectedMonth,
//                     items: months
//                         .map((m) =>
//                         DropdownMenuItem(value: m, child: Text(m)))
//                         .toList(),
//                     onChanged: (val) {
//                       setState(() => selectedMonth = val!);
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // INCOME LIST
//                 Expanded(
//                   child: filteredData.isEmpty
//                       ? const Center(
//                     child: Text(
//                       "No income found",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   )
//                       : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: filteredData.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredData[index];
//
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeOut,
//                         margin: const EdgeInsets.only(bottom: 12),
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade300,
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//
//                         child: Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                           children: [
//                             // LEFT SIDE
//                             Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item["income_type"],
//                                   style: const TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 4),
//
//                                 Text(
//                                   "From: ${item["source_member_id"]}",
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey.shade700),
//                                 ),
//
//                                 const SizedBox(height: 4),
//
//                                 Text(
//                                   formatDate(item["createdAt"]),
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade600),
//                                 ),
//                               ],
//                             ),
//
//                             // RIGHT SIDE → AMOUNT
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 6, horizontal: 12),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 "₹${item["amount"]}",
//                                 style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class IncomeScreen extends StatefulWidget {
//   const IncomeScreen({super.key});
//
//   @override
//   State<IncomeScreen> createState() => _IncomeScreenState();
// }
//
// class _IncomeScreenState extends State<IncomeScreen> {
//   // ---------------- CATEGORIES ----------------
//   final List<Map<String, dynamic>> categories = [
//     {"name": "All", "icon": Icons.grid_view_rounded},
//     {"name": "Direct", "icon": Icons.person_add_alt},
//     {"name": "Level", "icon": Icons.stacked_line_chart},
//     {"name": "Cashback", "icon": Icons.wallet_giftcard},
//     {"name": "Matching", "icon": Icons.join_inner},
//     {"name": "Daily", "icon": Icons.calendar_today},
//     {"name": "Salary", "icon": Icons.payments},
//     {"name": "Rewards", "icon": Icons.card_giftcard},
//   ];
//
//   String selectedCategory = "All";
//   String searchQuery = "";
//   String selectedMonth = "All";
//
//   // ---------------- STATIC INCOME DATA ----------------
//   final List<Map<String, dynamic>> incomeData = [
//     {
//       "income_type": "Direct",
//       "amount": 100,
//       "source_member_id": "NERUPL100020",
//       "createdAt": "2025-12-03T15:51:26.000Z",
//     },
//     {
//       "income_type": "Level",
//       "amount": 150,
//       "source_member_id": "NERUPL100019",
//       "createdAt": "2025-11-03T15:29:10.000Z",
//     },
//     {
//       "income_type": "Rewards",
//       "amount": 800,
//       "source_member_id": "ADMIN",
//       "createdAt": "2025-10-03T02:15:32.000Z",
//     },
//     {
//       "income_type": "Cashback",
//       "amount": 40,
//       "source_member_id": "SYSTEM",
//       "createdAt": "2025-12-01T12:40:32.000Z",
//     },
//   ];
//
//   String getMemberName(String id) {
//     Map<String, String> members = {
//       "NERUPL100020": "Rahul Sharma",
//       "NERUPL100019": "Amit Kumar",
//       "NERUPL100018": "Suman Gupta",
//       "NERUPL100017": "Rohit Singh",
//       "SYSTEM": "System Generated",
//       "COMPANY": "Company",
//       "ADMIN": "Admin",
//     };
//
//     return members[id] ?? "Unknown Member";
//   }
//
//
//   // ---------------- MONTHS LIST ----------------
//   final List<String> months = [
//     "All",
//     "January",
//     "February",
//     "March",
//     "April",
//     "May",
//     "June",
//     "July",
//     "August",
//     "September",
//     "October",
//     "November",
//     "December"
//   ];
//
//   // -------------- TOTAL INCOME FOR CATEGORY --------------
//   double getCategoryTotal(String category) {
//     if (category == "All") {
//       return incomeData.fold(0.0, (sum, e) => sum + (e["amount"] as num));
//     }
//
//     return incomeData
//         .where((e) =>
//     e["income_type"].toString().toLowerCase() ==
//         category.toLowerCase())
//         .fold(0.0, (sum, e) => sum + (e["amount"] as num));
//   }
//
//   // ---------------- FILTERED LIST ----------------
//   List<Map<String, dynamic>> get filteredData {
//     List<Map<String, dynamic>> temp = incomeData;
//
//     if (selectedCategory != "All") {
//       temp = temp
//           .where((e) =>
//       e["income_type"].toString().toLowerCase() ==
//           selectedCategory.toLowerCase())
//           .toList();
//     }
//
//     if (selectedMonth != "All") {
//       temp = temp.where((e) {
//         DateTime d = DateTime.parse(e["createdAt"]);
//         return months[d.month] == selectedMonth;
//       }).toList();
//     }
//
//     if (searchQuery.isNotEmpty) {
//       temp = temp.where((e) {
//         return e["source_member_id"]
//             .toString()
//             .toLowerCase()
//             .contains(searchQuery.toLowerCase()) ||
//             e["income_type"]
//                 .toString()
//                 .toLowerCase()
//                 .contains(searchQuery.toLowerCase());
//       }).toList();
//     }
//
//     return temp;
//   }
//
//   // ---------------- FORMAT DATE ----------------
//   String formatDate(String value) {
//     final dt = DateTime.parse(value);
//     return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
//   }
//
//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     final totalIncome = getCategoryTotal(selectedCategory);
//
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       // appBar: AppBar(
//       //   title: const Text(
//       //     "Income Summary",
//       //   ),
//       // ),
//       appBar: AppBar(
//         title: const Text("Income Summary"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => IncomeSearchScreen(incomeData)),
//               );
//             },
//           ),
//         ],
//       ),
//
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ---------------- CATEGORY HORIZONTAL BAR ----------------
//           Container(
//             margin: EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.1),
//                   offset: Offset(0, 4),
//                   blurRadius: 20,
//                   spreadRadius: 6
//                 )
//               ],
//               color: Colors.white,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 12,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0,),
//                   child: const Text('Income Categories',
//                     style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 const SizedBox(height: 4.0,),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.width*0.55,
//                   child: GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                     itemCount: categories.length,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final cat = categories[index];
//                       final bool selected = cat["name"] == selectedCategory;
//
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() => selectedCategory = cat["name"]);
//                         },
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           margin: const EdgeInsets.only(right: 12),
//                           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//                           decoration: BoxDecoration(
//                             gradient: selected
//                                 ? LinearGradient(
//                               colors: [Colors.blueAccent, Colors.lightBlue],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             )
//                                 : LinearGradient(
//                               colors: [Colors.grey.shade200, Colors.grey.shade300],
//                             ),
//                             borderRadius: BorderRadius.circular(14),
//                             border: selected
//                                 ? Border.all(color: Colors.white, width: 2)
//                                 : null,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(cat["icon"],
//                                   size: 22, color: selected ? Colors.white : Colors.black),
//                               const SizedBox(height: 6),
//                               Text(
//                                 cat["name"],
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     color: selected ? Colors.white : Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 4,
//                       crossAxisSpacing: 0.0,
//                       mainAxisSpacing: 8.0,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // ---------------- TOTAL INCOME CARD ----------------
//           const SizedBox(height: 10,),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.deepPurple, Colors.purpleAccent],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//               ),
//
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Total Income",
//                     style: TextStyle(color: Colors.white, fontSize: 14),
//                   ),
//                   Text(
//                     "₹$totalIncome",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // const SizedBox(height: 10),
//
//           // ---------------- MONTH DROPDOWN ----------------
//           // Padding(
//           //   padding: const EdgeInsets.symmetric(horizontal: 12),
//           //   child: DropdownButtonFormField(
//           //     decoration: InputDecoration(
//           //       filled: true,
//           //       fillColor: Colors.white,
//           //       contentPadding:
//           //       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           //       border: OutlineInputBorder(
//           //         borderRadius: BorderRadius.circular(12),
//           //         borderSide: BorderSide.none,
//           //       ),
//           //     ),
//           //     value: selectedMonth,
//           //     items: months
//           //         .map((m) => DropdownMenuItem(value: m, child: Text(m)))
//           //         .toList(),
//           //     onChanged: (value) {
//           //       setState(() => selectedMonth = value!);
//           //     },
//           //   ),
//           // ),
//
//           const SizedBox(height: 10),
//
//           // ---------------- INCOME LIST ----------------
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Text(
//               selectedCategory == "All"
//                   ? "All Income List"
//                   : "${selectedCategory} Income List",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           Expanded(
//             child: filteredData.isEmpty
//                 ? const Center(
//               child: Text(
//                 "No income found",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: filteredData.length,
//               itemBuilder: (context, index) {
//                 final item = filteredData[index];
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeOut,
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.05),
//                         blurRadius: 12,
//                         spreadRadius: 2,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                     border: Border(
//                       left: BorderSide(
//                         color: Colors.green.shade400,
//                         width: 6,
//                       ),
//                     ),
//                   ),
//
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // ICON CIRCLE
//                       Container(
//                         height: 46,
//                         width: 46,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [Colors.green.shade400, Colors.green.shade600],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                         child: const Icon(Icons.trending_up, color: Colors.white, size: 22),
//                       ),
//
//                       const SizedBox(width: 14),
//
//                       // TEXTS (LEFT SIDE)
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // INCOME TYPE
//                             Text(
//                               item["income_type"],
//                               style: const TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 0.2,
//                               ),
//                             ),
//
//                             const SizedBox(height: 6),
//
//                             // MEMBER NAME + DATE
//                             Row(
//                               children: [
//                                 Icon(Icons.person, size: 14, color: Colors.grey.shade600),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   getMemberName(item['source_member_id']), // ← your fetched member name
//                                   style: TextStyle(
//                                     fontSize: 13,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                               ],
//                             ),
//
//                             const SizedBox(height: 4),
//
//                             Row(
//                               children: [
//                                 Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade500),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   formatDate(item["createdAt"]),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//
//                       // AMOUNT BADGE
//                       Container(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           "₹${item["amount"]}",
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w900,
//                             color: Colors.green.shade700,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//
//                 // return AnimatedContainer(
//                 //   duration: const Duration(milliseconds: 300),
//                 //   curve: Curves.easeOut,
//                 //   margin: const EdgeInsets.only(bottom: 12),
//                 //   padding: const EdgeInsets.all(14),
//                 //   decoration: BoxDecoration(
//                 //     color: Colors.white,
//                 //     borderRadius: BorderRadius.circular(14),
//                 //     boxShadow: [
//                 //       BoxShadow(
//                 //           color: Colors.grey.shade300,
//                 //           blurRadius: 6,
//                 //           offset: const Offset(0, 3)),
//                 //     ],
//                 //   ),
//                 //
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       // LEFT DETAILS
//                 //       Column(
//                 //         crossAxisAlignment: CrossAxisAlignment.start,
//                 //         children: [
//                 //           Text(
//                 //             item["income_type"],
//                 //             style: const TextStyle(
//                 //                 fontSize: 15,
//                 //                 fontWeight: FontWeight.bold),
//                 //           ),
//                 //           const SizedBox(height: 4),
//                 //           Text(
//                 //             "From: ${item["source_member_id"]}",
//                 //             style: TextStyle(
//                 //                 fontSize: 13,
//                 //                 color: Colors.grey.shade700),
//                 //           ),
//                 //           const SizedBox(height: 4),
//                 //           Text(
//                 //             formatDate(item["createdAt"]),
//                 //             style: TextStyle(
//                 //                 fontSize: 12,
//                 //                 color: Colors.grey.shade600),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //
//                 //       // AMOUNT BADGE
//                 //       Container(
//                 //         padding: const EdgeInsets.symmetric(
//                 //             vertical: 6, horizontal: 12),
//                 //         decoration: BoxDecoration(
//                 //           color: Colors.green.shade50,
//                 //           borderRadius: BorderRadius.circular(12),
//                 //         ),
//                 //         child: Text(
//                 //           "₹${item["amount"]}",
//                 //           style: const TextStyle(
//                 //               fontSize: 16,
//                 //               color: Colors.green,
//                 //               fontWeight: FontWeight.bold),
//                 //         ),
//                 //       )
//                 //     ],
//                 //   ),
//                 // );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class IncomeSearchScreen extends StatefulWidget {
//   final List<Map<String, dynamic>> incomeList;
//   const IncomeSearchScreen(this.incomeList, {super.key});
//
//   @override
//   State<IncomeSearchScreen> createState() => _IncomeSearchScreenState();
// }
//
// class _IncomeSearchScreenState extends State<IncomeSearchScreen> {
//   String query = "";
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> results = widget.incomeList.where((item) {
//       return item["income_type"].toString().toLowerCase().contains(query.toLowerCase()) ||
//           item["source_member_id"].toString().toLowerCase().contains(query.toLowerCase());
//     }).toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           autofocus: true,
//           decoration: const InputDecoration(
//             hintText: "Search...",
//             border: InputBorder.none,
//           ),
//           onChanged: (value) => setState(() => query = value),
//         ),
//       ),
//
//       body: results.isEmpty
//           ? const Center(
//         child: Text(
//           "No results found",
//           style: TextStyle(color: Colors.grey),
//         ),
//       )
//           : ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           final item = results[index];
//
//           return ListTile(
//             leading: const Icon(Icons.receipt_long),
//             title: Text(item["income_type"]),
//             subtitle: Text(item["source_member_id"]),
//             trailing: Text(
//               "₹${item['amount']}",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/providers/income_provider/income_provider.dart';
import 'package:tipl_app/core/models/income_model.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // ---------------- CATEGORIES ----------------
  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.grid_view_rounded},
    {"name": "Direct", "icon": Icons.person_add_alt},
    {"name": "Level", "icon": Icons.stacked_line_chart},
    {"name": "Cashback", "icon": Icons.wallet_giftcard},
    {"name": "Matching", "icon": Icons.join_inner},
    {"name": "Daily", "icon": Icons.calendar_today},
    {"name": "Salary", "icon": Icons.payments},
    {"name": "Rewards", "icon": Icons.card_giftcard},
  ];

  String selectedCategory = "All";
  String searchQuery = "";

  // ---------------- NAME FETCHER ----------------
  Future<String> getMemberName(String id) async {
    final member = await ProfileAPIService().getProfileDetailsByMemberId(id: id);
    if(member != null){
      return member['full_name'] ?? "Member $id";
    }
   return 'N/A';
  }

  // ---------------- FILTER BASED ON CATEGORY ----------------
  List<IncomeModel> getDataByCategory(IncomeProvider provider) {
    switch (selectedCategory) {
      case "Direct":
        return provider.directIncome;
      case "Level":
        return provider.levelIncome;
      case "Cashback":
        return provider.cashbackIncome;
      case "Matching":
        return provider.matchingIncome;
      case "Daily":
        return provider.dailyIncome;
      case "Salary":
        return provider.salaryIncome;
      case "Rewards":
        return provider.rewardsIncome;
      case "All":
      default:
        return provider.allIncome;
    }
  }

  // ---------------- SEARCH FILTER ----------------
  List<IncomeModel> filterSearch(List<IncomeModel> list) {
    if (searchQuery.isEmpty) return list;

    return list.where((item) {
      return item.sourceMemberId.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.incomeType.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // ---------------- TOTAL ----------------
  double getTotal(List<IncomeModel> list) {
    return list.fold(0.0, (sum, e) => sum + e.amount);
  }

  bool showCategoryDial = false;


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IncomeProvider>(context);

    // LOADING STATE
    // if (provider.allIncome.isEmpty) {
    //   return const Scaffold(
    //     body: Center(child: CustomCircularIndicator()),
    //   );
    // }

    // Data according to category + search
    final filteredList = filterSearch(getDataByCategory(provider));
    final totalIncome = getTotal(filteredList);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Income Summary"),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //---------------- CATEGORY GRID ----------------
          // Container(
          //   margin: EdgeInsets.all(8.0),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20),
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //           color: Colors.black.withValues(alpha: 0.1),
          //           blurRadius: 20,
          //           offset: Offset(0, 6))
          //     ],
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       SizedBox(height: 12),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 16),
          //         child: const Text("Income Categories",
          //             style: TextStyle(
          //                 fontSize: 18, fontWeight: FontWeight.bold)),
          //       ),
          //       SizedBox(
          //         height: MediaQuery.of(context).size.width * 0.55,
          //         child: GridView.builder(
          //           padding: const EdgeInsets.all(10),
          //           physics: NeverScrollableScrollPhysics(),
          //           itemCount: categories.length,
          //           gridDelegate:
          //           SliverGridDelegateWithFixedCrossAxisCount(
          //             crossAxisCount: 4,
          //             mainAxisSpacing: 8,
          //             crossAxisSpacing: 8,
          //           ),
          //           itemBuilder: (_, i) {
          //             final cat = categories[i];
          //             final selected = cat["name"] == selectedCategory;
          //
          //             return GestureDetector(
          //               onTap: () {
          //                 setState(() => selectedCategory = cat["name"]);
          //               },
          //               child: AnimatedContainer(
          //                 duration: Duration(milliseconds: 300),
          //                 padding: EdgeInsets.all(12),
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(14),
          //                   gradient: selected
          //                       ? LinearGradient(
          //                     colors: [
          //                       Colors.blueAccent,
          //                       Colors.lightBlue
          //                     ],
          //                   )
          //                       : LinearGradient(
          //                     colors: [
          //                       Colors.grey.shade200,
          //                       Colors.grey.shade300
          //                     ],
          //                   ),
          //                 ),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Icon(cat["icon"],
          //                         color: selected
          //                             ? Colors.white
          //                             : Colors.black),
          //                     SizedBox(height: 6),
          //                     Text(cat["name"],
          //                         style: TextStyle(
          //                             fontSize: 12,
          //                             color: selected
          //                                 ? Colors.white
          //                                 : Colors.black)),
          //                   ],
          //                 ),
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),


          //---------------- SEARCH BAR ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by Member ID or Type",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),

          // const SizedBox(height: 10),

          //---------------- TOTAL CARD ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Income",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text("₹$totalIncome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          // SizedBox(height: 10),

          //---------------- LIST TITLE ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              selectedCategory == "All"
                  ? "All Income List"
                  : "${selectedCategory} Income",
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(height: 10),

          //---------------- LIST ----------------
          Expanded(
            child: filteredList.isEmpty
                ? Center(child: Text("No Income Found"))
                : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: filteredList.length,
              itemBuilder: (_, index) {
                final item = filteredList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(
                          color: Colors.green, width: 5),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    children: [
                      // ICON
                      Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade400,
                                  Colors.green.shade600
                                ])),
                        child: Icon(Icons.trending_up,
                            color: Colors.white),
                      ),

                      SizedBox(width: 14),

                      // DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: getMemberName(item.sourceMemberId),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    "Loading...",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  );
                                }

                                return Text(
                                  snapshot.data!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 4),
                            Text(item.incomeType,
                                style: TextStyle(color: Colors.grey ,fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text(
                              "${item.formattedCreatedDate} • ${item.formattedCreatedTime}",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                      // AMOUNT BADGE
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text("₹${item.amount}",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          // Dim background when open
          if (showCategoryDial)
            GestureDetector(
              onTap: () => setState(() => showCategoryDial = false),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.4),
              ),
            ),

          // GRID POPUP
          if (showCategoryDial)
            Positioned(
              bottom: 90,
              right: 20,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,   // 3 items per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected = cat['name'] == selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = cat['name'];
                            showCategoryDial = false; // close dial
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor:
                              selected ? Colors.blueAccent : Colors.grey.shade200,
                              child: Icon(
                                cat['icon'],
                                color: selected ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              cat['name'],
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

          // SPEED DIAL BUTTON
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  elevation: 8,
                  child: Icon(showCategoryDial ? Icons.close : Iconsax.category),
                  onPressed: () => setState(() => showCategoryDial = !showCategoryDial),
                ),
              ],
            )

          ),
        ],
      ),

      // floatingActionButton: Stack(
      //   children: [
      //     // Overlay when open
      //     if (showCategoryDial)
      //       GestureDetector(
      //         onTap: () => setState(() => showCategoryDial = false),
      //         child: Container(
      //           color: Colors.black.withOpacity(0.4),
      //           width: double.infinity,
      //           height: double.infinity,
      //         ),
      //       ),
      //
      //     // Speed Dial Button
      //     Align(
      //       alignment: Alignment.bottomRight,
      //       child: AnimatedContainer(
      //         duration: Duration(milliseconds: 250),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.end,
      //           children: [
      //             // EXPANDED MENU
      //             if (showCategoryDial)
      //               ...categories.map((cat) {
      //                 final selected = cat['name'] == selectedCategory;
      //
      //                 return Container(
      //                   margin: EdgeInsets.only(bottom: 8),
      //                   child: FloatingActionButton.extended(
      //                     heroTag: cat['name'],
      //                     backgroundColor:
      //                     selected ? Colors.blueAccent : Colors.grey.shade800,
      //                     label: Text(
      //                       cat['name'],
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                     icon: Icon(cat['icon'], color: Colors.white),
      //                     onPressed: () {
      //                       setState(() {
      //                         selectedCategory = cat["name"];
      //                         showCategoryDial = false; // CLOSE DIAL
      //                       });
      //                     },
      //                   ),
      //                 );
      //               }).toList(),
      //
      //             // MAIN BUTTON
      //             FloatingActionButton(
      //               backgroundColor: Colors.blueAccent,
      //               child: Icon(
      //                 showCategoryDial ? Icons.close : Icons.category,
      //                 size: 28,
      //               ),
      //               onPressed: () {
      //                 setState(() => showCategoryDial = !showCategoryDial);
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
