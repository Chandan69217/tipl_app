import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool isRequired;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isRequired = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
            if(isRequired)...[
              const SizedBox(width: 4,),
              Text('*',style: TextStyle(color: Colors.red),)
            ]
          ],
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          menuMaxHeight: 300,
          initialValue: value,
          isExpanded: true,
          onChanged: onChanged,
          items: [
            DropdownMenuItem(child: Text('Select $label'),value: null,),
            ...items
          ],
          validator: (val) {
            if (isRequired && val == null) {
              return "Please select $label";
            }
            if (validator != null) return validator!(val);
            return null;
          },
        ),
      ],
    );
  }
}
