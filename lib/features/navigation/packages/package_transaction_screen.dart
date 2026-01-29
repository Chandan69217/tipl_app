import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/packages_api/package_transaction_api.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';
import 'package:tipl_app/features/navigation/packages/purchase_slide_card.dart';




class PackageTransactionScreen extends StatefulWidget {
  final Map<String,dynamic> plan;
  final bool isAdmin;
  final VoidCallback? onSuccessPaymentAdd;
  PackageTransactionScreen({super.key,required this.plan,this.isAdmin = false,this.onSuccessPaymentAdd});

  @override
  State<PackageTransactionScreen> createState() => _PackageTransactionScreenState();
}

class _PackageTransactionScreenState extends State<PackageTransactionScreen> {
  // ---------------- STATIC DATA ----------------
  List<dynamic> transactions = [];
  bool _isLoading = false;



  // ---------------- CALCULATIONS ----------------
  int get totalTransactions => transactions.length;

  double get totalPaidAmount => transactions.fold(
    0.0,
        (sum, e) => sum + (double.tryParse(e['amount']) ?? 0),
  );


  @override
  void initState() {
    super.initState();
    init();
  }

  init()async{
    WidgetsBinding.instance.addPostFrameCallback((duration)async{
      setState(() {
        _isLoading = true;
      });
      transactions = await PackageTransactionApiService(context: context).getPackagesTransactionMemberID(widget.plan['member_id'], widget.plan['transaction_id']);
      setState(() {
        _isLoading = false;
      });
    });
  }
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
              _isLoading ? Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: CustomCircularIndicator(),
              ) : totalTransactions != 0 ?ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    data: transactions[index],
                  );
                },
              ):Center(child: Padding( padding: const EdgeInsets.only(top: 50.0),child: Text('No Transaction'))),
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
      builder: (_) =>  AddTransactionDialog(plan: widget.plan,onSuccess: (){
        init();
        widget.onSuccessPaymentAdd?.call();
        WidgetsBinding.instance.addPostFrameCallback((duration){
          Navigator.of(context).pop();
        });
      },),
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



class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final UserRole userType;

  const TransactionItem({
    super.key,
    required this.data,
    this.userType = UserRole.user,
  });

  bool get isCredit =>
      (data['amount'] ?? '0').toString().startsWith('-') == false;

  String get amount =>
      double.parse(data['amount'].toString()).abs().toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _viewDetails(context),

      leading: CircleAvatar(
        backgroundColor: isCredit
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        child: Icon(
          isCredit ? Iconsax.received : Iconsax.send,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),

      // ---------------- TITLE ----------------
      title: Row(
        children: [
          Flexible(
            child: Text(
              data['remarks'] ?? 'Transaction',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          _buildStatusTag(parseStatus(data['status'])),
        ],
      ),

      subtitle: Text(_formatDate(data['createdAt'])),

      trailing: Text(
        '${isCredit ? '+' : '-'}$amount',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // STATUS TAG
  // -------------------------------------------------------
  Widget _buildStatusTag(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return _statusRow(Icons.history, Colors.orange, "Pending");
      case TransactionStatus.failed:
        return _statusRow(Icons.close_rounded, Colors.red, "Failed");
      case TransactionStatus.success:
        return _statusRow(Icons.verified, Colors.green, "Success");
    }
  }

  Widget _statusRow(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    final d = DateTime.parse(date);
    // return "${d.day}/${d.month}/${d.year}";
    return DateFormat('d MMM yyyy hh:mm a').format(d);
  }

  void _viewDetails(BuildContext context) {
    navigateWithAnimation(
      context,
      TransactionDetailsScreen(data: data, userType: userType),
    );
  }

}


enum TransactionStatus { pending, failed, success }

TransactionStatus parseStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'success':
      return TransactionStatus.success;
    case 'failed':
      return TransactionStatus.failed;
    default:
      return TransactionStatus.pending;
  }
}




class AddTransactionDialog extends StatefulWidget {
  const AddTransactionDialog({super.key, this.onSuccess,required this.plan});
  final Map<String,dynamic> plan;
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
  bool _isLoading = false;
  @override
  void dispose() {
    amountController.dispose();
    sourceController.dispose();
    transactionIdController.dispose();
    upiIdController.dispose();
    super.dispose();
  }

  void _submit() async{
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    final isSuccess = await PackageTransactionApiService(context: context).createPackageTransaction(
        memberId: widget.plan['member_id'],
        payoutDate:DateFormat('yyyy-MM-dd').format(DateTime.now()),
        amount: double.tryParse(amountController.text)??0.0,
        upiId: upiIdController.text,
        transactionId: widget.plan['transaction_id'],
        paymentTransactionId: transactionIdController.text,
        remarks: 'Monthly Payout'
    );
    if(isSuccess){
      widget.onSuccess?.call();
      SnackBarHelper.show(context, message: 'Payment details added successfully');
      Navigator.pop(context);
    }
    setState(() {
      _isLoading = false;
    });
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
                  textInputType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
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
                    _isLoading ? CustomCircularIndicator():ElevatedButton(
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



class TransactionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final UserRole userType;

  const TransactionDetailsScreen({
    super.key,
    required this.data,
    required this.userType,
  });

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late String setStatus;

  @override
  void initState() {
    super.initState();
    setStatus = widget.data['status'] ?? 'PENDING';
  }

  // --------------------------------------------------
  // 🔥 JSON HELPERS
  // --------------------------------------------------
  bool get isCredit => (double.tryParse(widget.data['amount']??'') ?? 0) >= 0;

  String get amount =>
      double.parse(widget.data['amount'].toString())
          .abs()
          .toStringAsFixed(2);

  String get source => widget.data['remarks'] ?? 'Transaction';

  String get upi => widget.data['upi_id'] ?? 'N/A';

  String get utr =>
      widget.data['upi_transaction_id']?.toString() ?? 'N/A';

  String get formattedDate {
    final raw =
        widget.data['createdAt'] ?? widget.data['payout_date'];
    final d = DateTime.parse(raw);
    return DateFormat('d MMM yyyy hh:mm a').format(d);
  }

  // --------------------------------------------------
  // 🔥 USER STATUS MESSAGE
  // --------------------------------------------------
  Widget _userStatusMessage() {
    if (widget.userType == UserRole.admin) return const SizedBox();

    final status = setStatus.toLowerCase();

    String message;
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        message =
        "Please wait while your transaction is being verified.";
        color = Colors.orange;
        icon = Icons.hourglass_top;
        break;

      case 'failed':
        message =
        "Transaction failed. Please contact support.";
        color = Colors.red;
        icon = Icons.support_agent;
        break;

      default:
        return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔥 UI
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // AMOUNT CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isCredit
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Icon(
                    isCredit ? Iconsax.received : Iconsax.send,
                    size: 40,
                    color: isCredit ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${isCredit ? '+' : '-'}$amount",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                      isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isCredit ? "CREDIT" : "DEBIT",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            _statusTag(setStatus),
            _userStatusMessage(),

            const SizedBox(height: 20),

            _detailTile(
              icon: Iconsax.shop4,
              label: "Source",
              value: source,
            ),

            _detailTile(
              icon: Iconsax.clock,
              label: "Date & Time",
              value: formattedDate,
            ),

            _detailTile(
              icon: Iconsax.card,
              label: "UPI ID",
              value: upi,
              showCopy: true,
            ),

            _detailTile(
              icon: Iconsax.barcode,
              label: "UTR / Transaction ID",
              value: utr,
              showCopy: true,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🔥 DETAIL TILE
  // --------------------------------------------------
  Widget _detailTile({
    required IconData icon,
    required String label,
    required String value,
    bool showCopy = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (showCopy)
            IconButton(
              icon: const Icon(Iconsax.copy),
              onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: value));
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                      content:
                      Text('$label copied')),
                );
              },
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔥 STATUS TAG
  // --------------------------------------------------
  Widget _statusTag(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'success':
        color = Colors.green;
        break;
      case 'failed':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: status.toLowerCase() == 'success'
          ? const Icon(Icons.verified,
          color: Colors.green, size: 30)
          : Text(
        status.toUpperCase(),
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}


