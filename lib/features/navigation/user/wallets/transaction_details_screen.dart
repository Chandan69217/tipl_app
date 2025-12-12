import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_confirmation.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final WalletTransaction data;
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
  late String selectedStatus;
  late String setStatus;
  bool _isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.data.confirmation;
    setStatus = widget.data.confirmation;
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = widget.data.txnType.toLowerCase() == "credit";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ------------------ AMOUNT CARD ---------------------
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isCredit ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(
                      isCredit ? Iconsax.received : Iconsax.send,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${isCredit ? '+' : '-'}${widget.data.amount}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.data.txnType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _statusTag(setStatus),

            const SizedBox(height: 20),

            // ------------------ DETAILS FIELDS ---------------------
            _detailTile(
              icon: Iconsax.shop4,
              label: "Source",
              value: widget.data.source,
            ),

            _detailTile(
              icon: Iconsax.clock,
              label: "Date & Time",
              value: widget.data.formattedDate,
            ),

            _detailTile(
                icon: Iconsax.card,
                label: "UPI ID",
                value: widget.data.upi ??"N/A",
                showCopy: true
            ),

            _detailTile(
              icon: Iconsax.barcode,
              label: "UTR/Transaction ID",
              value: widget.data.utr ??"N/A",
              showCopy: true
            ),

            const SizedBox(height: 10),

            if (widget.userType == UserRole.admin) TransactionConfirmation(data: widget.data,onSubmit: (v)async{
              setState(() {
                setStatus = v;
              });
            },),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🔥 DETAIL TILE WITH ICON + COPY BUTTON
  // -------------------------------------------------------------
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
          Icon(icon, color: Colors.blueGrey, size: 26),
          const SizedBox(width: 12),

          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    )),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // COPY BUTTON
          if(showCopy)
          IconButton(
            icon: const Icon(Iconsax.copy, size: 20),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              SnackBarHelper.show(context, message: '$label copied');
            },
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 🔥 STATUS TAG
  // -------------------------------------------------------------
  Widget _statusTag(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case "pending":
        color = Colors.orange;
        break;
      case "success":
        color = Colors.green;
        break;
      case "failed":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: status.toLowerCase() == 'success' ? Icon(Icons.verified,color: Colors.green,size: 35,):Text(
          status.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🔥 ADMIN SECTION → DROPDOWN + SUBMIT BUTTON
  // -------------------------------------------------------------

}
