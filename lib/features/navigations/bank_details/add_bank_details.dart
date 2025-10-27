import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';



class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({super.key});

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

  Future<void> _pickImage(bool isPan) async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isPan) {
          panCardPhoto = File(pickedFile.path);
        } else {
          bankAccountPhoto = File(pickedFile.path);
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (panCardPhoto == null || bankAccountPhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please upload PAN card and Bank account photos")),
        );
        return;
      }
      // Submit your data here (API Call or Save Locally)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bank details submitted successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bank Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(Iconsax.user, "Account Name",
                  accountNameController, TextInputType.name),
              _buildTextField(Iconsax.card, "Account Number",
                  accountNumberController, TextInputType.number),
              _buildTextField(Iconsax.bank, "Bank Name", bankNameController,
                  TextInputType.text),
              _buildTextField(Iconsax.building_3, "Branch Name",
                  branchNameController, TextInputType.text),
              _buildTextField(
                  Iconsax.code, "IFSC Code", ifscController, TextInputType.text),
              _buildDropdown(),
              _buildTextField(Iconsax.document, "PAN Number",
                  panNumberController, TextInputType.text),
              const SizedBox(height: 20),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Iconsax.save_add),
                  label: const Text("Save Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label,
      TextEditingController controller, TextInputType type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: accountType,
        decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Account Type",
          prefixIcon: Icon(Iconsax.briefcase, color: Colors.teal),
        ),
        items: const [
          DropdownMenuItem(value: "Saving", child: Text("Saving Account")),
          DropdownMenuItem(value: "Current", child: Text("Current Account")),
        ],
        onChanged: (value) => setState(() => accountType = value),
        validator: (value) =>
        value == null ? "Please select account type" : null,
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            file == null
                ? const Icon(Iconsax.add_circle, color: Colors.grey)
                : ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(file, width: 50, height: 50, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
