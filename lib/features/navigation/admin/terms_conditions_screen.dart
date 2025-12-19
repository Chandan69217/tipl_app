// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';
//
// class TermsAndConditionsScreen extends StatelessWidget {
//   const TermsAndConditionsScreen({super.key,this.onAccepted});
//   final VoidCallback? onAccepted;
//   @override
//   Widget build(BuildContext context) {
//     final primary = Theme.of(context).primaryColor;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Terms & Conditions",
//         ),
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Header icon
//               Center(
//                 child: Container(
//                   padding: const EdgeInsets.all(18),
//                   decoration: BoxDecoration(
//                     color: primary.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     LucideIcons.fileText,
//                     size: 32,
//                     color: primary,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               Center(
//                 child: Text(
//                   "Please read carefully",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: primary.withOpacity(0.9),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//               Divider(thickness: 0.4, color: Colors.grey.shade300),
//
//               const SizedBox(height: 14),
//
//               _section(
//                 icon: LucideIcons.checkCircle2,
//                 title: "Acceptance of Terms",
//                 text:
//                 "By using this application, you agree to follow these Terms & Conditions. Your continued usage means acceptance of any future changes.",
//               ),
//
//               _divider(),
//
//               _section(
//                 icon: LucideIcons.user,
//                 title: "User Responsibilities",
//                 text:
//                 "You must provide valid information and keep your account credentials confidential. You are responsible for all actions from your account.",
//               ),
//
//               _divider(),
//
//               _section(
//                 icon: LucideIcons.wallet,
//                 title: "Payments & Transactions",
//                 text:
//                 "All payments must be authentic and authorized. Suspicious transactions may be put on hold or rejected by the verification team.",
//               ),
//
//               _divider(),
//
//               _section(
//                 icon: LucideIcons.server,
//                 title: "Service Availability",
//                 text:
//                 "We strive to offer seamless service, but system maintenance or technical issues may cause delays or temporary unavailability.",
//               ),
//
//               _divider(),
//
//               _section(
//                 icon: LucideIcons.shieldAlert,
//                 title: "Limitation of Liability",
//                 text:
//                 "We are not liable for losses caused by misuse, unauthorized access, or technical errors beyond our control.",
//               ),
//
//               _divider(),
//
//               _section(
//                 icon: LucideIcons.refreshCcw,
//                 title: "Updates to Terms",
//                 text:
//                 "These terms may change. You will be notified of major updates. Continued use after updates means acceptance.",
//               ),
//
//               const SizedBox(height: 28),
//
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       backgroundColor: primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 3,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text(
//                       "I Agree & Understand",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _section({required IconData icon, required String title, required String text}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 20, color: Colors.deepPurple),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 13.5,
//             height: 1.45,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _divider() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Divider(
//         thickness: 0.4,
//         color: Colors.grey.shade300,
//       ),
//     );
//   }
// }
