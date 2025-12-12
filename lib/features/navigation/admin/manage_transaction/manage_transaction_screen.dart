import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/providers/admin_provider/all_transactions_provider.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_item.dart';

class AllUserTransactionsScreen extends StatefulWidget {
  const AllUserTransactionsScreen({super.key});

  @override
  State<AllUserTransactionsScreen> createState() =>
      _AllUserTransactionsScreenState();
}

class _AllUserTransactionsScreenState extends State<AllUserTransactionsScreen> {
  List<WalletTransaction> filtered = [];

  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = "";
  String statusFilter = "All";

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<AllTransactionsProvider>(
      context,
      listen: false,
    );
    filtered = [...provider.allTransactions];
  }

  // Group by Month
  Map<String, List<WalletTransaction>> groupByMonth(
    List<WalletTransaction> list,
  ) {
    Map<String, List<WalletTransaction>> map = {};
    for (var t in list) {
      String key = DateFormat("MMMM yyyy").format(t.createdAt);
      map.putIfAbsent(key, () => []);
      map[key]!.add(t);
    }
    return map;
  }

  // Apply Filters (search + date + status)
  void applyFilters() {
    final provider = Provider.of<AllTransactionsProvider>(
      context,
      listen: false,
    );

    DateTime toDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

    setState(() {
      filtered = provider.allTransactions.where((t) {
        final date = toDateOnly(t.createdAt);

        // Search filter
        final matchesSearch =
            t.source.toLowerCase().contains(searchQuery.toLowerCase()) ||
            t.amount.toString().contains(searchQuery) ||
            DateFormat("dd MMM yyyy")
                .format(t.createdAt)
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

        if (!matchesSearch) return false;

        // Status filter
        if (statusFilter != "All" &&
            t.confirmation.toLowerCase() != statusFilter.toLowerCase()) {
          return false;
        }

        // Start only
        if (startDate != null && endDate == null) {
          return date.isAtSameMomentAs(toDateOnly(startDate!)) ||
              date.isAfter(toDateOnly(startDate!));
        }

        // End only
        if (startDate == null && endDate != null) {
          return date.isAtSameMomentAs(toDateOnly(endDate!)) ||
              date.isBefore(toDateOnly(endDate!));
        }

        // Both range
        if (startDate != null && endDate != null) {
          return (date.isAtSameMomentAs(toDateOnly(startDate!)) ||
                  date.isAfter(toDateOnly(startDate!))) &&
              (date.isAtSameMomentAs(toDateOnly(endDate!)) ||
                  date.isBefore(toDateOnly(endDate!)));
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupByMonth(filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text("All User Transactions"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                // Reset filters
                searchQuery = "";
                statusFilter = "All";
                startDate = null;
                endDate = null;

                // Refresh full list
                final provider = Provider.of<AllTransactionsProvider>(
                  context,
                  listen: false,
                );
                filtered = [...provider.allTransactions];
              });
            },
            child: const Text(
              "Reset",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search field
              TextField(
                decoration: InputDecoration(
                  hintText: "Search transaction...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) {
                  searchQuery = val;
                  applyFilters();
                },
              ),

              const SizedBox(height: 15),

              // 🔄 Status filter chips (All, Pending, Success, Failed)
              Wrap(
                spacing: 10,
                children: [
                  _chip("All"),
                  _chip("pending"),
                  _chip("success"),
                  _chip("failed"),
                ],
              ),

              const SizedBox(height: 15),

              // 📅 Date Range Filters
              Row(
                children: [
                  Expanded(
                    child: CustomDatePickerTextField(
                      label: "Start Date",
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDate: startDate,
                      onChanged: (date) {
                        startDate = date;
                        applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: CustomDatePickerTextField(
                      label: "End Date",
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDate: endDate,
                      onChanged: (date) {
                        endDate = date;
                        applyFilters();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🔽 RESULTS
              grouped.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          "No transactions found",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : Column(
                      children: grouped.keys.map((month) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Month Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              child: Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // Transactions under that month
                            ...grouped[month]!.map(
                              (t) => TransactionItem(data: t),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- STATUS FILTER CHIP ------------------

  Widget _chip(String label) {
    final isSelected = statusFilter == label;

    return ChoiceChip(
      label: Text(label[0].toUpperCase() + label.substring(1)),
      selected: isSelected,
      onSelected: (value) {
        statusFilter = label;
        applyFilters();
      },
      selectedColor: Colors.blue.shade100,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
