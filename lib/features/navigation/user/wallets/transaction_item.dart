import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/navigate_with_animation.dart';
import 'package:tipl_app/features/navigation/user/wallets/transaction_details_screen.dart';

import 'transaction_confirmation.dart';
//
// class TransactionItem extends StatelessWidget {
//   final WalletTransaction data;
//
//   const TransactionItem({super.key, required this.data});
//
//   bool get isCredit => data.txnType.toLowerCase() == 'credit';
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor:
//         isCredit ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
//         child: Icon(
//           isCredit ? Iconsax.received : Iconsax.send,
//           color: isCredit ? Colors.green : Colors.red,
//         ),
//       ),
//       title: Row(
//         children: [
//           Flexible(
//             child: Text(
//               data.source,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//
//           const SizedBox(width: 6),
//
//           _buildStatusTag(parseStatus(data.confirmation)),
//         ],
//       ),
//       subtitle: Text(
//         data.formattedDate,
//         style: const TextStyle(fontSize: 12),
//       ),
//       trailing: Text(
//         '${isCredit ? '+' : '-'}${data.amount}',
//         style: TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//           color: isCredit ? Colors.green : Colors.red,
//         ),
//       ),
//     );
//   }
//
//   // 🔥 STATUS TAG BUILDER
//   Widget _buildStatusTag(TransactionStatus status) {
//     switch (status) {
//       case TransactionStatus.pending:
//         return Text(
//           "Pending",
//           style: TextStyle(
//             color: Colors.orange.shade700,
//             fontSize: 13,
//             fontWeight: FontWeight.w600,
//           ),
//         );
//
//       case TransactionStatus.failed:
//         return Row(
//           children: [
//             const Icon(Icons.close_rounded, color: Colors.red, size: 16),
//             const SizedBox(width: 3),
//             Text(
//               "Failed",
//               style: TextStyle(
//                 color: Colors.red.shade700,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         );
//
//       case TransactionStatus.success:
//         return const SizedBox(); // show nothing
//     }
//   }
// }




class TransactionItem extends StatelessWidget {
  final WalletTransaction data;
  final UserRole userType;

  const TransactionItem({
    super.key,
    required this.data,
    this.userType = UserRole.user,
  });

  bool get isCredit => data.txnType.toLowerCase() == 'credit';

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        _viewDetails(context);
      },
      leading: CircleAvatar(
        backgroundColor: isCredit
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        child: Icon(
          isCredit ? Iconsax.received : Iconsax.send,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),

      // ---------------- TITLE ----------------
      title: Row(
        children: [
          Flexible(
            child: Text(
              data.source,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 6),
          _buildStatusTag(parseStatus(data.confirmation)),
        ],
      ),

      subtitle: Text(data.formattedDate),

      trailing:   Text(
        '${isCredit ? '+' : '-'}${data.amount}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isCredit ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // 🔥 STATUS TAG BUILDER
  // -------------------------------------------------------
  Widget _buildStatusTag(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return Text(
          "Pending",
          style: TextStyle(
            color: Colors.orange.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        );

      case TransactionStatus.failed:
        return Row(
          children: [
            const Icon(Icons.close_rounded, color: Colors.red, size: 16),
            const SizedBox(width: 3),
            Text(
              "Failed",
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );

      case TransactionStatus.success:
        return const SizedBox();
    }
  }

  _viewDetails(BuildContext context){
    navigateWithAnimation(context, TransactionDetailsScreen(data: data, userType: UserType.role,));
  }
}
