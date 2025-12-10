import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tipl_app/api_service/packages_api/packages_api.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';



class CreateUpdatePackageScreen extends StatefulWidget {
  final VoidCallback? onSuccess;
  final bool isEdit;
  final Map<String, dynamic>? existingData;

  const CreateUpdatePackageScreen({
    super.key,
    this.isEdit = false,
    this.existingData,
    this.onSuccess
  });

  @override
  State<CreateUpdatePackageScreen> createState() =>
      _CreateUpdatePackageScreenState();
}

class _CreateUpdatePackageScreenState extends State<CreateUpdatePackageScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final monthlyCtrl = TextEditingController();
  final halfYearCtrl = TextEditingController();
  final yearlyCtrl = TextEditingController();
  bool _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.existingData != null) {
      nameCtrl.text = widget.existingData!["package_name"];
      descCtrl.text = widget.existingData!["description"];
      amountCtrl.text = widget.existingData!["amount"].toString();
      durationCtrl.text = widget.existingData!["duration_in_days"].toString();
      monthlyCtrl.text = widget.existingData!["monthly_roi_percent"].toString();
      halfYearCtrl.text =
          widget.existingData!["halfyearly_roi_percent"].toString();
      yearlyCtrl.text = widget.existingData!["yearly_roi_percent"].toString();
    }

  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    amountCtrl.dispose();
    durationCtrl.dispose();
    monthlyCtrl.dispose();
    halfYearCtrl.dispose();
    yearlyCtrl.dispose();
    super.dispose();
  }


  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final ext = picked.path.split('.').last.toLowerCase();

    if (!(ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "webp")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid image! Only jpg, jpeg, png, webp allowed.")),
      );
      return;
    }

    setState(() => imageFile = File(picked.path));
  }


  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (imageFile == null && !widget.isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    final isSuccess = widget.isEdit
        ? await PackagesApiService().updatePackage(
      packageId: '${widget.existingData?['id']}',

      packageName: nameCtrl.text.trim().isEmpty
          ? null
          : nameCtrl.text.trim(),

      desc: descCtrl.text.trim().isEmpty
          ? null
          : descCtrl.text.trim(),

      amount: parseOrNull<double>(amountCtrl.text, double.parse),
      duration: parseOrNull<int>(durationCtrl.text, int.parse),

      monthly_roi_percent: parseOrNull<int>(monthlyCtrl.text, int.parse),
      halfyearly_roi_percent: parseOrNull<int>(halfYearCtrl.text, int.parse),
      yearly_roi_percent: parseOrNull<int>(yearlyCtrl.text, int.parse),

      imageFile: imageFile, // if null → API gets null
    )
        : await PackagesApiService().createPackage(
      packageName: nameCtrl.text.trim(),
      desc: descCtrl.text.trim(),
      amount: double.parse(amountCtrl.text),
      duration: int.parse(durationCtrl.text),
      monthly_roi_percent: int.parse(monthlyCtrl.text),
      halfyearly_roi_percent: int.parse(halfYearCtrl.text),
      yearly_roi_percent: int.parse(yearlyCtrl.text),
      imageFile: imageFile??File(''),
    );


    if (isSuccess) {
      SnackBarHelper.show(context, message: widget.isEdit ? "Package Updated" : "Package Created",);
      widget.onSuccess?.call();
      Navigator.pop(context,);
    }
    setState(() {
      _isLoading = false;
    });
  }

  T? parseOrNull<T>(String value, T Function(String) parser) {
    if (value.trim().isEmpty) return null;
    return parser(value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.isEdit ? "Update Package" : "Create New Package"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // PACKAGE NAME
                CustomTextField(
                  label: 'Package Name',
                  controller: nameCtrl,
                  isRequired: true,
                ),
          
                // DESCRIPTION
                CustomTextField(
                  label: 'Description',
                  controller: descCtrl,
                  maxLine: 2,
                  isRequired: true,
                ),
          
                // AMOUNT
                CustomTextField(
                  controller: amountCtrl,
                  label: 'Amount',
                  textInputType: TextInputType.number,
                  isRequired: true,
                ),
          
                // DURATION
                CustomTextField(
                  label: 'Duration (days)',
                  controller: durationCtrl,
                  textInputType: TextInputType.number,
                 isRequired: true,
                ),
          
                const SizedBox(height: 20),
          
                // ROI FIELDS
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: monthlyCtrl,
                        label: 'Monthly ROI %',
                        textInputType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        label: 'Half-Year ROI %',
                        controller: halfYearCtrl,
                        textInputType: TextInputType.number,
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 10),
          
                CustomTextField(
                  controller: yearlyCtrl,
                  label: 'Yearly ROI %',
                  textInputType: TextInputType.number,
                  isRequired: true,
                ),
          
                const SizedBox(height: 20),
          
                // IMAGE PICKER
              FormField<File>(
                validator: (value) {
                  if (!widget.isEdit && imageFile == null) {
                    return "Please select an image";
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
          
                      GestureDetector(
                        onTap: () async {
                          await pickImage();
                          field.didChange(imageFile);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: field.hasError ? Colors.red : Colors.grey.shade400,
                              width: 1.2,
                            ),
                            color: Colors.grey.shade100,
                          ),
                          child: Row(
                            children: [
                              // Thumbnail preview
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300,
                                  image: imageFile != null
                                      ? DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: imageFile == null
                                    ? const Icon(Icons.image, color: Colors.grey, size: 28)
                                    : null,
                              ),
          
                              const SizedBox(width: 14),
          
                              // File info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      imageFile == null
                                          ? "Upload QR Image"
                                          : imageFile!.path.split('/').last,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: imageFile == null
                                            ? Colors.grey.shade600
                                            : Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
          
                                    const SizedBox(height: 4),
          
                                    Text(
                                      "Tap to select (.jpg .jpeg .png .webp)",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
          
                              const Icon(Icons.upload_rounded,
                                  size: 30, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
          
                      // ❌ Error Message
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            field.errorText!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                    ],
                  );
                },
              ),
          
              const SizedBox(height: 30),
          
                // SUBMIT BUTTON
                _isLoading ? CustomCircularIndicator():CustomButton(
                  text: widget.isEdit ? "Update Package" : "Create Package",
                  onPressed: submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
