import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/bank_service_api.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/image_viewer_screen.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

// class ViewBankDetailsScreen extends StatefulWidget {
//
//
//   const ViewBankDetailsScreen({super.key,});
//
//   @override
//   State<ViewBankDetailsScreen> createState() => _ViewBankDetailsScreenState();
// }
//
// class _ViewBankDetailsScreenState extends State<ViewBankDetailsScreen> {
//   late Map<String, dynamic> bankData;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void _editBankDetails() async {
//
//     final updatedData = await navigateWithAnimation(context, EditBankDetailsScreen(data: bankData));
//     if (updatedData != null && mounted) {
//       setState(() {
//         // bankData = updatedData;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bank Details"),
//         actions: [
//           IconButton(
//             icon: const Icon(Iconsax.edit),
//             onPressed: _editBankDetails,
//           ),
//         ],
//       ),
//       body: FutureBuilder<Map<String,dynamic>?>(
//           future: BankServiceAPI(context: context).getBankDetails(),
//         builder: (context, snapshot) {
//             if(snapshot.connectionState == ConnectionState.waiting){
//               return CustomCircularIndicator();
//             }
//             if(snapshot.hasData && snapshot.data != null){
//               bankData = Map<String, dynamic>.from(snapshot.data!);
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     _buildDetailCard(context),
//                     const SizedBox(height: 20),
//                     // _buildImageCard("PAN Card Photo", bankData["pan_card_photo"]??''),
//                     // const SizedBox(height: 16),
//                     // _buildImageCard("Bank Account Photo", bankData["bank_account_photo"]??''),
//                     // const SizedBox(height: 20,),
//                   ],
//                 ),
//               );
//             }else{
//               return Center(
//                 child: Text('Something went wrong !'),
//               );
//             }
//         },
//       ),
//     );
//   }
//
//   Widget _buildDetailCard(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           _buildDetailRow(Iconsax.user, "Account Name", bankData["account_name"]??'N/A'),
//           _buildDetailRow(Iconsax.card, "Account Number", bankData["account_no"]??'N/A'),
//           _buildDetailRow(Iconsax.bank, "Bank Name", bankData["bank_name"]??'N/A'),
//           _buildDetailRow(Iconsax.building_3, "Branch Name", bankData["branch_name"]??'N/A'),
//           _buildDetailRow(Iconsax.code, "IFSC Code", bankData["ifsc_code"]??'N/A'),
//           _buildDetailRow(Iconsax.briefcase, "Account Type", bankData["account_type"]??'N/A'),
//           _buildDetailRow(Iconsax.document, "PAN Number", bankData["pan_number"]??'N/A'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String? value) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.teal, size: 22),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(label,
//                     style: const TextStyle(
//                         fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
//                 const SizedBox(height: 4),
//                 Text(
//                   value ?? "N/A",
//                   style: const TextStyle(
//                       fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildImageCard(String title, String? imagePath) {
//     final bool hasImage = imagePath != null && imagePath.isNotEmpty;
//     final bool isNetworkImage =  hasImage  && imagePath.startsWith('http');
//
//     bool isValidLocalFile(String path) {
//       try {
//         final file = File(path);
//         return file.existsSync();
//       } catch (_) {
//         return false;
//       }
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),
//
//           if (hasImage)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: isNetworkImage
//                   ? CachedNetworkImage(
//                 imageUrl: imagePath,
//                 width: double.infinity,
//                 height: 180,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   height: 180,
//                   alignment: Alignment.center,
//                   child: const CircularProgressIndicator(color: Colors.teal),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   height: 180,
//                   alignment: Alignment.center,
//                   color: Colors.grey.shade200,
//                   child: const Icon(Icons.broken_image, color: Colors.grey),
//                 ),
//               )
//                   : isValidLocalFile(imagePath) ? Image.file(
//                 File(imagePath),
//                 width: double.infinity,
//                 height: 180,
//                 fit: BoxFit.cover,
//               ):Container(
//                 width: double.infinity,
//                 height: 160,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black26),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: const Text(
//                   "No Image Uploaded",
//                   style: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             )
//           else
//             Container(
//               width: double.infinity,
//               height: 160,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black26),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Text(
//                 "No Image Uploaded",
//                 style: TextStyle(color: Colors.black54),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
// }

class ViewBankDetailsScreen extends StatefulWidget {
  const ViewBankDetailsScreen({super.key,});

  @override
  State<ViewBankDetailsScreen> createState() => _ViewBankDetailsScreenState();
}

class _ViewBankDetailsScreenState extends State<ViewBankDetailsScreen> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
  }

  void _editBankDetails() async {
    final updatedData = await navigateWithAnimation(context, EditBankDetailsScreen(data: data));
    if (updatedData != null && mounted) {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Details"),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: _editBankDetails,
          ),
        ],
      ),

      body: FutureBuilder<Map<String,dynamic>?>(
        future: BankServiceAPI(context: context).getBankDetails(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return CustomCircularIndicator();
          }

          if(snapshot.hasData && snapshot.data != null){
            data = Map<String, dynamic>.from(snapshot.data!);
            final String? panPhoto = data['pan_card_photo'];
            final String? bankPhoto = data['bank_account_photo'];
            final String baseUrl = "https://${Urls.baseUrl}/";
            return  SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildProfileHeader(context, data),
                    const SizedBox(height: 24),
                    _detailRow(
                      Iconsax.user,
                      Colors.orange,
                      "Account Name",
                      data['account_name'],
                    ),
                    _detailRow(
                      Iconsax.card,
                      Colors.blueAccent,
                      "Account Number",
                      data['account_no'],
                      trailing: IconButton(
                        icon: const Icon(Iconsax.copy, size: 18, color: Colors.grey),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: data['account_no'] ?? ""));
                          SnackBarHelper.show(
                              message: "Account number copied",
                              context
                          );
                        },
                      ),
                    ),
                    _detailRow(
                      Iconsax.bank,
                      Colors.teal,
                      "Bank Name",
                      data['bank_name'],
                      trailing: IconButton(
                        icon: const Icon(Iconsax.eye, size: 20, color: Colors.teal),
                        onPressed: () {
                          navigateWithAnimation(context, ImageViewerScreen(imageUrl: baseUrl + (bankPhoto??'')));
                        },
                      ),
                    ),
                    _detailRow(
                      Iconsax.building,
                      Colors.purpleAccent,
                      "Branch Name",
                      data['branch_name'],
                    ),
                    _detailRow(
                      Iconsax.code,
                      Colors.pinkAccent,
                      "IFSC Code",
                      data['ifsc_code'],
                      trailing: IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: data['ifsc_code'] ?? ""));
                          SnackBarHelper.show(context, message: "IFSC Code copied");
                        },
                      ),
                    ),
                    _detailRow(
                      Iconsax.wallet_3,
                      Colors.cyan,
                      "Account Type",
                      data['account_type'],
                    ),
                    _detailRow(
                      Iconsax.document,
                      Colors.blue,
                      "PAN Number",
                      data['pan_number'],
                      trailing: IconButton(
                        icon: const Icon(Iconsax.eye, size: 20, color: Colors.blue),
                        onPressed: () {
                          navigateWithAnimation(context, ImageViewerScreen(imageUrl: baseUrl + (panPhoto??'')));
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }else{
            return Center(
              child: Text('Something went wrong !'),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Map<String, dynamic> data) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.bank, color: Colors.white, size: 45),
            ),
            // 🔹 View Profile button
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to user profile screen
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.user, color: Colors.teal, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data['account_name'] ?? "Account Holder",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data['bank_name'] ?? "Bank Name",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }



  Widget _detailRow(IconData icon,Color? iconColor ,String title, String? value,{
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: iconColor??Colors.black, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(
                  value?.isNotEmpty == true ? value! : "N/A",
                  style: const TextStyle(
                      color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

}

class EditBankDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditBankDetailsScreen({super.key, required this.data});

  @override
  State<EditBankDetailsScreen> createState() => _EditBankDetailsScreenState();
}

class _EditBankDetailsScreenState extends State<EditBankDetailsScreen> {
  late TextEditingController _accountNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _bankNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _panNumberController;

  dynamic _panCardPhoto;
  dynamic _bankAccountPhoto;
  String? accountType;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController(text: widget.data["account_name"]??'');
    _accountNumberController = TextEditingController(text: widget.data["account_number"]??'');
    _bankNameController = TextEditingController(text: widget.data["bank_name"]??'');
    _branchNameController = TextEditingController(text: widget.data["branch_name"]??'');
    _ifscCodeController = TextEditingController(text: widget.data["ifsc_code"]??'');
     accountType = widget.data["account_type"]??'';
    _panNumberController = TextEditingController(text: widget.data["pan_number"]);
    _panCardPhoto = widget.data["pan_card_photo"];
    _bankAccountPhoto = widget.data["bank_account_photo"];
  }

  void _saveDetails()async {
    if((_formKey.currentState?.validate()??false)){
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final updatedData = await BankServiceAPI(context: context).getBankDetails(
      account_name: _accountNameController.text.trim(),
      account_no: _accountNumberController.text.trim(),
      bank_name:  _bankNameController.text.trim(),
    branch_name: _branchNameController.text.trim(),
    ifsc_code: _ifscCodeController.text.trim(),
    pan_number: _panNumberController.text.trim(),
    pan_img: _panCardPhoto is File ? _panCardPhoto :null,
    accoune_type: accountType,
    bank_acc_img: _bankAccountPhoto is File ? _bankAccountPhoto : null
    );

    if(updatedData != null){
      Navigator.pop(context,true);
    }

    setState(() {
      if(mounted){
        _isLoading = false;
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Bank Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                    label: 'Account Name',
                    controller: _accountNameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  isRequired: true,
                  prefixIcon: Icon(Iconsax.user),
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                  label: 'Account Number',
                  controller: _accountNumberController,
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  fieldType: FieldType.bankAccount,
                  isRequired: true,
                  prefixIcon: Icon(Iconsax.card),
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                  label: 'Bank Name',
                  controller: _bankNameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  isRequired: true,
                  prefixIcon: Icon(Iconsax.bank),
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                  label: 'Branch Name',
                  controller: _branchNameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  isRequired: true,
                  prefixIcon: Icon(Iconsax.building_3),
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                  label: 'IFSC Code',
                  controller: _ifscCodeController,
                  textInputType: TextInputType.text,
                  fieldType: FieldType.ifsc,
                  textInputFormatter: [UpperCaseTextFormatter()],
                  textInputAction: TextInputAction.next,
                  isRequired: true,
                  prefixIcon: Icon(Iconsax.code),
                ),
                const SizedBox(height: 16,),
                CustomDropdown(label: 'Account Type', items: const [
                  DropdownMenuItem(value: "saving", child: Text("Saving Account")),
                  DropdownMenuItem(value: "current", child: Text("Current Account")),
                ], value:  accountType?.toLowerCase(), onChanged: (value) => setState(() => accountType = value),),

                const SizedBox(height: 16,),
                CustomTextField(
                  label: 'PAN Number',
                  controller: _panNumberController,
                  textInputType: TextInputType.text,
                  fieldType: FieldType.pan,
                  textInputFormatter: [UpperCaseTextFormatter()],
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(Iconsax.document),
                ),

                const SizedBox(height: 16),
                _buildImagePicker("PAN Card Photo", _panCardPhoto, () => _pickImage(true)),
                const SizedBox(height: 16),
                _buildImagePicker("Bank Account Photo", _bankAccountPhoto, () => _pickImage(false)),
                const SizedBox(height: 20),
                _isLoading ? CustomCircularIndicator() : CustomButton(
                    text: "Save Changes",
                    onPressed: _saveDetails,
                   iconData: Iconsax.save_2,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(String title, dynamic imagePath,VoidCallback onTap) {
    final bool hasImage = imagePath != null && imagePath is! File;
    final bool isNetworkImage = hasImage && imagePath.startsWith('http');

    bool isValidLocalFile(String path) {
      try {
        final file = File(path);
        return file.existsSync();
      } catch (_) {
        return false;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: isNetworkImage
                  ? CachedNetworkImage(
                imageUrl: imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(color: Colors.teal),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  alignment: Alignment.center,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              )
                  : isValidLocalFile(imagePath) ? Image.file(
                imagePath,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ):Container(
                width: double.infinity,
                height: 160,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Tap to Uploaded",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Tap to Uploaded",
                style: TextStyle(color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }


  Future<void> _pickImage(bool isPan) async {

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Iconsax.camera, color: Colors.teal),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85, // Compress image
                  );
                  if (pickedFile != null) {
                    setState(() {
                      if (isPan) {
                        _panCardPhoto = File(pickedFile.path);
                      } else {
                        _bankAccountPhoto = File(pickedFile.path);
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.gallery, color: Colors.teal),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      if (isPan) {
                        _panCardPhoto = File(pickedFile.path);
                      } else {
                        _bankAccountPhoto = File(pickedFile.path);
                      }
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

}

