import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? iconData;
  final Color? color;
  const CustomButton({
    super.key,
    required this.text,
    this.iconData,
    required this.onPressed,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        iconAlignment: IconAlignment.end,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        label: Text(text),
        onPressed: onPressed,
        icon: iconData != null ? Icon(iconData,color: Colors.white,) : null,
      ),
    );
  }
}
