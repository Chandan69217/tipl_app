import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/wallets_api/wallet_api_service.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';


class WalletProvider extends ChangeNotifier {

  var balance;
  DateFormat _dateFormat  = DateFormat('dd-MMM-yyyy H:m a');
  String createdAt = 'N/A';
  String updatedAt = 'N/A';
  List<WalletTransaction> transaction = [];
  List<dynamic> memberships = [];

  void initialized()async{
    final value = await WalletApiService().getWallet();
    transaction = await WalletApiService().getWalletHistory();
    memberships = await WalletApiService().getMembershipDetails();
    balance = value?['balance']??0.0;
    createdAt = _dateFormat.format(DateTime.parse(value?['createdAt'] ?? ''));
    updatedAt = _dateFormat.format(DateTime.parse(value?['updatedAt'] ?? ''));
    notifyListeners();
  }



}



