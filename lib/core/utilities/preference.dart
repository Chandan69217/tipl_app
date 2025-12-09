import 'package:shared_preferences/shared_preferences.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';

class Pref{
  Pref._();
  static late SharedPreferences instance;

  static Future<void> initialized()async{
    instance = await SharedPreferences.getInstance();
  }

  static void Logout(){
    instance.remove(PrefConst.IS_LOGIN);
    instance.remove(PrefConst.LOGIN_TYPE);
    instance.remove(PrefConst.TOKEN);
    instance.remove(PrefConst.MEMBER_ID);
    instance.remove(PrefConst.SPONSOR_ID);
    UserType.role = null;
  }


}

class PrefConst{
  PrefConst._();
  static final String SAVED_EMAIL = 'saved_email';
  static final String SAVED_PASSWORD = 'saved_password';
  static final String IS_LOGIN = 'is_login';
  static final String LOGIN_TYPE = 'Login_Type';
  static final String TOKEN = 'token';
  static final String MEMBER_ID = 'member_id';
  static final String SPONSOR_ID = 'sponsor_id';
  static final String ROLE = 'role';
}