import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';


// class WalletProvider extends ChangeNotifier {
//
//   var balance;
//   DateFormat _dateFormat  = DateFormat('dd-MMM-yyyy H:m a');
//   String createdAt = 'N/A';
//   String updatedAt = 'N/A';
//   List<WalletTransaction> transaction = [];
//   List<dynamic> memberships = [];
//
//   void initialized()async{
//
//     final value = await WalletApiService().getWallet();
//     transaction = await WalletApiService().getWalletHistory();
//     memberships = await WalletApiService().getMembershipDetails();
//     balance = value?['balance']??0.0;
//     createdAt = _dateFormat.format(DateTime.parse(value?['createdAt'] ?? ''));
//     updatedAt = _dateFormat.format(DateTime.parse(value?['updatedAt'] ?? ''));
//     notifyListeners();
//
//   }
//
//
//
// }


class WalletProvider extends ChangeNotifier {
  var balance;
  DateFormat _dateFormat = DateFormat('dd-MMM-yyyy H:m a');
  String createdAt = 'N/A';
  String updatedAt = 'N/A';
  List<WalletTransaction> transaction = [];
  var totalWithdrawal = 0.0;
  List<dynamic> memberships = [];

  bool _isLoading = false;


  Future<void> initialized() async {
    if(_isLoading) return;
    _isLoading = true;

    try {

      // ------- RUN ALL CALLS IN PARALLEL -------
      final results = await Future.wait([
        WalletApiService().getWallet(),
        WalletApiService().getWalletHistory(),
        WalletApiService().getMembershipDetails(),
        WalletApiService().getWalletAllHistory(),
      ]);

      final wallet = (results[0]??{}) as Map<String,dynamic>;
      final walletHistory = results[1];
      final membershipDetails = results[2];
      final allWalletHistory = results[3];

      transaction = walletHistory as List<WalletTransaction> ;
      totalWithdrawal = transaction.where((t)=> t.txnType.toLowerCase() == 'withdrawal' || t.txnType.toLowerCase() == 'debit').fold(0.0, (sum, t) => sum + t.amount);
      memberships = membershipDetails as List<dynamic>;
      balance = wallet['balance'] ?? 0.0;

      final createdAtStr = wallet['createdAt'] ?? '';
      final updatedAtStr = wallet['updatedAt'] ?? '';

      if (createdAtStr.isNotEmpty) {
        createdAt = _dateFormat.format(DateTime.parse(createdAtStr));
      }

      if (updatedAtStr.isNotEmpty) {
        updatedAt = _dateFormat.format(DateTime.parse(updatedAtStr));
      }

    } catch (e, t) {
      print("Wallet Load Error: $e");
      print(t);
    }finally{
      _isLoading = false;
      notifyListeners();
    }

  }


  Map<int, double> get yearlyWithdrawals {
    Map<int, double> result = {};

    for (var t in transaction) {
      if (t.txnType.toLowerCase() == "withdrawal" ||
          t.txnType.toLowerCase() == "debit")
      {
        int year = t.createdAt.year;
        result[year] = (result[year] ?? 0) + t.amount;
      }
    }
    return result;
  }


}




