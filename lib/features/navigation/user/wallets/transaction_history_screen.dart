import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_item.dart';



class TransactionHistoryScreen extends StatefulWidget {
  final List<WalletTransaction> transactions;

  const TransactionHistoryScreen({super.key, required this.transactions});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? statusFilter = "All"; // All, pending, success, failed


  List<WalletTransaction> filtered = [];

  @override
  void initState() {
    super.initState();
    filtered = [...widget.transactions];
  }

  void applyFilter() {
    DateTime toOnlyDate(DateTime d) => DateTime(d.year, d.month, d.day);

    setState(() {
      filtered = widget.transactions.where((t) {
        final tDate = toOnlyDate(t.createdAt);
        final sDate = startDate != null ? toOnlyDate(startDate!) : null;
        final eDate = endDate != null ? toOnlyDate(endDate!) : null;

        // --- DATE FILTER ---
        bool dateOk = true;

        if (sDate != null && eDate == null) {
          dateOk = tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate);
        }

        if (sDate == null && eDate != null) {
          dateOk = tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate);
        }

        if (sDate != null && eDate != null) {
          dateOk = (tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate)) &&
              (tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate));
        }

        // --- STATUS FILTER ---
        bool statusOk = true;

        if (statusFilter != null && statusFilter != "All") {
          statusOk = t.confirmation.toLowerCase() == statusFilter!.toLowerCase();
        }

        return dateOk && statusOk;
      }).toList();
    });
  }


  // void applyFilter() {
  //   DateTime toOnlyDate(DateTime d) => DateTime(d.year, d.month, d.day);
  //   setState(() {
  //     filtered = widget.transactions.where((t) {
  //       final tDate = toOnlyDate(t.createdAt);
  //       final sDate = startDate != null ? toOnlyDate(startDate!) : null;
  //       final eDate = endDate != null ? toOnlyDate(endDate!) : null;
  //
  //       if (sDate != null && eDate == null) {
  //         return tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate);
  //       }
  //
  //       if (sDate == null && eDate != null) {
  //         return tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate);
  //       }
  //
  //       if (sDate != null && eDate != null) {
  //         return (tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate)) &&
  //             (tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate));
  //       }
  //
  //       return true;
  //     }).toList();
  //   });
  // }




  Map<String, List<WalletTransaction>> groupByMonth(List<WalletTransaction> list) {
    Map<String, List<WalletTransaction>> map = {};

    for (var t in list) {
      String key = DateFormat("MMMM yyyy").format(t.createdAt);
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }

    return map;
  }



  @override
  Widget build(BuildContext context) {
    final grouped = groupByMonth(filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
      ),
      body: Column(
        children: [

          // ---------------- FILTER SECTION ----------------
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // FILTER TITLE + RESET BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filter by Date",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    TextButton(
                      onPressed: () {
                        startDate = null;
                        endDate = null;

                        setState(() {
                          filtered = [...widget.transactions];
                        });
                      },
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 10),

                Row(
                  children: [
                    // START DATE
                    Expanded(
                      child: CustomDatePickerTextField(
                          label: "Start Date",
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDate: startDate,
                          onChanged: (date) async {
                            startDate = date;
                            setState(() {});
                            applyFilter();
                          }),
                    ),

                    const SizedBox(width: 12),

                    // END DATE
                    Expanded(
                      child: CustomDatePickerTextField(
                          label: "End Date",
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          initialDate: endDate,
                          onChanged: (date) async {
                            endDate = date;
                            setState(() {});
                            applyFilter();
                          }),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                CustomDropdown<String?>(
                    label: 'Status',
                    items: [
                      DropdownMenuItem(value: "All", child: Text("All")),
                      DropdownMenuItem(value: "pending", child: Text("Pending")),
                      DropdownMenuItem(value: "success", child: Text("Success")),
                      DropdownMenuItem(value: "failed", child: Text("Failed")),
                    ],
                    value: statusFilter,
                    onChanged: (value) {
                      statusFilter = value;
                      if(statusFilter == null) return;
                      applyFilter();
                    },
                ),

              ],
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: grouped.isEmpty
                ? const Center(child: Text("No transactions found"))
                : ListView(
              children: grouped.keys.map((month) {
                final items = grouped[month]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Month Header ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        month,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // --- Transactions under that month ---
                    ...items.map((tx) => TransactionItem(data: tx)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


}
