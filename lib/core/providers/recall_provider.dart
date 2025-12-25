import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_transactions_provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/genealogy_provider/genealogy_provider.dart';
import 'package:tipl_app/core/providers/income_provider/income_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';


//
// class RecallProvider{
//   final BuildContext context;
//   RecallProvider({required this.context}){
//     UserRole.user == UserType.role ? _recallUserProviders() : _recallAdminProviders();
//   }
//
//   void _recallUserProviders()async{
//     Provider.of<UserProfileProvider>(context, listen: false).initialized();
//     Provider.of<GenealogyProvider>(context, listen: false).initialized();
//     Provider.of<WalletProvider>(context, listen: false).initialized();
//     Provider.of<IncomeProvider>(context, listen: false).initialized();
//   }
//
//   void _recallAdminProviders()async{
//     Provider.of<AllUserDetailsProvider>(context,listen: false).initialized();
//     Provider.of<UserProfileProvider>(context, listen: false).initialized();
//     Provider.of<GenealogyProvider>(context, listen: false).initialized();
//     Provider.of<AllTransactionsProvider>(context,listen: false).initialized();
//     Provider.of<WalletProvider>(context, listen: false).initialized();
//     Provider.of<IncomeProvider>(context, listen: false).initialized();
//   }
//
// }
//





class RecallProvider {
  final BuildContext context;

  RecallProvider({required this.context});


  Future<void> recallAll() async {
    if (UserRole.user == UserType.role) {
      await _recallUserProviders();
    } else {
      await _recallAdminProviders();
    }
  }


  Future<void> _recallUserProviders() async {

    await Future.wait([
      Provider.of<UserProfileProvider>(context, listen: false).initialized(),
      Provider.of<GenealogyProvider>(context, listen: false).initialized(),
      Provider.of<WalletProvider>(context, listen: false).initialized(),
      Provider.of<IncomeProvider>(context, listen: false).initialized(),
    ]);


  }

  Future<void> _recallAdminProviders() async {

    await Future.wait([
      Provider.of<AllUserDetailsProvider>(context, listen: false).initialized(),
      Provider.of<UserProfileProvider>(context, listen: false).initialized(),
      Provider.of<GenealogyProvider>(context, listen: false).initialized(),
      Provider.of<AllTransactionsProvider>(context, listen: false).initialized(),
      Provider.of<WalletProvider>(context, listen: false).initialized(),
      Provider.of<IncomeProvider>(context, listen: false).initialized(),
    ]);


  }


}
