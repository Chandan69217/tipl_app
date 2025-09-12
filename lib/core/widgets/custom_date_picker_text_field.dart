import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';

class CustomDatePickerTextField extends StatefulWidget {
  final String label;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onChanged;
  final bool  isRequired;


  const CustomDatePickerTextField({
    super.key,
    required this.label,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.isRequired = false,
    required this.onChanged,
  });

  @override
  State<CustomDatePickerTextField> createState() => _CustomDatePickerTextFieldState();
}

class _CustomDatePickerTextFieldState extends State<CustomDatePickerTextField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: AbsorbPointer(
          child: CustomTextField(
            controller: TextEditingController(
              text: _selectedDate == null
                  ? ""
                  : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
            ),
            label: widget.label,
            isRequired: widget.isRequired,
            suffixIcon: Icon(Iconsax.calendar_edit),
          )
      ),
    );
   
  }
}
