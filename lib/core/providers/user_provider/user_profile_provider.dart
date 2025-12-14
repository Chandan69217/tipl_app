import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/profile_api_service.dart';
import 'package:tipl_app/core/models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier{
  UserProfile data = UserProfile.fromJson({});
  final BuildContext? context;
  UserProfileProvider({this.context});
  bool _isLoading = false;

  void initialized()async{
    if(_isLoading) return;
    _isLoading = true;
    try{
      final value = await ProfileAPIService(context: context).getUserProfileUpdate();
      data = UserProfile.fromJson(value??{});
    }catch(e,t){
      debugPrint("User Profile Provider Exception: $e");
      debugPrintStack(stackTrace: t);
    }finally{
      _isLoading = false;
      notifyListeners();
    }


  }

  Future<UserProfile> updateProfile(UserProfile details)async{
    final value = await ProfileAPIService(context: context).getUserProfileUpdate(details: details);
    data = UserProfile.fromJson(value??{});
    notifyListeners();
    return data;
  }

  void clear()async{
    data = UserProfile.fromJson({});
  }

}