import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/features/navigation/packages/purchase_slide_card.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_item.dart';




class PackageTransactionScreen extends StatefulWidget {
  final Map<String,dynamic> plan;
  final bool isAdmin;
  PackageTransactionScreen({super.key,required this.plan,this.isAdmin = false});

  @override
  State<PackageTransactionScreen> createState() => _PackageTransactionScreenState();
}

class _PackageTransactionScreenState extends State<PackageTransactionScreen> {
  // ---------------- STATIC DATA ----------------
  final List<WalletTransaction> transactions = [
    WalletTransaction(
      id: 1,
      memberId: "MEM001",
      amount: 4708,
      txnType: "credit",
      source: "Monthly ROI Payout",
      confirmation: "success",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    WalletTransaction(
      id: 2,
      memberId: "MEM001",
      amount: 5200,
      txnType: "credit",
      source: "Half-Yearly ROI Payout",
      confirmation: "success",
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    WalletTransaction(
      id: 3,
      memberId: "MEM001",
      amount: 3000,
      txnType: "credit",
      source: "Withdrawal Request",
      confirmation: "success",
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),

    WalletTransaction(
      id: 4,
      memberId: "MEM001",
      amount: 12500,
      txnType: "credit",
      source: "Yearly ROI Payout",
      confirmation: "success",
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];


  // ---------------- CALCULATIONS ----------------
  int get totalTransactions => transactions.length;

  double get totalPaidAmount => transactions
      .where((e) => e.txnType.toLowerCase() == 'credit'
      && e.confirmation == 'success')
      .fold(0.0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Package Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              PurchasedPlanCard(plan: widget.plan),

              Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                child: Text('Payment History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
              _summaryCard(),

              if(transactions.isNotEmpty)
              const Divider(height: 1),

              // ---------------- LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    data: transactions[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _showAddTransactionDialog,
        child: const Icon(Icons.add),
      )
          : null,
    );

  }

  // ---------------- SUMMARY CARD ----------------
  Widget _summaryCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 8,bottom: 16,right: 8,top: 8),
      child: Row(
        children: [
          _summaryTile(
            title: "Total Transactions",
            value: totalTransactions.toString(),
            icon: Icons.receipt_long,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          _summaryTile(
            title: "Total Paid",
            value: "₹${totalPaidAmount.toStringAsFixed(0)}",
            icon: Icons.payments_rounded,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddTransactionDialog(),
    );
  }



  void _addTransaction({
    required double amount,
    required String source,
  }) {
    setState(() {
      transactions.insert(
        0,
        WalletTransaction(
          id: transactions.length + 1,
          memberId: "MEM001",
          amount: amount,
          txnType: "credit",
          source: source,
          confirmation: "success",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
  }


}



class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key, this.onSuccess});

  final VoidCallback? onSuccess;

  @override
  State<AddTransactionDialog> createState() =>
      _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController =
  TextEditingController();
  final TextEditingController sourceController =
  TextEditingController();
  final TextEditingController transactionIdController =
  TextEditingController();
  final TextEditingController upiIdController =
  TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    sourceController.dispose();
    transactionIdController.dispose();
    upiIdController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSuccess?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                const Text(
                  "Add Payment Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Paid Amount',
                  controller: amountController,
                  isRequired: true,
                  textInputType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validate: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Amount is required";
                    }
                    final value = double.tryParse(v);
                    if (value == null || value <= 0) {
                      return "Enter a valid amount";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                /// Transaction ID
                CustomTextField(
                  label: "Transaction ID",
                  controller: transactionIdController,
                  isRequired: true,
                ),

                const SizedBox(height: 12),

                /// UPI ID
                CustomTextField(
                  label: "UPI ID",
                  controller: upiIdController,
                ),

                const SizedBox(height: 12),

                /// Amount


                // /// Source
                // CustomTextField(
                //   label: "Payment Source",
                //   controller: sourceController,
                //   isRequired: true,
                //   validate: (v) {
                //     if (v == null || v.trim().isEmpty) {
                //       return "Payment source is required";
                //     }
                //     return null;
                //   },
                // ),
                //
                // const SizedBox(height: 24),

                /// Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _submit,
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



