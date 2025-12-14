import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';


class AllTransactionsProvider extends ChangeNotifier{
  List<WalletTransaction> allTransactions = [];

  int totalPendingTransaction = 0;
  int totalSuccessTransaction = 0;
  int totalFailedTransaction = 0;

  bool _isLoading = false;

  Future<void> initialized() async {

    if (_isLoading) return;
    _isLoading = true;

    try {

      totalFailedTransaction = 0;
      totalPendingTransaction = 0;
      totalSuccessTransaction = 0;
      // ------- RUN ALL CALLS IN PARALLEL -------
      final results = await Future.wait([
        WalletApiService().getWalletAllHistory(),
      ]);

      allTransactions = results[0];

      for (final tx in allTransactions) {
        final status = tx.confirmation.toLowerCase();

        if (status == 'pending') {
          totalPendingTransaction++;
        } else if (status == 'failed') {
          totalFailedTransaction++;
        } else if (status == 'success') {
          totalSuccessTransaction++;
        }
      }

    } catch (e, t) {
      print("Wallet Load Error: $e");
      print(t);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}