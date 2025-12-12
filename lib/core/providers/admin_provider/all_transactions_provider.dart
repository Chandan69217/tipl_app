import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';

class AllTransactionsProvider extends ChangeNotifier{
  List<WalletTransaction> allTransactions = [];


  Future<void> initialized() async {
    try {

      // ------- RUN ALL CALLS IN PARALLEL -------
      final results = await Future.wait([
        WalletApiService().getWalletAllHistory(),
      ]);


      allTransactions = results[0];

    } catch (e, t) {
      print("Wallet Load Error: $e");
      print(t);
    }
    notifyListeners();
  }
}