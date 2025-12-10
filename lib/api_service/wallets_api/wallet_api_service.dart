import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/models/wallet_transaction.dart';
import 'package:tipl_app/core/providers/recall_provider.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';

class WalletApiService {
  final BuildContext? context;
  WalletApiService({this.context});

  Future<Map<String,dynamic>?> getWallet()async{
    try{
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl, '${Urls.walletDetails}${memberId}');
      final response  = await get(url,headers: {
        'Authorization' : 'Bearer ${token}',
        'Content-type' : 'application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          return body['wallet'] as Map<String,dynamic>;
        }else{
          print(body['message']??'');
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: ${exception} Trace: ${trace}");
    }
    
    return null;
  }

  // Future<Map<String,dynamic>?> addFund(){
  //
  // }

  Future<Map<String,dynamic>?> topUp({required double amount,required String password})async{

    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url  = Uri.https(Urls.baseUrl,Urls.walletTopUp);

      final body = {
        "member_id": memberId,
        "amount": amount,
        "transaction_password": password
      };

      final response = await post(url,body: json.encode(body),headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'Application/json'
      });

      printAPIResponse(response);

      if(response.statusCode == 200 || response.statusCode == 201){
        final values = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = values['isSuccess']??false;
        final message = values['message'];
        if(isSuccess){
          return values;
        }else{
          if(context != null){
            CustomMessageDialog.show(context!, title: 'Wallet', message: message);
          }
        }
      }else{
        handleApiResponse(context, response);
      }

    }catch(exception,trace){
      print("Excepiton: ${exception}, Trace: ${trace}");
    }
    return null;
  }


  Future<List<WalletTransaction>> getWalletHistory() async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      final url = Uri.https(Urls.baseUrl,'${Urls.walletHistory}${memberId}');

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });

      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          final transaction = (body['transactions']??[])as List<dynamic>;
          return transaction.map((e)=>WalletTransaction.fromJson(e) ).toList();
        }
      }else{
        handleApiResponse(context, response);
      }

    }catch(exception,trace){
      print(("Exception: ${exception} Trace: ${trace}"));
    }
    return [];
  }
  
  Future<Map<String,dynamic>?> purchaseMembership(
      {required String packageType, required String amount,required String password})async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      
      final url = Uri.https(Urls.baseUrl,Urls.purchaseMembership);

      final body = {
        "member_id": memberId,
        "package_type": packageType,
        "amount": amount,
        "transaction_password": password
      };

      final response = await post(url,body: json.encode(body),
        headers: {
        'Authorization' : 'Bearer $token',
          'Content-type' : 'application/json'
        }
      );
      printAPIResponse(response);
      if(response.statusCode == 200 || response.statusCode == 201){
        final value = json.decode(response.body);
        final isSuccess = value['isSuccess']??false;
        return value;
        // if(isSuccess){
        //   return value;
        // }else{
        //   final message = value['message'];
        //   if(context != null){
        //     CustomMessageDialog.show(context!, title: 'Transaction Failed', message: message);
        //   }
        // }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: ${exception} Trace: ${trace}");
    }
    return null;
  }


  Future<List<dynamic>> getMembershipDetails()async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(Urls.baseUrl, '${Urls.getMembershipDetails}${memberId}');

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });

      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          return (body['memberships']??[]) as List<dynamic>;
        }
      }

    }catch(exception,trace){
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }




}