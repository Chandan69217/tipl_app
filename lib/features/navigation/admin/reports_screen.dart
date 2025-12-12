// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:tipl_app/core/widgets/custom_card.dart';
//
//
// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Reports & Analytics",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//
//           // Filters Row
//           Row(
//             children: [
//               Expanded(
//                 child: DropdownButtonFormField<String>(
//                   value: "Monthly",
//                   items: ["Daily", "Weekly", "Monthly", "Yearly"]
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (val) {},
//                   decoration: InputDecoration(
//                     labelText: "Report Type",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: DropdownButtonFormField<String>(
//                   value: "2025",
//                   items: ["2023", "2024", "2025"]
//                       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                       .toList(),
//                   onChanged: (val) {},
//                   decoration: InputDecoration(
//                     labelText: "Year",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           // Income vs Withdrawal Chart
//           _chartCard(
//             title: "Income vs Withdrawals",
//             child: SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   barTouchData: BarTouchData(enabled: true),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (val, meta) {
//                           final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
//                           return Text(months[val.toInt() % months.length]);
//                         },
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: List.generate(6, (i) {
//                     return BarChartGroupData(x: i, barRods: [
//                       BarChartRodData(toY: (i + 1) * 5.0, color: Colors.blue, width: 12),
//                       BarChartRodData(toY: (i + 1) * 3.0, color: Colors.orange, width: 12),
//                     ]);
//                   }),
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Pie Chart for Active vs Inactive
//           _chartCard(
//             title: "Active vs Inactive Consumers",
//             child: SizedBox(
//               height: 200,
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                         value: 70, color: Colors.green, title: "Active"),
//                     PieChartSectionData(
//                         value: 30, color: Colors.red, title: "Inactive"),
//                   ],
//                   centerSpaceRadius: 40,
//                   sectionsSpace: 4,
//                 ),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 24),
//
//           // Report Summary Stats
//           const Text(
//             "Summary",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//           _summaryTile(Iconsax.money, "Total Income", "₹ 15,40,000", Colors.purple),
//           _summaryTile(Iconsax.wallet, "Total Withdrawals", "₹ 8,20,000", Colors.orange),
//           _summaryTile(Iconsax.user, "Total Consumers", "1200", Colors.blue),
//         ],
//       ),
//     );
//   }
//
//   Widget _chartCard({required String title, required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87)),
//           const SizedBox(height: 12),
//           child,
//         ],
//       ),
//     );
//   }
//
//   Widget _summaryTile(IconData icon, String title, String value, Color color) {
//     return CustomCard(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: color.withOpacity(0.15),
//             child: Icon(icon, color: color),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(title,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w600, fontSize: 14)),
//           ),
//           Text(value,
//               style: const TextStyle(
//                   fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/widgets/custom_card.dart';
import 'package:tipl_app/core/providers/income_provider/income_provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_transactions_provider.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/features/navigation/admin/manage_users/user_details_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});


  List<int> getAllYears(Map<int, double> income, Map<int, double> withdrawals) {
    final set = {...income.keys, ...withdrawals.keys};
    final list = set.toList();
    list.sort();
    return list;
  }



  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reports & Analytics",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // ---------------- FILTERS ----------------

          // Row(
          //   children: [
          //     Expanded(
          //       child: CustomDropdown<String>(
          //           label: 'Report Type',
          //           items: ["Daily", "Weekly", "Monthly", "Yearly"]
          //               .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          //               .toList(),
          //           value: 'Monthly',
          //           onChanged: (val) {}
          //       )
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: CustomDropdown<String>(
          //         value: "2025",
          //         label: 'Year',
          //         items: ["2023", "2024", "2025"]
          //             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          //             .toList(),
          //         onChanged: (val) {},
          //       ),
          //     ),
          //   ],
          // ),

          // const SizedBox(height: 24),

          // ---------------- INCOME vs WITHDRAWALS (REAL DATA) ----------------
          // Consumer2<IncomeProvider, WalletProvider>(
          //   builder: (context, incomeProvider, walletProvider, child) {
          //
          //
          //     return _chartCard(
          //       title: "Income vs Withdrawals",
          //       child: SizedBox(
          //         height: 220,
          //         child: BarChart(
          //           BarChartData(
          //             borderData: FlBorderData(show: false),
          //             barGroups: [
          //               BarChartGroupData(
          //                 x: 1,
          //                 barRods: [
          //                   BarChartRodData(
          //                     toY: incomeProvider.totalAllIncome,
          //                     width: 22,
          //                     color: Colors.green,
          //                   ),
          //                 ],
          //               ),
          //               BarChartGroupData(
          //                 x: 2,
          //                 barRods: [
          //                   BarChartRodData(
          //                     toY: walletProvider.totalWithdrawal,
          //                     width: 22,
          //                     color: Colors.red,
          //                   ),
          //                 ],
          //               ),
          //             ],
          //             titlesData: FlTitlesData(
          //               bottomTitles: AxisTitles(
          //                 sideTitles: SideTitles(
          //                   showTitles: true,
          //                   getTitlesWidget: (value, meta) {
          //                     if (value == 1) return const Text("Income");
          //                     if (value == 2) return const Text("Withdrawals");
          //                     return const Text("");
          //                   },
          //                 ),
          //               ),
          //               leftTitles: AxisTitles(
          //                 sideTitles: SideTitles(showTitles: true),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),

          Consumer2<IncomeProvider, WalletProvider>(
            builder: (context, incomeProvider, walletProvider, child) {

              final incomeMap = incomeProvider.yearlyIncome;
              final withdrawMap = walletProvider.yearlyWithdrawals;

              final years = getAllYears(incomeMap, withdrawMap);

              return _chartCard(
                title: "Year-wise Income vs Withdrawals",
                child: SizedBox(
                  height: 260,
                  child: BarChart(
                    BarChartData(
                      barGroups: years.map((year) {
                        final income = incomeMap[year] ?? 0;
                        final withdraw = withdrawMap[year] ?? 0;

                        return BarChartGroupData(
                          x: year,
                          barRods: [
                            BarChartRodData(
                              toY: income,
                              width: 15,
                              color: Colors.green,
                            ),
                            BarChartRodData(
                              toY: withdraw,
                              width: 15,
                              color: Colors.red,
                            ),
                          ],
                        );
                      }).toList(),

                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                Text(value.toInt().toString(), style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false,),
                        ),
                      ),

                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ---------------- ACTIVE vs INACTIVE USERS ----------------
          Consumer<AllUserDetailsProvider>(
            builder: (context,value,child){
              return _chartCard(
                title: "Active vs Inactive Users",
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 40,
                      sectionsSpace: 4,
                      sections: [
                        PieChartSectionData(
                          value: value.activeUser.toDouble(),
                          color: Colors.blue,
                          title: "Active",
                          radius: 54,
                        ),
                        PieChartSectionData(
                          value: value.inactiveUser.toDouble(),
                          color: Colors.red,
                          title: "Inactive",
                          radius: 54,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ---------------- SUMMARY ----------------
          const Text(
            "Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Consumer3<AllUserDetailsProvider, WalletProvider,IncomeProvider>(
            builder: (context, userProvider, transactionsProvider,incomeProvider ,child) {

              // USERS COUNT
              final usersCount = userProvider.users.length;

              return Column(
                children: [
                  _summaryTile(
                    Iconsax.money,
                    "Total Income",
                    "₹ ${incomeProvider.totalAllIncome.toStringAsFixed(2)}",
                    Colors.green,
                  ),

                  _summaryTile(
                    Iconsax.wallet,
                    "Total Withdrawals",
                    "₹ ${transactionsProvider.totalWithdrawal.toStringAsFixed(2)}",
                    Colors.red,
                  ),

                  _summaryTile(
                    Iconsax.user,
                    "Total Consumers",
                    "$usersCount",
                    Colors.blue,
                  ),
                ],
              );
            },
          )

        ],
      ),
    );
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _summaryTile(
      IconData icon, String title, String value, Color color) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black)),
        ],
      ),
    );
  }
}
