import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/image_viewer_screen.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

class BankDetailsViewScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool accessProfile;

  const BankDetailsViewScreen({super.key, required this.data,this.accessProfile = false});

  @override
  Widget build(BuildContext context) {
    final String? panPhoto = data['pan_card_photo'];
    final String? bankPhoto = data['bank_account_photo'];
    final String baseUrl = "https://${Urls.baseUrl}/";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bank Details"),
      ),
      body:  SingleChildScrollView(
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
              if(accessProfile)
              CustomButton(text: 'View Profile', onPressed: (){},iconData: Iconsax.user,),
            ],
          ),
        ),
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
