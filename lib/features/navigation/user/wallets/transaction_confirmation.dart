import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';


enum TransactionStatus {
  pending,
  success,
  failed,
}

TransactionStatus parseStatus(String status) {
  switch (status.toLowerCase()) {
    case 'success':
      return TransactionStatus.success;
    case 'failed':
      return TransactionStatus.failed;
    default:
      return TransactionStatus.pending;
  }
}





class TransactionConfirmation extends StatefulWidget {
  final WalletTransaction data;
  final Future<void> Function(String newStatus)? onSubmit;

  const TransactionConfirmation({
    super.key,
    required this.data,
    required this.onSubmit,
  });

  @override
  State<TransactionConfirmation> createState() => _TransactionConfirmationState();
}

class _TransactionConfirmationState extends State<TransactionConfirmation> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.data.confirmation;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Confirmation",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          // ------------------------------------------
          // DROPDOWN
          // ------------------------------------------
          CustomDropdown<String>(
            label: 'Payment Confirmation Status',
            value: selectedStatus,
            isRequired: true,
            items: TransactionStatus.values
                .map(
                  (e) => DropdownMenuItem<String>(
                value: e.name,
                child: Text(
                  e.name[0].toUpperCase() + e.name.substring(1),
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => selectedStatus = value);
            },
          ),

          const SizedBox(height: 20),

          // ------------------------------------------
          // SUBMIT BUTTON
          // ------------------------------------------
          _isLoading
              ? const CustomCircularIndicator()
              : CustomButton(
            text: 'Submit',
            iconData: Iconsax.verify,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }

  onSubmit()async{
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);

      final url = Uri.https(
        Urls.baseUrl,
        '/api/wallet/transaction/update-last/${widget.data.memberId.toString()}',
      );

      final body = json.encode(
          {
            "amount": widget.data.amount,
            "txn_type": widget.data.txnType,
            "source": widget.data.source,
            "reference": widget.data.reference,
            "upi": widget.data.upi,
            "utr": widget.data.utr,
            "confirmation": selectedStatus
          }
      );

      final response = await put(url,body: body,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200 || response.statusCode == 201){
       final value = json.decode(response.body) as Map<String,dynamic>;
       final isSuccess = value['isSuccess']??false;
       if(isSuccess){
         if (widget.onSubmit != null) {
           await widget.onSubmit!(selectedStatus);
         }
         SnackBarHelper.show(
           context,
           message: 'Status updated successfully',
         );
         RecallProvider(context: context).recallAll();
       }
      }else{
        handleApiResponse(context, response);
      }

    } catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }finally {
      setState(() => _isLoading = false);
    }
  }
}


class TransactionConfirmatio3n {
  static void show(BuildContext context, WalletTransaction data) {
    String selectedStatus = data.confirmation;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------------------------------------------
                  // TITLE
                  // -------------------------------------------------------
                  const Text(
                    "Update Transaction Status",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -------------------------------------------------------
                  // DROPDOWN STATUS
                  // -------------------------------------------------------
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Status",
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: "pending", child: Text("Pending")),
                      DropdownMenuItem(
                          value: "success", child: Text("Success")),
                      DropdownMenuItem(
                          value: "failed", child: Text("Failed")),
                    ],
                    onChanged: (value) {
                      setState(() => selectedStatus = value!);
                    },
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------------------------------
                  // SUBMIT BUTTON
                  // -------------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);

                        // TODO: API integration here
                        // await TransactionsApi.updateStatus(data.id, selectedStatus);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Status Updated Successfully")),
                        );
                      },
                      child: const Text("Update Status"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      // builder: (_) {
      //   return StatefulBuilder(
      //     builder: (context, setState) {
      //       return Padding(
      //         padding: const EdgeInsets.all(20),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             // -------------------------------------------------------
      //             // TITLE
      //             // -------------------------------------------------------
      //             const Text(
      //               "Update Transaction Status",
      //               style: TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //
      //             const SizedBox(height: 16),
      //
      //             // -------------------------------------------------------
      //             // DROPDOWN STATUS
      //             // -------------------------------------------------------
      //             DropdownButtonFormField<String>(
      //               value: selectedStatus,
      //               decoration: const InputDecoration(
      //                 border: OutlineInputBorder(),
      //                 labelText: "Select Status",
      //               ),
      //               items: const [
      //                 DropdownMenuItem(
      //                     value: "pending", child: Text("Pending")),
      //                 DropdownMenuItem(
      //                     value: "success", child: Text("Success")),
      //                 DropdownMenuItem(
      //                     value: "failed", child: Text("Failed")),
      //               ],
      //               onChanged: (value) {
      //                 setState(() => selectedStatus = value!);
      //               },
      //             ),
      //
      //             const SizedBox(height: 20),
      //
      //             // -------------------------------------------------------
      //             // SUBMIT BUTTON
      //             // -------------------------------------------------------
      //             SizedBox(
      //               width: double.infinity,
      //               child: ElevatedButton(
      //                 onPressed: () async {
      //                   Navigator.pop(context);
      //
      //                   // TODO: API integration here
      //                   // await TransactionsApi.updateStatus(data.id, selectedStatus);
      //
      //                   ScaffoldMessenger.of(context).showSnackBar(
      //                     const SnackBar(
      //                         content: Text("Status Updated Successfully")),
      //                   );
      //                 },
      //                 child: const Text("Update Status"),
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // },
    );
  }
}
