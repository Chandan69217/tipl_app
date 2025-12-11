import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/widgets/custom_button.dart';
import 'package:tipl_app/core/widgets/custom_text_field.dart';

class TransactionPasswordSheet extends StatefulWidget {
  const TransactionPasswordSheet({super.key});

  @override
  State<TransactionPasswordSheet> createState() =>
      _TransactionPasswordSheetState();

  static   Future<String?> showTransactionPasswordSheet(BuildContext context) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const TransactionPasswordSheet(),
    );
  }
}

class _TransactionPasswordSheetState extends State<TransactionPasswordSheet> {
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Enter Transaction Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            Text(
              "For security, please confirm your transaction password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'Transaction Password',
              controller: passCtrl,
              prefixIcon: Icon(Iconsax.password_check),
              isRequired: true,
              obscureText: obscure,
              textInputType: TextInputType.visiblePassword,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Confirm Payment',
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;

                Navigator.pop(context, passCtrl.text.trim());
              },
              color: Colors.black,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}