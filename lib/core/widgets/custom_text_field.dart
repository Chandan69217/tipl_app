import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String? value)? validate;
  final bool isRequired;
  final FieldType? fieldType;
  final bool readOnly;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final int? maxLine;
  final Widget? prefixIcon;
  final Function(String?)? onChange;
  final VoidCallback? onFocusLost;
  final String? hintText;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? textInputFormatter;
  final TextAlignVertical? textAlignVertical;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.isRequired = false,
    this.validate,
    this.textInputType,
    this.suffixIcon,
    this.maxLine =1,
    this.fieldType,
    this.textAlignVertical,
    this.prefixIcon,
    this.onChange,
    this.textInputAction,
    this.maxLength,
    this.onFocusLost,
    this.textInputFormatter,
    this.readOnly = false,
    this.hintText
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _visibility = false;
  final phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );
  final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d).{8,}$',
  );
  final addressRegex = RegExp(
    r'^(?=(?:.*[A-Za-z0-9]){1,})(?=(?:.*[A-Za-z0-9]){10,}).*$',
  );
  final pincodeRegex = RegExp(r'^[1-9][0-9]{5}$');

  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$'); // PAN
  final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$'); // IFSC
  final bankAccountRegex = RegExp(r'^[0-9]{9,18}$');  // Bank Account



  @override
  void initState() {
    super.initState();
    _visibility = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
            if(widget.isRequired)...[
              const SizedBox(width: 4,),
              Text('*',style: TextStyle(color: Colors.red),)
            ]
          ],
        ),
        const SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus){
            if(!hasFocus){
              widget.onFocusLost?.call();
            }
          },
          child: TextFormField(
            keyboardType: widget.textInputType,
            controller: widget.controller,
            textInputAction: widget.textInputAction,
            textAlignVertical: widget.textAlignVertical,
            obscureText: _visibility,
            onChanged: widget.onChange,
            readOnly: widget.readOnly,
            inputFormatters: widget.textInputFormatter,
            maxLines: widget.maxLine,
            maxLength: widget.maxLength,
            validator:  _validateByFieldType,
            decoration: InputDecoration(
              hintText: widget.hintText??widget.label,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(horizontal: 4,vertical: 14),
              prefixIcon: widget.prefixIcon,
              suffixIcon:widget.suffixIcon != null ? widget.suffixIcon: widget.obscureText ? IconButton(onPressed: (){
               if(mounted){
                 setState(() {
                   _visibility = !_visibility;
                 });
               }
              }, icon: Icon(
                _visibility ? Iconsax.eye_slash : Iconsax.eye
              )) : null
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

  }

  String? _validateByFieldType(String? value) {
    final text = value?.trim() ?? '';

    // if(!widget.isRequired && !FieldType.values.contains(widget.fieldType)){
    //   return null;
    // }
    // Required check
    if (widget.isRequired && text.isEmpty) {
      return 'Please enter ${widget.label}';
    }


    if (widget.validate != null) {
      return widget.validate!(value);
    }

    // Null-safe fieldType
    if (widget.fieldType == null) {
      return null;
    }

    switch (widget.fieldType!) {

      case FieldType.mobileNo:
        if (!phoneRegex.hasMatch(text)) {
          return 'Please enter valid 10-digit mobile number';
        }
        break;

      case FieldType.email:
        if (!emailRegex.hasMatch(text)) {
          return 'Please enter a valid email address';
        }
        break;

      case FieldType.password:
        if (!passwordRegex.hasMatch(text)) {
          return 'Password must be 8+ chars, 1 uppercase & 1 number';
        }
        break;

      case FieldType.address:
        final noSpaces = text.replaceAll(' ', '');

        if (noSpaces.length < 10) {
          return 'Address must be at least 10 characters';
        }

        if (!RegExp(r'[A-Za-z0-9]').hasMatch(text)) {
          return 'Address cannot contain only symbols';
        }
        break;

      case FieldType.pincode:
        if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(text)) {
          return 'Please enter valid 6-digit pincode';
        }
        break;

      case FieldType.pan:
        if (!panRegex.hasMatch(text.toUpperCase())) {
          return 'Please enter valid PAN number';
        }
        break;

      case FieldType.bankAccount:
        if (!bankAccountRegex.hasMatch(text)) {
          return 'Please enter valid bank account number';
        }
        break;

      case FieldType.ifsc:
        if (!ifscRegex.hasMatch(text.toUpperCase())) {
          return 'Please enter valid IFSC code';
        }
        break;
        default: break;
    }


    return null;
  }



}


enum FieldType {
  mobileNo,
  address,
  email,
  password,
  pincode,
  pan,
  bankAccount,
  ifsc,
  dateOfBirth,
}
