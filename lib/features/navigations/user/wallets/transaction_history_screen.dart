import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';



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

        if (sDate != null && eDate == null) {
          return tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate);
        }

        if (sDate == null && eDate != null) {
          return tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate);
        }

        if (sDate != null && eDate != null) {
          return (tDate.isAtSameMomentAs(sDate) || tDate.isAfter(sDate)) &&
              (tDate.isAtSameMomentAs(eDate) || tDate.isBefore(eDate));
        }

        return true;
      }).toList();
    });
  }




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
                    ...items.map((tx) => _transactionItem(data: tx)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Your Transaction Tile ----------
  // Widget _transactionItem({required WalletTransaction data}) {
  //   final isCredit = data.txnType.toLowerCase() == 'credit';
  //
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundColor:
  //       isCredit ? Colors.green.shade100 : Colors.red.shade100,
  //       child: Icon(
  //         isCredit ? Icons.arrow_downward : Icons.arrow_upward,
  //         color: isCredit ? Colors.green : Colors.red,
  //       ),
  //     ),
  //     title: Text(
  //       data.source,
  //       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  //     ),
  //     subtitle: Text(
  //       data.formattedDate,
  //       style: const TextStyle(fontSize: 12),
  //     ),
  //     trailing: Text(
  //       '${isCredit ? '+' : '-'}${data.amount}',
  //       style: TextStyle(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w600,
  //         color: isCredit ? Colors.green : Colors.red,
  //       ),
  //     ),
  //   );
  // }

  Widget _transactionItem({
    required WalletTransaction data
  }) {
    final isCredit = data.txnType.toLowerCase() == 'credit';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCredit ? Colors.green.withValues(alpha: 0.1):Colors.red.withValues(alpha: 0.1),
        child: Icon(
          isCredit ? Iconsax.received : Iconsax.send,
          color: isCredit ? Colors.green:Colors.red,
        ),
      ),
      title: Text(data.source,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(data.formattedDate, style: const TextStyle(fontSize: 12)),
      trailing: Text('${isCredit ? '+' : '-'}'+'${data.amount}',
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: isCredit ? Colors.green:Colors.red,)
      ),
    );
  }
}
