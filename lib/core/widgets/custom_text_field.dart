import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String? value)? validate;
  final bool isRequired;
  final bool readOnly;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final int? maxLine;
  final Widget? prefixIcon;
  final Function(String?)? onChange;
  final VoidCallback? onFocusLost;
  final String? hintText;
  final int? maxLength;
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
    this.textAlignVertical,
    this.prefixIcon,
    this.onChange,
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
            textAlignVertical: widget.textAlignVertical,
            obscureText: _visibility,
            onChanged: widget.onChange,
            readOnly: widget.readOnly,
            inputFormatters: widget.textInputFormatter,
            maxLines: widget.maxLine,
            maxLength: widget.maxLength,
            validator: widget.validate ?? (widget.isRequired ? (value){
              if(value == null || value.isEmpty){
                return 'Please enter ${widget.label}';
              }
              if(widget.textInputType == TextInputType.phone && value.length < 10){
                return 'Please enter valid mobile no.';
              }
              return null;
            }:null),
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
}
