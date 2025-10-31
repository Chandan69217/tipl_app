import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/TextFieldFormatter/uppercase_formatter.dart';
import 'package:tipl_app/core/utilities/connectivity/connectivity_service.dart';
import 'package:tipl_app/core/utilities/cust_colors.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_circular_indicator.dart';
import 'package:tipl_app/core/widgets/custom_date_picker_text_field.dart';
import 'package:tipl_app/core/widgets/custom_dropdown.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';
import 'package:tipl_app/core/widgets/snackbar_helper.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key,this.canPop = false});
  final bool canPop;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _sponsorIdController = TextEditingController();
  final TextEditingController _sponsorNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _panCardController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  // dropdown selection
  String? _selectedPosition;
  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedState;
  String? _selectedDistrict;
  bool _isSponsorIDValid = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: CustColors.white,
      ),
      child: Scaffold(
        appBar: widget.canPop ? AppBar(
          title: Text('Register new user'),
        ) : null,
        body: Stack(
          children: [
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    children: [
                      if(!widget.canPop)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 36,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: CustColors.darkGradient,
                        ),
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 18),
                              Text(
                                "Sign up for a\nNew Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    "Already have an account? ",
                                    style: TextStyle(
                                      color: CustColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                      ).popUntil((route) => route.isFirst);
                                    },
                                    child: Text(
                                      "Log In",
                                      style: TextStyle(
                                        color: CustColors.blue,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          child: Column(
                            children: [
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
                              CustomTextField(
                                label: 'Full Name',
                                controller: _fullNameController,
                                isRequired: true,
                              ),
                              // const SizedBox(height: 16),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: CustomDropdown(
                              //         label: 'Position',
                              //         items: [],
                              //         value: _selectedPosition,
                              //         isRequired: true,
                              //         onChanged: (value) {},
                              //       ),
                              //     ),
                              //     const SizedBox(width: 12),
                              //     Expanded(
                              //       child: CustomTextField(
                              //         label: 'Pan',
                              //         isRequired: true,
                              //         controller: _panCardController,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(height: 16),
                              // Gender && Marital Status
                              CustomDropdown<String>(
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: CustomDropdown<String>(
                              //         value: _selectedGender,
                              //         items: ['Male', 'Female', 'Other']
                              //             .map<DropdownMenuItem<String>>(
                              //               (v) => DropdownMenuItem(
                              //                 child: Text(v),
                              //                 value: v,
                              //               ),
                              //             )
                              //             .toList(),
                              //         label: 'Gender',
                              //         isRequired: true,
                              //         onChanged: (value) {
                              //           if (mounted) {
                              //             setState(() {
                              //               _selectedGender = value;
                              //             });
                              //           }
                              //         },
                              //       ),
                              //     ),
                              //     const SizedBox(width: 12),
                              //     Expanded(
                              //       child: CustomDropdown<String>(
                              //         value: _selectedMaritalStatus,
                              //         items: ['Married', 'Single']
                              //             .map<DropdownMenuItem<String>>(
                              //               (v) => DropdownMenuItem(
                              //                 child: Text(v),
                              //                 value: v,
                              //               ),
                              //             )
                              //             .toList(),
                              //         label: 'Marital Status',
                              //         onChanged: (value) {
                              //           if (mounted) {
                              //             setState(() {
                              //               _selectedGender = value;
                              //             });
                              //           }
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
                              // const SizedBox(height: 16),
                              //
                              // CustomDatePickerTextField(
                              //   label: 'Date Of Birth',
                              //   firstDate: DateTime(1900),
                              //   lastDate: DateTime(2500),
                              //   onChanged: (selected) {},
                              // ),
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: CustomDropdown(
                              //         label: 'State',
                              //         value: _selectedState,
                              //         items: [],
                              //         onChanged: (value) {},
                              //         isRequired: true,
                              //       ),
                              //     ),
                              //     const SizedBox(width: 12),
                              //     Expanded(
                              //       child: CustomDropdown(
                              //         label: 'District',
                              //         value: _selectedDistrict,
                              //         items: [],
                              //         isRequired: true,
                              //         onChanged: (value) {},
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Pin Code',
                                controller: _pinCodeController,
                                isRequired: true,
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
                              // const SizedBox(height: 16),
                              // CustomTextField(
                              //   label: "Set Password",
                              //   obscureText: true,
                              //   controller: _passwordController,
                              //   isRequired: true,
                              //   textInputType: TextInputType.visiblePassword,
                              // ),
                              const SizedBox(height: 16.0),
                              if(!widget.canPop)
                              FormField<bool>(
                                initialValue: false,
                                validator: (value) {
                                  if (value == null || value == false) {
                                    return 'You must agree to the terms';
                                  }
                                  return null;
                                },
                                builder: (state) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: state.value,
                                            onChanged: (value) {
                                              state.didChange(value);
                                            },
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'I Agree Terms And Conditions.',
                                            style: TextStyle(
                                              color: CustColors.grey,
                                            ),
                                          ),
                                          // RichText(
                                          //   text: TextSpan(
                                          //     style: TextStyle(color: CustColors.grey),
                                          //     text: 'I Agree',
                                          //     children: [
                                          //       TextSpan(
                                          //         text: ' Terms ',
                                          //         style: TextStyle(
                                          //           color: Colors.black,
                                          //           fontWeight: FontWeight.bold
                                          //         ),
                                          //         recognizer: TapGestureRecognizer()..onTap = (){
                                          //
                                          //         }
                                          //       ),
                                          //       TextSpan(
                                          //         text: 'And'
                                          //       ),
                                          //       TextSpan(
                                          //         text: ' Conditions',
                                          //           style: TextStyle(
                                          //               color: Colors.black,
                                          //               fontWeight: FontWeight.bold
                                          //           ),
                                          //           recognizer: TapGestureRecognizer()..onTap = (){
                                          //
                                          //           }
                                          //       )
                                          //     ]
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      if (state.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                          ),
                                          child: Text(
                                            state.errorText!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _isLoading ? CustomCircularIndicator() :CustomButton(
                                iconData: Iconsax.edit,
                                onPressed: _onSignUp,
                                text: 'Sign Up',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 8,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sponsorIdController.dispose();
    _sponsorNameController.dispose();
    _fullNameController.dispose();
    _panCardController.dispose();
    _emailController.dispose();
    _mobileIdController.dispose();
    _passwordController.dispose();
    _pinCodeController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _onSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final isConnected = ConnectivityService().isConnected;
    if(isConnected.value){
      SnackBarHelper.show(context, message: "No Internet Connection");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try{
      final url = Uri.https(Urls.baseUrl,Urls.register);
      final body = {
        "full_name": _fullNameController.text,
        "gender": _selectedGender,
        "mobile_no": _mobileIdController.text,
        "email": _emailController.text,
        "state": _stateController.text,
        "district": _districtController.text,
        "address": _addressController.text,
        "pin_code": _pinCodeController.text,
        "sponsor_id": _sponsorIdController.text,
        //"transaction_password": "1234"
      };

      final response = await post(url,headers: {
        'Content-type' : 'Application/json',
      },body: json.encode(body));

      printAPIResponse(response);
      if(response.statusCode == 200){
        final value = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = value['isSuccess']??false;
        final message = value['message'];
        if(isSuccess){
          CustomMessageDialog.show(context, title: 'Registration Success', message: message,onConfirm: (){
            Navigator.pop(context);
          });
        }else{
          CustomMessageDialog.show(context, title: 'Registration Failed', message: message,);
        }
      }else{
        handleApiResponse(context, response);
      }

    }catch(exception,trace){
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




