import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/bank_service_api.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';




class AddBankDetailsScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  const AddBankDetailsScreen({super.key,this.onSuccess});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController panNumberController = TextEditingController();

  String? accountType;
  File? panCardPhoto;
  File? bankAccountPhoto;
  bool _isLoading = false;

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
                        panCardPhoto = File(pickedFile.path);
                      } else {
                        bankAccountPhoto = File(pickedFile.path);
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
                        panCardPhoto = File(pickedFile.path);
                      } else {
                        bankAccountPhoto = File(pickedFile.path);
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



  void _submit() async{
    if (!(_formKey.currentState?.validate()??false)) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final addSuccessfully = await BankServiceAPI(context: context).addBankDetails(
        branch_name: branchNameController.text,
        ifsc_code: ifscController.text,
        bank_name: bankNameController.text,
        accoune_type: accountType??'',
        account_name: accountNameController.text,
        account_no: accountNumberController.text,
        pan_number: panNumberController.text,
        pan_img: panCardPhoto!,
        bank_acc_img: bankAccountPhoto!
    );
    if(addSuccessfully){
      widget.onSuccess?.call();
    }
    if(mounted){
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bank Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  prefixIcon: Icon(Iconsax.user),
                  label: 'Account Name',
                  controller: accountNameController,
                  isRequired: true,
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                    prefixIcon: Icon(Iconsax.card),
                    label:"Account Number",
                    controller: accountNumberController,
                    textInputType: TextInputType.number,
                  isRequired: true,
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                    prefixIcon:Icon(Iconsax.bank),
                    label: "Bank Name",
                    controller: bankNameController,
                    textInputType: TextInputType.text,
                  isRequired: true,
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                    prefixIcon:Icon(Iconsax.building_3),
                    label: "Branch Name",
                    controller: branchNameController,
                    textInputType:TextInputType.text,
                  isRequired: true,
                ),
                const SizedBox(height: 16,),
                CustomTextField(
                    prefixIcon:Icon(Iconsax.code),
                    label: "IFSC Code",
                    controller: ifscController,
                    textInputType: TextInputType.text,
                  textInputFormatter: [UpperCaseTextFormatter()],
                  isRequired: true,
                ),
                const SizedBox(height: 16,),
                CustomDropdown(label: 'Account Type', items: const [
                  DropdownMenuItem(value: "Saving", child: Text("Saving Account")),
                  DropdownMenuItem(value: "Current", child: Text("Current Account")),
                ], value:  accountType, onChanged: (value) => setState(() => accountType = value),),
                const SizedBox(height: 16,),
                CustomTextField(prefixIcon:Icon(Iconsax.document),
                    label: "PAN Number",
                    controller: panNumberController,
                    textInputType: TextInputType.text,
                  maxLength: 10,
                  textInputFormatter: [
                    UpperCaseTextFormatter()
                  ],
                ),
                const SizedBox(height: 24),
                _buildImagePicker(
                    label: "PAN Card Photo",
                    icon: Iconsax.camera,
                    file: panCardPhoto,
                    onTap: () => _pickImage(true)),
                const SizedBox(height: 16),
                _buildImagePicker(
                    label: "Bank Account Photo",
                    icon: Iconsax.gallery,
                    file: bankAccountPhoto,
                    onTap: () => _pickImage(false)),
                const SizedBox(height: 30),
                _isLoading ? CustomCircularIndicator(): CustomButton(
                  onPressed: _submit,
                  iconData: Iconsax.save_add,
                  text: 'Save Details',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildImagePicker({
    required String label,
    required IconData icon,
    required File? file,
    required Future<void> Function() onTap,
  }) {
    return FormField<File>(
      validator: (value) {
        if (file == null) {
          return "Please upload $label";
        }
        return null;
      },
      builder: (FormFieldState<File> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                await onTap();
                field.didChange(file);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: field.hasError ? Colors.red : Colors.black26,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(icon,),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    file == null
                        ? const Icon(Iconsax.add_circle, color: Colors.grey)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        file,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }


}


