import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';


class ChangePasswordAPIService{
  final BuildContext context;
  ChangePasswordAPIService({required this.context});

  Future<bool> changeTransactionPass({required String newPassword})async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
      final url = Uri.https(Urls.baseUrl,Urls.changeUserTransPassword,{
        'member_id' : member_id
      });

      final response = await put(url,body: json.encode({
        'transaction_password':newPassword
      }),headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'Application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final staus = body['isSuccess']??false;
        if(staus){
         return true;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return false;
  }


  Future<bool> changeWalletTransactionPass({required String oldPassword,required String newPassword})async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
      final url = Uri.https(Urls.baseUrl,Urls.updateWalletTransactionPassword,);

      final response = await put(url,body: json.encode({
        "member_id": member_id,
        "old_password": oldPassword,
        "new_password": newPassword
      }),headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'Application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final staus = body['isSuccess']??false;
        if(staus){
          return true;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return false;
  }
}