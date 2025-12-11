import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:tipl_app/api_service/packages_api/packages_api.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/features/navigation/packages/package_card.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_pass_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';





class AddFundScreen extends StatefulWidget {
  @override
  _AddFundScreenState createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController upiController = TextEditingController();
  final TextEditingController utrController = TextEditingController();

  String? selectedSource = "Admin";
  List<dynamic> _packages_list = [];
  Map<String, dynamic>? selected_package = null;
  bool _isLoading = true;
  bool _btnLoading = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final transaction = Provider.of<WalletProvider>(context,listen: false).transaction;
    if(transaction.isNotEmpty){
      final status = transaction[0].confirmation.toLowerCase() == 'pending';
      if(status){
        WidgetsBinding.instance.addPostFrameCallback((duration){
          CustomMessageDialog.show(
            context,
            title: 'Notice',
            message: 'Until the previous payment is confirmed, you cannot add another transaction. Please wait for verification.',
            confirmText: 'Go Back',
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        });
      }
    }
    _packages_list = await PackagesApiService().getPackagesType();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Fund")),

      body: _isLoading
          ? CustomCircularIndicator()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Wallet banner
                    Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Color(0xFF1B1B1D),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Color(0xFFFFD700), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Funds",
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Enter the details to add money to user wallet",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                    SizedBox(height: 20),
                
                      CustomDropdown<int?>(
                        label: 'Select Package',
                        items: _packages_list
                            .map<DropdownMenuItem<int>>(
                              (e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text('${e['package_name']}'),
                              ),
                            )
                            .toList(),
                        value: null,
                        isRequired: true,
                        onChanged: (value) async {
                          if (value == null) {
                            setState(() {
                              selected_package = null;
                            });
                            return;
                          }
                          ;
                          setState(() {
                            selected_package = _packages_list.firstWhere((e) {
                              return e['id'] == value;
                            });
                          });
                        },
                      ),
                      if (selected_package != null) ...[
                        const SizedBox(height: 10),
                        PaymentPackageScreen(package: selected_package!,
                          // formKey: _formKey,
                          upiController: upiController,
                          utrController: utrController,
                        ),
                        const SizedBox(height: 10),
                      ],
                
                      SizedBox(height: 20),

                      if(selected_package != null)...[
                        // Add Fund Button
                        _btnLoading ? CustomCircularIndicator() :CustomButton(
                          color: Colors.black,
                          text: "Continue",
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _btnLoading = true;
                              });
                              final pass = await TransactionPasswordSheet.showTransactionPasswordSheet(context);
                              final response = await WalletApiService(context: context).addFund(
                                  amount: '${selected_package?['amount']}',
                                  reference: '${selected_package?['package_name']}',
                                  password: pass??'',
                                  upi: upiController.text,
                                  utr: utrController.text
                              );

                              if(response != null ){
                                final isSuccess = response['isSuccess']??false;
                                if(isSuccess){
                                  CustomMessageDialog.show(
                                    context,
                                    title: 'Success',
                                    message: 'Add fund request submitted successfully. Please wait for verification by our team within 48 hours.',
                                    onConfirm: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }else{
                                  CustomMessageDialog.show(context, title: "Failed", message: response['message']);
                                }
                              }else{
                                CustomMessageDialog.show(context, title: 'Error', message: 'Something went wrong !');
                              }

                              setState(() {
                                _btnLoading = false;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10,)
                      ]
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  
}

class PaymentPackageScreen extends StatefulWidget {
  final Map<String, dynamic> package;
  final GlobalKey<FormState>? formKey;
  final TextEditingController upiController;
  final TextEditingController utrController;

  const PaymentPackageScreen({super.key, required this.package,this.formKey,required this.upiController,required this.utrController});

  @override
  State<PaymentPackageScreen> createState() => _PaymentPackageScreenState();
}

class _PaymentPackageScreenState extends State<PaymentPackageScreen> {

  bool showPaymentFields = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showInfoPopup();
    });
  }


  void _showInfoPopup() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.yellow.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // 📝 Title
              Text(
                "Important Notice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // 📌 Body Message
              Text(
                "Please pay the package amount only to the QR code shown.\n\n"
                    "After completing the payment, enter your UPI ID and UTR number "
                    "to proceed with the purchase.\n\n"
                    "⚠ Be careful and enter the correct details.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 18),

            ],
          ),
        ),
      ),
    );
  }


  Future<void> _openUPIPayment({
    required String qr_data
  }) async {
    final uri = Uri.parse(
      qr_data,
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not open UPI app";
    }
  }

  Future<void> _downloadAndOpenQR() async {
    try {
      final String baseUrl = "https://api.neuralpool.in";
      String url = baseUrl + widget.package["qr_image"];

      final response = await get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/qr.png");

      await file.writeAsBytes(response.bodyBytes);
      final qrData = await QrCodeToolsPlugin.decodeFrom(file.path);

      if (qrData != null && qrData.isNotEmpty) {
        print("QR Data: $qrData");
        _openUPIPayment(qr_data: qrData);
      } else {
        print("No QR code found in the image.");
      }

    } catch (e) {
      print("Error downloading QR: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final data = widget.package;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        Text(
          'Package Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        PackageCard(
          plan: widget.package,
          color: Colors.pinkAccent,
          isSelected: true,
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Scan & Pay",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            // ℹ️ INFO ICON ADDED HERE
            InkWell(
              onTap: _showInfoPopup,
              child: const Icon(Iconsax.info_circle, color: Colors.blue),
            )
          ],
        ),

        const SizedBox(height: 10),

        // QR IMAGE WITH LOADER + ERROR WIDGET
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://api.neuralpool.in${data["qr_image"] ?? ''}',
              height: 250,
              width: 250,
              fit: BoxFit.cover,

              placeholder: (context, url) => Container(
                height: 250,
                width: 250,
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              ),

              errorWidget: (context, url, error) => Container(
                height: 250,
                width: 250,
                color: Colors.grey.shade300,
                child: const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),


        const SizedBox(height: 5),

        // PAY BUTTON

        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              await _downloadAndOpenQR();
            },
            child: const Text("Pay Now", style: TextStyle(fontSize: 16)),
          ),
        ),
        //
        const SizedBox(height: 20),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "After Payment, Enter Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            CustomTextField(
              label: 'Enter Your UPI ID',
              controller: widget.upiController,
              isRequired: true,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              label: 'Enter UTR / Transaction Number',
              controller: widget.utrController,
              textInputType: TextInputType.number,
              isRequired: true,
            ),
          ],
        )
      ],
    );
  }


}

