import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/genealogy_provider/genealogy_provider.dart';
import 'package:tipl_app/core/providers/income_provider/income_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/providers/wallet_provider/Wallet_Provider.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/preference.dart';

class RecallProvider{
  final BuildContext context;
  RecallProvider({required this.context}){
    UserRole.user == UserType.role ? _recallUserProviders() : _recallAdminProviders();
  }

  void _recallUserProviders()async{
    Provider.of<UserProfileProvider>(context, listen: false).initialized();
    Provider.of<GenealogyProvider>(context, listen: false).initialized();
    Provider.of<WalletProvider>(context, listen: false).initialized();
    Provider.of<IncomeProvider>(context, listen: false).initialized();
  }

  void _recallAdminProviders()async{
    Provider.of<AllUserDetailsProvider>(context,listen: false).initialized();
    Provider.of<UserProfileProvider>(context, listen: false).initialized();
    Provider.of<GenealogyProvider>(context, listen: false).initialized();
  }

}




