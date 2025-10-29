import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BankDetailsViewScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const BankDetailsViewScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String? panPhoto = data['pan_card_photo'];
    final String? bankPhoto = data['bank_account_photo'];
    final String baseUrl = "https://your-base-url.com/"; // TODO: replace

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailTile("Account Name", data['account_name']),
            _buildDetailTile("Account Number", data['account_no']),
            _buildDetailTile("Bank Name", data['bank_name']),
            _buildDetailTile("Branch Name", data['branch_name']),
            _buildDetailTile("IFSC Code", data['ifsc_code']),
            _buildDetailTile("Account Type", data['account_type']),
            _buildDetailTile("PAN Number", data['pan_number']),
            const SizedBox(height: 20),
            _buildImageCard("PAN Card Photo", panPhoto, baseUrl),
            const SizedBox(height: 16),
            _buildImageCard("Bank Account Photo", bankPhoto, baseUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Iconsax.document, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value ?? "N/A"),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String title, String? imagePath, String baseUrl) {
    final bool isNetworkImage =
        imagePath != null && imagePath.startsWith('http');

    final String fullImageUrl =
    isNetworkImage ? imagePath! : (imagePath != null ? "$baseUrl$imagePath" : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: fullImageUrl.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: fullImageUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
            errorWidget: (context, url, error) => Container(
              height: 180,
              alignment: Alignment.center,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          )
              : Container(
            width: double.infinity,
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("No Image Uploaded",
                style: TextStyle(color: Colors.black54)),
          ),
        ),
      ],
    );
  }
}
