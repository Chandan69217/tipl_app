import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class ViewBankDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ViewBankDetailsScreen({super.key, required this.data});

  @override
  State<ViewBankDetailsScreen> createState() => _ViewBankDetailsScreenState();
}

class _ViewBankDetailsScreenState extends State<ViewBankDetailsScreen> {
  late Map<String, dynamic> bankData;

  @override
  void initState() {
    super.initState();
    bankData = Map<String, dynamic>.from(widget.data);
  }

  void _editBankDetails() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBankDetailsScreen(data: bankData),
      ),
    );

    if (updatedData != null && mounted) {
      setState(() {
        bankData = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: _editBankDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildDetailCard(context),
            const SizedBox(height: 20),
            _buildImageCard("PAN Card Photo", bankData["panCardPhoto"]),
            const SizedBox(height: 16),
            _buildImageCard("Bank Account Photo", bankData["bankAccountPhoto"]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(Iconsax.user, "Account Name", bankData["accountName"]),
            _buildDetailRow(Iconsax.card, "Account Number", bankData["accountNumber"]),
            _buildDetailRow(Iconsax.bank, "Bank Name", bankData["bankName"]),
            _buildDetailRow(Iconsax.building_3, "Branch Name", bankData["branchName"]),
            _buildDetailRow(Iconsax.code, "IFSC Code", bankData["ifscCode"]),
            _buildDetailRow(Iconsax.briefcase, "Account Type", bankData["accountType"]),
            _buildDetailRow(Iconsax.document, "PAN Number", bankData["panNumber"]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  value ?? "N/A",
                  style: const TextStyle(
                      fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String title, String? imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 12),
            if (imagePath != null && imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(imagePath),
                    width: double.infinity, height: 180, fit: BoxFit.cover),
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
                child: const Text("No Image Uploaded",
                    style: TextStyle(color: Colors.black54)),
              ),
          ],
        ),
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
  late TextEditingController _accountTypeController;
  late TextEditingController _panNumberController;

  String? _panCardPhoto;
  String? _bankAccountPhoto;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController(text: widget.data["accountName"]);
    _accountNumberController = TextEditingController(text: widget.data["accountNumber"]);
    _bankNameController = TextEditingController(text: widget.data["bankName"]);
    _branchNameController = TextEditingController(text: widget.data["branchName"]);
    _ifscCodeController = TextEditingController(text: widget.data["ifscCode"]);
    _accountTypeController = TextEditingController(text: widget.data["accountType"]);
    _panNumberController = TextEditingController(text: widget.data["panNumber"]);
    _panCardPhoto = widget.data["panCardPhoto"];
    _bankAccountPhoto = widget.data["bankAccountPhoto"];
  }

  Future<void> _pickImage(bool isPan) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isPan) {
          _panCardPhoto = picked.path;
        } else {
          _bankAccountPhoto = picked.path;
        }
      });
    }
  }

  void _saveDetails() {
    Navigator.pop(context, {
      "accountName": _accountNameController.text.trim(),
      "accountNumber": _accountNumberController.text.trim(),
      "bankName": _bankNameController.text.trim(),
      "branchName": _branchNameController.text.trim(),
      "ifscCode": _ifscCodeController.text.trim(),
      "accountType": _accountTypeController.text.trim(),
      "panNumber": _panNumberController.text.trim(),
      "panCardPhoto": _panCardPhoto,
      "bankAccountPhoto": _bankAccountPhoto,
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_accountNameController, "Account Name", Iconsax.user),
            _buildTextField(_accountNumberController, "Account Number", Iconsax.card),
            _buildTextField(_bankNameController, "Bank Name", Iconsax.bank),
            _buildTextField(_branchNameController, "Branch Name", Iconsax.building_3),
            _buildTextField(_ifscCodeController, "IFSC Code", Iconsax.code),
            _buildTextField(_accountTypeController, "Account Type", Iconsax.briefcase),
            _buildTextField(_panNumberController, "PAN Number", Iconsax.document),
            const SizedBox(height: 16),
            _buildImagePicker("PAN Card Photo", _panCardPhoto, () => _pickImage(true)),
            const SizedBox(height: 16),
            _buildImagePicker("Bank Account Photo", _bankAccountPhoto, () => _pickImage(false)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveDetails,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildImagePicker(String title, String? imagePath, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: imagePath != null && imagePath.isNotEmpty
                ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(imagePath), fit: BoxFit.cover))
                : const Center(child: Text("Tap to upload image")),
          ),
        ),
      ],
    );
  }
}
