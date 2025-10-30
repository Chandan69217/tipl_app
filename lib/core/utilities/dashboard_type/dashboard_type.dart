import 'package:tipl_app/core/utilities/preference.dart';


enum UserRole {
  admin,
  user,
  none,
}

class UserType {
  UserType._();

  static UserRole? _role;

  static UserRole get role {
    if (_role == null) {
      return UserRole.none;
    }
    return _role!;
  }

  static void initialize() {
    if(_role != null){
      return;
    }
    final isLogin = Pref.instance.getBool(PrefConst.IS_LOGIN)??false;
    if(!isLogin){
      return;
    }
    final sponsorId = Pref.instance.getString(PrefConst.SPONSOR_ID);
    if (sponsorId == null || sponsorId.isEmpty) {
      _role = UserRole.admin;
    } else {
      _role = UserRole.user;
    }
  }

}

