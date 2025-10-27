import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tipl_app/core/providers/admin_provider/all_user_provider.dart';
import 'package:tipl_app/core/providers/user_provider/user_profile_provider.dart';
import 'package:tipl_app/core/utilities/preference.dart';

class RecallProvider{
  final BuildContext context;
  RecallProvider({required this.context}){
    Pref.instance.getString(PrefConst.SPONSOR_ID) != null ? _recallUserProviders() : _recallAdminProviders();
  }

  void _recallUserProviders()async{
    Provider.of<UserProfileProvider>(context, listen: false).initialized();
  }

  void _recallAdminProviders()async{
    Provider.of<AllUserDetailsProvider>(context,listen: false).initialized();
    Provider.of<UserProfileProvider>(context, listen: false).initialized();
  }

}