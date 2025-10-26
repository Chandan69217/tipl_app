import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/connectivity/on_internet_screen.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';


class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();


  static void show(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const UpdateProfile(),
    );

    if (result != null) {
      debugPrint("User Submitted Data: $result");
    }
  }
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController panController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? packageType;
  String? maritalStatus;
  DateTime? dateOfBirth;
  bool _isLoading = false;
  bool _initilizedData = false;
  late final Future<Map<String,dynamic>?> _profileData;


  @override
  void initState() {
    super.initState();
    _profileData = ProfileAPIService(context: context).getProfileDetailsByMemberId();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop,_){
        CustomMessageDialog.show(
            context,
            message: 'You have unsaved changes. Do you really want to close?',
          title: 'Exit',
          onConfirm: (){
              if(Platform.isAndroid){
                exit(1000);
              }
          },
          confirmText: "Exit",
          cancelText: "Cancel"
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        ),
        child: ValueListenableBuilder<bool>(
            valueListenable: ConnectivityService().isConnected,
            builder: (context,value,child){
              if(!value){
                return NoInternetScreen(onRetry: (){
                  setState(() {
                    _profileData = ProfileAPIService(context: context).getProfileDetailsByMemberId();
                  });
                });
              }else{
                return  FutureBuilder(
                    future: _profileData,
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CustomCircularIndicator();
                      }
                      final data = snapshot.data??{};
                      if(!_initilizedData){
                        packageType = data['package_type']??null;
                        _nameController.text = data['full_name']??'';
                        maritalStatus = data['marital_status']??null;
                        panController.text = data['pan_number']??'';
                        dateOfBirth = DateTime.tryParse(data['date_of_birth']??'');
                        _initilizedData = true;
                      }

                      return  Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Text(
                              "Basics Details",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Welcome! Before you continue, we need a few basic details to personalize your experience",
                              // style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Icon(Iconsax.user_add,size: 18,color:CustColors.majorelleBlue,),
                                const SizedBox(width: 6,),
                                Text("MEMBER ID: ${data['member_id']??'N/A'}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Package Type Dropdown
                            CustomDropdown(
                                label: "Package Type",
                                isRequired: true,
                                items: const [
                                  DropdownMenuItem(value: "Silver", child: Text("Silver")),
                                  DropdownMenuItem(value: "Gold", child: Text("Gold")),
                                  DropdownMenuItem(value: "Platinum", child: Text("Platinum")),
                                ],
                                value: packageType,
                                onChanged: (value) {
                                  setState(() => packageType = value!);
                                }
                            ),

                            const SizedBox(height: 16),

                            // Full Name
                            CustomTextField(
                              label: "Full Name",
                              controller: _nameController,
                              isRequired: true,
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomDatePickerTextField(
                                    label: 'Date Of Birth',
                                    isRequired: true,
                                    initialDate: dateOfBirth,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2500),
                                    onChanged: (selected) {
                                      dateOfBirth = selected;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomDropdown<String>(
                                    value: maritalStatus,
                                    items: ['Married', 'Single']
                                        .map<DropdownMenuItem<String>>(
                                          (v) => DropdownMenuItem(
                                        child: Text(v),
                                        value: v,
                                      ),
                                    )
                                        .toList(),
                                    label: 'Marital Status',
                                    isRequired: true,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          maritalStatus = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // PAN Number
                            CustomTextField(
                              label: "PAN Number",
                              controller: panController,
                              textInputFormatter: [
                                UpperCaseTextFormatter()
                              ],
                              isRequired: true,
                              maxLength: 10,
                            ),
                            const SizedBox(height: 20),

                            // Save Button
                            _isLoading ? CustomCircularIndicator() : CustomButton(
                                text: "Save",
                                iconData: Iconsax.message_edit,
                                onPressed: _saveDetails
                            ),

                          ],
                        ),
                      );
                    }
                );
              }
            }
        )
      ),
    );
  }


  void _saveDetails() async{
    if(!(_formKey.currentState?.validate()??false)){
      return;
    }

    if(ConnectivityService().isConnected.value){
      SnackBarHelper.show(context, message: 'No Internet Connection');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try{
      final url = Uri.https(Urls.baseUrl,Urls.UpdateProfile);
      final token = Pref.instance.getString(PrefConst.TOKEN)??'';

      final data = {
        "package_type": packageType,
        "full_name": _nameController.text,
        "marital_status": maritalStatus,
        "date_of_birth":
        "${dateOfBirth?.year}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}",
        "pan_number": panController.text.toUpperCase(),
      };

      final response = await post(url,headers: {
        'Content-type' : 'Application/json',
        'Authorization' : 'Bearer $token'
      },body: json.encode(data));

      printAPIResponse(response);
      if(response.statusCode == 200){
        CustomMessageDialog.show(context,
            title: 'Profile Updated',
            message: 'Your profile updated successfully',
          onConfirm: ()async{
            WidgetsBinding.instance.addPostFrameCallback((duration){
              Navigator.pop(context);
            });
          }
        );
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception} Trace: ${trace}');
    }

   if(mounted){
     setState(() {
       _isLoading = false;
     });
   }

  }


}


