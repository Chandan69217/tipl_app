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
  double balance = 0.0;
  DateFormat _dateFormat = DateFormat('dd-MMM-yyyy H:m a');
  String createdAt = 'N/A';
  String updatedAt = 'N/A';
  List<WalletTransaction> transaction = [];
  List<dynamic> memberships = [];


  Future<void> initialized() async {
    try {

      // ------- RUN ALL CALLS IN PARALLEL -------
      final results = await Future.wait([
        WalletApiService().getWallet(),
        WalletApiService().getWalletHistory(),
        WalletApiService().getMembershipDetails(),
      ]);

      final wallet = (results[0]??{}) as Map<String,dynamic>;
      final walletHistory = results[1];
      final membershipDetails = results[2];

      transaction = walletHistory as List<WalletTransaction> ;
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
    }
    notifyListeners();
  }

}



