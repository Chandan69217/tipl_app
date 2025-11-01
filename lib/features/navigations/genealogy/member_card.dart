import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class MemberCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool active;
  final String? position;
  final VoidCallback? onTap;

  const MemberCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.active = true,
    this.onTap,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14,right: 8,left: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: active
              ? [Colors.green.shade50, Colors.green.shade100]
              : [Colors.red.shade50, Colors.red.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          child: Icon(
            active ? Iconsax.user : Iconsax.user_remove,
            color: active ? Colors.green : Colors.red,
            size: 28,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xff1f3f3f),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: Colors.grey.shade400,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }
}
