import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier{
  UserProfile data = UserProfile.fromJson({});
  final BuildContext? context;
  UserProfileProvider({this.context});

  void initialized()async{
    final value = await ProfileAPIService(context: context).getUserProfileUpdate();
    data = UserProfile.fromJson(value??{});
    notifyListeners();
  }

  Future<UserProfile> updateProfile(UserProfile details)async{
    final value = await ProfileAPIService(context: context).getUserProfileUpdate(details: details);
    data = UserProfile.fromJson(value??{});
    notifyListeners();
    return data;
  }

}