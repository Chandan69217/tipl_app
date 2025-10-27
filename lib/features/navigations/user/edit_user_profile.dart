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

class EditUserProfile extends StatefulWidget {
  final UserProfile data;
  EditUserProfile({super.key, required this.data});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileIdController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  // dropdown selection

  String? _selectedGender;
  String? _selectedMaritalStatus;
  DateTime? _selectedDOB;
  String? _selectedProfUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialized();
  }

  void _initialized() async {
    _selectedGender = widget.data.gender != 'N/A' ? widget.data.gender.toLowerCase() : null;
    _selectedMaritalStatus = widget.data.maritalStatus != 'N/A'? widget.data.maritalStatus.toLowerCase():null;
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
      body: SingleChildScrollView(
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
                    CustomTextField(
                      prefixIcon: Icon(Iconsax.mobile),
                      label: 'Mobile',
                      textInputType: TextInputType.phone,
                      controller: _mobileIdController,
                      maxLength: 10,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      prefixIcon: Icon(Iconsax.directbox_send),
                      label: "Email",
                      isRequired: true,
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    CustomDatePickerTextField(
                      label: 'Date Of Birth',
                      initialDate: _selectedDOB,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2500),
                      onChanged: (selected) {
                        _selectedDOB = selected;
                      },
                    ),
                    const SizedBox(height: 16),
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
                      textInputType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Address',
                      isRequired: true,
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
      final updatedData = UserProfile(
          memberId: 'N/A',
          panNumber: 'N/A',
          packageType: 'N/A',
          profile: _selectedProfUrl??'N/A',
          maritalStatus: _selectedMaritalStatus??'N/A',
          dob: _selectedDOB != null ? '${_selectedDOB?.year}-${_selectedDOB?.month}-${_selectedDOB?.day}':'N/A',
          sponsorId: 'N/A',
          sponsorName: 'N/A',
          position: 'N/A',
          fullName: _fullNameController.text,
          mobileNo: _mobileIdController.text,
          email: _emailController.text,
          gender: _selectedGender??'N/A',
          state: _stateController.text,
          district: _districtController.text,
          status: 'N/A',
          pinCode: _pinCodeController.text,
          address: _addressController.text,
          createdAt: DateTime.now()
      );

      await Provider.of<UserProfileProvider>(context,listen: false).updateProfile(updatedData);
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
}
