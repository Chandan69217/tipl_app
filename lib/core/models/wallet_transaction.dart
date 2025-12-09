import 'package:intl/intl.dart';

class WalletTransaction {
  final int id;
  final String memberId;
  final double amount;
  final String txnType;
  final String source;
  final String? reference;
  final String transactionPassword;
  final DateTime createdAt;
  final DateTime updatedAt;

  late final String formattedDate;

  WalletTransaction({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.txnType,
    required this.source,
    required this.reference,
    required this.transactionPassword,
    required this.createdAt,
    required this.updatedAt,
  }) {
    formattedDate = DateFormat("dd MMM, hh:mm a").format(createdAt);
  }

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    DateTime created = DateTime.parse(json["createdAt"]);
    DateTime updated = DateTime.parse(json["updatedAt"]);

    return WalletTransaction(
      id: json["id"],
      memberId: json["member_id"],
      amount: (json["amount"] as num).toDouble(),
      txnType: json["txn_type"],
      source: json["source"],
      reference: json["reference"],
      transactionPassword: json["transaction_password"],
      createdAt: created,
      updatedAt: updated,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_id": memberId,
    "amount": amount,
    "txn_type": txnType,
    "source": source,
    "reference": reference,
    "transaction_password": transactionPassword,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
