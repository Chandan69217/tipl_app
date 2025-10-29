import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/bank_service_api.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/capitalize_first.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/connectivity/on_internet_screen.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';
import 'package:tipl_app/features/auth/sign_in_screen.dart';
import 'package:tipl_app/features/change_password/change_password.dart';
import 'package:tipl_app/features/navigations/bank_details/add_bank_details.dart';
import 'package:tipl_app/features/navigations/bank_details/view_bank_details.dart';
import 'package:tipl_app/features/navigations/user/edit_user_profile.dart';
import 'package:tipl_app/features/navigations/user/welcome_letter.dart';
import 'id_card.dart' show IdCardScreen;


class UserProfileScreen extends StatefulWidget {
  final bool canPop;
  const UserProfileScreen({this.canPop= false,super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  bool _isBankDetailsCompleted = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async{
    _isBankDetailsCompleted = await BankServiceAPI(context: context).isBankAccountUpdated();
    WidgetsBinding.instance.addPostFrameCallback((duration){
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: widget.canPop ? AppBar(
        title: Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_password') {
                showChangePasswordBottomSheet(context);
              }else if('view_card' == value){
                navigateWithAnimation(context, IdCardScreen());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'view_card',
                child: Text('View Card'),
              ),
              const PopupMenuItem(
                value: 'change_password',
                child: Text('Change Password'),
              ),
            ],
          ),
        ],
      ):null,
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: ConnectivityService().isConnected,
            builder: (context,value,child){
              if(value){
                return NoInternetScreen(onRetry: (){
                  setState(() {
                    Provider.of<UserProfileProvider>(context,listen: false).initialized();
                  });
                });
              }else{
                return Consumer<UserProfileProvider>(
                    builder: (context,value,child){
                      final user = value.data;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,),
                        child: Column(
                          children: [
                            // Profile Card
                            Stack(
                                children:
                                [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 16,),
                                      CustomNetworkImage(
                                        imageUrl: user.profile,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        user.fullName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        user.email,
                                        style: TextStyle(color: Colors.grey, height: 0),
                                      ),
                                      const SizedBox(height: 4,),
                                      Container(
                                        margin: EdgeInsets.only(right: 8.0),
                                        padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                                        decoration: BoxDecoration(
                                            color: user.status.toString().toLowerCase() == 'active'? Colors.green.withValues(alpha: 0.7):Colors.red.withValues(alpha: 0.7),
                                            borderRadius: BorderRadius.circular(20)
                                        ),
                                        child: Text(user.status,style: TextStyle(color: Colors.white),),
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
                                              icon: user.gender.toString().toLowerCase() == 'female' ? Iconsax.woman :Iconsax.man,
                                              label: 'Gender',
                                              value: capitalizeFirst(user.gender),
                                              iconColor: Colors.blueAccent
                                          ),
        
                                          // DOB
                                          profileInfoCard(
                                            icon: Iconsax.cake,
                                            label: 'DOB',
                                            value: user.dob,
                                            iconColor: Colors.green,
                                          ),
        
                                          // Marital
                                          profileInfoCard(
                                              icon: Iconsax.heart,
                                              label: 'Marital',
                                              value: capitalizeFirst(user.maritalStatus),
                                              iconColor: Colors.purpleAccent
                                          ),
                                          // Mobile
                                          profileInfoCard(
                                              icon: Iconsax.mobile,
                                              label: 'Mobile',
                                              value: user.mobileNo??'N/A',
                                              iconColor: Colors.orangeAccent
                                          ),
                                        ],
                                      ),
        
                                      const SizedBox(height: 20),
                                    ],
                                  ),
        
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   margin: EdgeInsets.only(right: 8.0),
                                          //   padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                                          //   decoration: BoxDecoration(
                                          //       color: user.status.toString().toLowerCase() == 'active'? Colors.green.withValues(alpha: 0.7):Colors.red.withValues(alpha: 0.7),
                                          //       borderRadius: BorderRadius.circular(20)
                                          //   ),
                                          //   child: Text(user.status,style: TextStyle(color: Colors.white),),
                                          // ),
                                          IconButton(onPressed: (){
                                            navigateWithAnimation(context, EditUserProfile(data: user,));
                                          }, icon: Icon(Iconsax.edit))
                                        ],
                                      ))
                                ]
                            ),
        
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                profileListTile(
                                  icon: Iconsax.document,
                                  title: "Welcome Letter",
                                  value: "View your welcome letter",
                                  onTap: (){
                                    navigateWithAnimation(context, WelcomeLetterScreen());
                                  },
                                  iconColor: Colors.orangeAccent,
                                ),
                                const Divider(),
                                profileListTile(
                                    onTap: (){
                                      navigateWithAnimation(context, _isBankDetailsCompleted ? ViewBankDetailsScreen():AddBankDetailsScreen(onSuccess: (){
                                        setState(() {
                                          _isBankDetailsCompleted = true;
                                        });
                                      },));
                                    },
                                    icon: Iconsax.bank,
                                    title: 'Bank Details',
                                    value: _isBankDetailsCompleted ? 'View your bank details' : 'Add your bank details',
                                    iconColor: Colors.pinkAccent
                                ),
                                const Divider(),
                                profileListTile(
                                  icon: Iconsax.key,
                                  title: "Member ID",
                                  value: user.memberId,
                                  iconColor: Colors.green,
                                ),
                                const Divider(),
                                profileListTile(
                                  icon: Iconsax.key,
                                  title: "Sponsor ID",
                                  value: user.sponsorId,
                                  iconColor: Colors.teal,
                                ),
                                const Divider(),
                                profileListTile(
                                  icon: Iconsax.user_edit,
                                  title: "Sponsor Name",
                                  value: user.sponsorName,
                                  iconColor: Colors.deepPurple,
                                ),
                                const Divider(),
        
                                profileListTile(
                                  icon: Iconsax.element_equal,
                                  title: "Position",
                                  value: user.position,
                                  iconColor: Colors.pinkAccent,
                                ),
                              ],
                            ),
                            // const SizedBox(height: 20,),
                            Divider(),
                            // Contact Details Card
                            addressDetailCard(user),
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
                );
              }
        
            }
        ),
      ),
    );
  }

  Widget profileListTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
    required Color iconColor,
  }) {
    return ListTile(
      onTap: onTap,
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

  Widget addressDetailCard(UserProfile user) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
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
          _detailRow("Address", user.address,),
          _detailRow("State", user.state,),
          _detailRow("District", user.district,),
          _detailRow("Pin Code", user.pinCode,),
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






