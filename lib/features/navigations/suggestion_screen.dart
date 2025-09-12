import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  String selectedCategory = "Complaint";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  File? selectedImage;

  // Pick image from gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }


  void _handleSubmit() {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      // SnackBarHelper.show(
      //   context,
      //  message: "Please fill in all required fields",
      // );
      CustomMessageDialog.show(
        context,
        title: "Success",
        message: "Your complaint has been submitted successfully!",
        icon: Icons.check_circle,
        iconColor: Colors.green,
        confirmText: "OK",
      );
      return;
    }

    debugPrint("Category: $selectedCategory");
    debugPrint("Title: ${titleController.text}");
    debugPrint("Description: ${descController.text}");
    debugPrint("Image: ${selectedImage?.path ?? 'No image'}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Your feedback has been submitted!")),
    );

    // Clear form
    titleController.clear();
    descController.clear();
    setState(() {
      selectedCategory = "Complaint";
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xffb6d9e8), Color(0xffd9f0e9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Iconsax.message,
                      size: 26, color: Color(0xff1f3f3f)),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    "We value your feedback!\nShare your complaint or suggestion with us.",
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Complaint / Suggestion Type
          const Text("Select Category",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => selectedCategory = "Complaint"),
                child: _chip(Iconsax.warning_2, "Complaint",
                    selected: selectedCategory == "Complaint"),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () =>
                    setState(() => selectedCategory = "Suggestion"),
                child: _chip(Iconsax.lamp_on, "Suggestion",
                    selected: selectedCategory == "Suggestion"),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Title Input
          CustomTextField(
            label: 'Title',
            controller: titleController,
            hintText: "Enter a short title",
            prefixIcon: Icon(Iconsax.edit),
          ),

          const SizedBox(height: 20),

          CustomTextField(
              label: 'Description',
              controller: descController,
            prefixIcon: Icon(Iconsax.note_text),
            maxLine: 5,
            hintText: "Describe your issue or suggestion...",
          ),

          const SizedBox(height: 25),

          // Upload Image (optional)
          InkWell(
            onTap: _pickImage,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.image, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      selectedImage == null
                          ? "Attach screenshot (optional)"
                          : "Image selected: ${selectedImage!.path.split('/').last}",
                      style: TextStyle(color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (selectedImage != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(selectedImage!,
                  height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          ],

          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: _handleSubmit,
              iconData: Iconsax.send_2,
              color: const Color(0xff1f3f3f),
              text: 'Submit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xff1f3f3f) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: selected ? Colors.white : const Color(0xff1f3f3f)),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                  selected ? Colors.white : const Color(0xff1f3f3f))),
        ],
      ),
    );
  }
}
