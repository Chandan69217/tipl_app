import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/features/auth/sign_in_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    final Map<String, dynamic> user = {
      "full_name": "Chandan Sharma",
      "sponsor_code": "TIPL275542",
      "sponsor_name": "Amit Verma",
      "position": "Left",
      "pan": "ABCDE1234F",
      "dob": "1990-05-12",
      "gender": "Male",
      "marital_status": "Married",
      "email": "rohit.sharma@example.com",
      "mobile": "+91 9876543210",
      "state": "Maharashtra",
      "district": "Pune",
      "address": "123 Finance Street, Pune",
      "pin_code": "411001",
      "status": "Active",
      "agree_tnc": true,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Chandan Sharma',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                'chandansharma69217@gmail.com',
                style: TextStyle(color: Colors.grey, height: 0),
              ),
              const SizedBox(height: 20),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  // Gender

                  profileInfoCard(
                    icon: Iconsax.man,
                    label: 'Gender',
                    value: 'Male',
                    iconColor: Colors.blueAccent
                  ),

                  // DOB
                  profileInfoCard(
                    icon: Iconsax.cake,
                    label: 'DOB',
                    value: '03-09-2004',
                    iconColor: Colors.green,
                  ),

                  // Marital
                  profileInfoCard(
                    icon: Iconsax.heart,
                    label: 'Marital',
                    value: 'Single',
                    iconColor: Colors.purpleAccent
                  ),
                  // Mobile
                  profileInfoCard(
                    icon: Iconsax.mobile,
                    label: 'Mobile',
                    value: '8969897543',
                    iconColor: Colors.orangeAccent
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileListTile(
                icon: Iconsax.key,
                title: "Sponsor ID",
                value: "TIPL275542",
                iconColor: Colors.teal,
              ),
              const Divider(),
              profileListTile(
                icon: Iconsax.user_edit,
                title: "Sponsor Name",
                value: "Ramesh Kumar",
                iconColor: Colors.deepPurple,
              ),
              const Divider(),

              profileListTile(
                icon: Iconsax.element_equal,
                title: "Position",
                value: "Left",
                iconColor: Colors.pinkAccent,
              ),
            ],
          ),
          // const SizedBox(height: 20,),

          // Contact Details Card
         addressDetailCard(),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Log Out',
            color: Colors.red,
            iconData: Iconsax.logout,
            onPressed: (){
             Pref.Logout();
              navigatePushAndRemoveUntilWithAnimation(context, SignInScreen());
          },)
        ],
      ),
    );
  }

  Widget profileListTile({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(value),
    );
  }


  Widget profileInfoCard({
    required IconData icon,
    required String label,
    required String value,
    Color iconColor = Colors.purpleAccent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: CustColors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget addressDetailCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withValues(alpha: 0.05),
          //   blurRadius: 12,
          //   offset: const Offset(0, 6),
          // ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on, color: Colors.teal, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Static rows
          _detailRow("Address", "123 Main Street, Central Town"),
          _detailRow("State", "Karnataka"),
          _detailRow("District", "Bangalore"),
          _detailRow("Pin Code", "560001"),
        ],
      ),
    );
  }

// Row style
  Widget _detailRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }


}






