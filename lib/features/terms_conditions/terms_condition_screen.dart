import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key, this.onAccepted});
  final VoidCallback? onAccepted;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.fileText,
                    size: 32,
                    color: primary,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "Please read carefully",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primary.withOpacity(0.9),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Divider(thickness: 0.4, color: Colors.grey.shade300),
              const SizedBox(height: 14),

              /// 1️⃣ Eligibility & Identity
              _section(
                icon: LucideIcons.userCheck,
                title: "Eligibility & Identity",
                text:
                "• I certify that I am an Indian Citizen and resident of India.\n"
                    "• I confirm that I am 18 years of age or older.\n"
                    "• I declare that all personal information provided is accurate and belongs to me.",
              ),

              _divider(),

              /// 2️⃣ Sponsor & Association
              _section(
                icon: LucideIcons.link,
                title: "Sponsor & Association",
                text:
                "• My account is linked to the Sponsor ID provided during registration.\n"
                    "• My activities may be monitored by the Sponsor and Parent Bank for compliance.",
              ),

              _divider(),

              /// 3️⃣ KYC & Documentation
              _section(
                icon: LucideIcons.creditCard,
                title: "KYC & Documentation",
                text:
                "• I give voluntary consent for Aadhaar, PAN, and other KYC verification as per RBI guidelines.\n"
                    "• Failure to provide valid documents may lead to account suspension or rejection.",
              ),

              _divider(),

              /// 4️⃣ Security & Liability
              _section(
                icon: LucideIcons.shieldAlert,
                title: "Security & Liability",
                text:
                "• OTP, MPIN, and passwords are strictly confidential.\n"
                    "• I will never share credentials with anyone, including company staff.\n"
                    "• The company is not liable for losses due to credential sharing.",
              ),

              _divider(),

              /// 5️⃣ Wallet & Transactions
              _section(
                icon: LucideIcons.wallet,
                title: "Wallet & Transactions",
                text:
                "• The platform will be used only for legal financial transactions.\n"
                    "• Transaction limits apply as per RBI and bank rules.\n"
                    "• Applicable service charges or MDR may be deducted.",
              ),

              _divider(),

              /// 6️⃣ Fraud & Termination
              _section(
                icon: LucideIcons.ban,
                title: "Fraud & Termination",
                text:
                "• Fraud, money laundering, or illegal activity will result in immediate termination.\n"
                    "• The company reserves the right to block accounts without prior notice.",
              ),

              const SizedBox(height: 24),

              /// Disclaimer
              Text(
                "⚠️ Disclaimer: This service operates under RBI guidelines. "
                    "All activities are subject to regulatory compliance.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
                ),
              ),

              const SizedBox(height: 28),

              /// Agree button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    onAccepted?.call();
                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "I Agree & Continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.45,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        thickness: 0.4,
        color: Colors.grey.shade300,
      ),
    );
  }
}

