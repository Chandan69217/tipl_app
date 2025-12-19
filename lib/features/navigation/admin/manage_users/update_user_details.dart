import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_network_image.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  final UserProfile data;
  UpdateUserDetailsScreen({super.key, required this.data});

  @override
  State<UpdateUserDetailsScreen> createState() => _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final TextEditingController _sponsorIdController = TextEditingController();
  final TextEditingController _sponsorNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileIdController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _panNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  // dropdown selection

  String? _selectedGender;
  String? _selectedPackageType;
  String? _selectedStatus;
  String? _selectedMaritalStatus;
  DateTime? _selectedDOB;
  String? _selectedProfUrl;
  bool _isSponsorIDValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialized();
  }

  void _initialized() async {
    _sponsorIdController.text = widget.data.sponsorId != 'N/A' ? widget.data.sponsorId:'';
    _sponsorNameController.text = widget.data.sponsorName != 'N/A' ? widget.data.sponsorName:'';
    _panNumberController.text = widget.data.panNumber != 'N/A' ? widget.data.panNumber:'';
    _selectedGender = widget.data.gender != 'N/A' ? widget.data.gender.toLowerCase() : null;
    _selectedMaritalStatus = widget.data.maritalStatus != 'N/A'? widget.data.maritalStatus.toLowerCase():null;
    _selectedPackageType = widget.data.packageType != 'N/A'? widget.data.packageType.toLowerCase():null;
    _selectedStatus = widget.data.status != 'N/A'? widget.data.status.toLowerCase():null;
    _selectedDOB = widget.data.dob != 'N/A' ? DateTime.tryParse(widget.data.dob) : null;
    _selectedProfUrl = widget.data.profile;
    _fullNameController.text = widget.data.fullName != 'N/A'
        ? widget.data.fullName
        : '';

    _emailController.text = widget.data.email != 'N/A' ? widget.data.email : '';

    _mobileIdController.text = widget.data.mobileNo != 'N/A'
        ? widget.data.mobileNo
        : '';

    _pinCodeController.text = widget.data.pinCode != 'N/A'
        ? widget.data.pinCode
        : '';

    _stateController.text = widget.data.state != 'N/A' ? widget.data.state : '';

    _districtController.text = widget.data.district != 'N/A'
        ? widget.data.district
        : '';
    _addressController.text = widget.data.address != 'N/A' ? widget.data.address:'';

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustColors.white,
      appBar: AppBar(title: Text('Update Profile')),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    children: [
                      CustomNetworkImage(),
                      const SizedBox(height: 40,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: "Sponsor ID",
                              isRequired: true,
                              validate: (value){
                                if(value == null || value.isEmpty){
                                  return 'Please enter Sponsor ID';
                                }
                                if(!_isSponsorIDValid){
                                  return 'Please enter a valid sponsor ID';
                                }
                                return null;
                              },
                              textInputFormatter: [
                                UpperCaseTextFormatter()
                              ],
                              onFocusLost: _getSponsorDetails,
                              controller: _sponsorIdController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              label: 'Sponsor Name',
                              readOnly: true,
                              controller: _sponsorNameController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // package type && status
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown(
                                label: "Package Type",
                                isRequired: true,
                                items: const [
                                  DropdownMenuItem(value: "silver", child: Text("Silver")),
                                  DropdownMenuItem(value: "gold", child: Text("Gold")),
                                  DropdownMenuItem(value: "platinum", child: Text("Platinum")),
                                ],
                                value: _selectedPackageType,
                                onChanged: (value) {
                                  setState(() => _selectedPackageType = value!);
                                }
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropdown<String>(
                              value: _selectedStatus,
                              items: ['Active', 'Inactive']
                                  .map<DropdownMenuItem<String>>(
                                    (v) => DropdownMenuItem(
                                  child: Text(v),
                                  value: v.toLowerCase(),
                                ),
                              )
                                  .toList(),
                              label: 'Status',
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    _selectedStatus = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Full Name',
                        controller: _fullNameController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      // Gender && Marital Status
                      Row(
                        children: [
                          Expanded(
                            child: CustomDropdown<String>(
                              value: _selectedGender,
                              items: ['Male', 'Female', 'Other']
                                  .map<DropdownMenuItem<String>>(
                                    (v) => DropdownMenuItem(
                                  child: Text(v),
                                  value: v.toLowerCase(),
                                ),
                              )
                                  .toList(),
                              label: 'Gender',
                              isRequired: true,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    _selectedGender = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomDropdown<String>(
                              value: _selectedMaritalStatus,
                              items: ['Married', 'Single']
                                  .map<DropdownMenuItem<String>>(
                                    (v) => DropdownMenuItem(
                                  child: Text(v),
                                  value: v.toLowerCase(),
                                ),
                              )
                                  .toList(),
                              label: 'Marital Status',
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    _selectedMaritalStatus = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // CustomTextField(
                      //   prefixIcon: Icon(Iconsax.mobile),
                      //   label: 'Mobile',
                      //   textInputType: TextInputType.phone,
                      //   controller: _mobileIdController,
                      //   maxLength: 10,
                      //   isRequired: true,
                      // ),
                      // const SizedBox(height: 16),
                      // CustomTextField(
                      //   prefixIcon: Icon(Iconsax.directbox_send),
                      //   label: "Email",
                      //   isRequired: true,
                      //   controller: _emailController,
                      //   textInputType: TextInputType.emailAddress,
                      // ),
                      // const SizedBox(height: 16),

                      CustomDatePickerTextField(
                        label: 'Date Of Birth',
                        initialDate: _selectedDOB,
                        fieldType: FieldType.dateOfBirth,
                        firstDate: DateTime(1925),
                        lastDate: DateTime.now(),
                        onChanged: (selected) {
                          _selectedDOB = selected;
                        },
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Pan Number',
                        controller: _panNumberController,
                        fieldType: FieldType.pan,
                        textInputFormatter: [
                          UpperCaseTextFormatter()
                        ],
                        textInputType: TextInputType.text,
                        maxLength: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'State',
                              isRequired: true,
                              controller: _stateController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              label: 'District',
                              isRequired: true,
                              controller: _districtController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Pin Code',
                        controller: _pinCodeController,
                        isRequired: true,
                        fieldType: FieldType.pincode,
                        textInputType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Address',
                        isRequired: true,
                        fieldType: FieldType.address,
                        textAlignVertical: TextAlignVertical.center,
                        textInputType: TextInputType.streetAddress,
                        controller: _addressController,
                        maxLine: 3,
                      ),

                      const SizedBox(height: 16.0),

                      _isLoading
                          ? CustomCircularIndicator()
                          : CustomButton(
                        iconData: Iconsax.edit,
                        onPressed: _onSaveChanges,
                        text: 'Save Changes',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileIdController.dispose();
    _pinCodeController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _sponsorIdController.dispose();
    _sponsorNameController.dispose();
    _panNumberController.dispose();
    super.dispose();
  }

  void _onSaveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final isConnected = ConnectivityService().isConnected;
    if (isConnected.value) {
      SnackBarHelper.show(context, message: "No Internet Connection");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      final isUpdated = await Provider.of<AllUserDetailsProvider>(context,listen: false).updateUserDetails(
          userMemberID: widget.data.memberId,
        sponsor_id: _sponsorIdController.text,
        pincode: _pinCodeController.text,
        pan_number: _panNumberController.text,
        package_type: _selectedPackageType,
        marital_status: _selectedMaritalStatus,
        gender: _selectedGender,
        full_name: _fullNameController.text,
        dob: _selectedDOB != null ? "${_selectedDOB?.year}-${_selectedDOB?.month}-${_selectedDOB?.day}" :null,
        district: _districtController.text,
        address: _addressController.text,
        state: _stateController.text,
        status: _selectedStatus,
      );

      if(isUpdated)
      CustomMessageDialog.show(context, title: 'Profile Updated', message: 'Your changes have been saved.',onConfirm: (){
        Navigator.of(context).pop();
      });

    } catch (exception, trace) {
      print('Exception: ${exception},Trace: ${trace}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _getSponsorDetails()async {
    try{
      final sponsor_id = _sponsorIdController.text;
      final connectivity = ConnectivityService();
      if(sponsor_id.isEmpty || connectivity.isConnected.value)
        return;

      final url = Uri.https(Urls.baseUrl,Urls.getUserDetailsBySponserId,{
        'sponsor_id' : sponsor_id
      });
      final response = await get(url,headers: {
        'Content-type' : 'Application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        final data = body['data'] as List<dynamic>;
        if(status && data.isNotEmpty){
          final sponsor_name = data.first['sponsor_name']??'';
          setState(() {
            _sponsorNameController.text = sponsor_name;
            _isSponsorIDValid = true;
          });
        }else{
          final message = body['message'];
          CustomMessageDialog.show(context, title: 'Sponsor Details', message: message);
          setState(() {
            _sponsorNameController.text = '';
            _isSponsorIDValid = false;
          });
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(excpetion,trace){
      print("Exception: ${excpetion},Trace: ${trace}");
    }
  }

}
