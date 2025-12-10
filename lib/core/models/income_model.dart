import 'package:intl/intl.dart';

class IncomeModel {
  final int id;
  final String memberId;
  final String incomeType;
  final double amount;
  final String sourceMemberId;
  final String? reference;

  /// Raw timestamp as DateTime
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Formatted date strings (dd-MM-yyyy)
  String get formattedCreatedDate => DateFormat('dd-MM-yyyy').format(createdAt);
  String get formattedUpdatedDate => DateFormat('dd-MM-yyyy').format(updatedAt);

  /// Formatted time (hh:mm a)
  String get formattedCreatedTime => DateFormat('hh:mm a').format(createdAt);
  String get formattedUpdatedTime => DateFormat('hh:mm a').format(updatedAt);

  IncomeModel({
    required this.id,
    required this.memberId,
    required this.incomeType,
    required this.amount,
    required this.sourceMemberId,
    this.reference,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      memberId: json['member_id'],
      incomeType: json['income_type'],
      amount: (json['amount'] as num).toDouble(),
      sourceMemberId: json['source_member_id'],
      reference: json['reference'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "member_id": memberId,
      "income_type": incomeType,
      "amount": amount,
      "source_member_id": sourceMemberId,
      "reference": reference,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
