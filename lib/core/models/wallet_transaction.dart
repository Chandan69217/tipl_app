import 'package:intl/intl.dart';

class WalletTransaction {
  final int id;
  final String memberId;
  final double amount;
  final String txnType;
  final String source;
  final String? upi;              // nullable
  final String? utr;              // nullable
  final String confirmation;
  final String? reference;        // nullable
  final String? transactionPassword;
  final DateTime createdAt;
  final DateTime updatedAt;

  late final String formattedDate;

  WalletTransaction({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.txnType,
    required this.source,
    this.upi,
    this.utr,
    required this.confirmation,
    this.reference,
    this.transactionPassword,
    required this.createdAt,
    required this.updatedAt,
  }) {
    formattedDate = DateFormat("dd MMM, hh:mm a").format(createdAt);
  }

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    // safely parse dates
    DateTime parseDate(String? date) {
      if (date == null || date.isEmpty) return DateTime.now();
      return DateTime.tryParse(date) ?? DateTime.now();
    }

    return WalletTransaction(
      id: json["id"] ?? 0,
      memberId: json["member_id"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      txnType: json["txn_type"] ?? "unknown",
      source: json["source"] ?? "",
      upi: json["upi"],                    // optional
      utr: json["utr"],                    // optional
      confirmation: json["confirmation"] ?? "pending",
      reference: json["reference"],        // optional
      transactionPassword: json["transaction_password"],
      createdAt: parseDate(json["createdAt"]),
      updatedAt: parseDate(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "member_id": memberId,
    "amount": amount,
    "txn_type": txnType,
    "source": source,
    "upi": upi,
    "utr": utr,
    "reference": reference,
    "confirmation": confirmation,
    "transaction_password": transactionPassword,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
