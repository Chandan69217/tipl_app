import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';

class ProfileAPIService{
  BuildContext context;
  ProfileAPIService({required this.context});

  Future<Map<String,dynamic>?> getProfileDetailsByMemberId()async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      final url = Uri.https(Urls.baseUrl,Urls.getProfile,{
        'member_id' : memberId
      });

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'Application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          final data = body['data'] as Map<String,dynamic>;
          return data;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<bool> isProfileCompleted()async{
    try{
      final data = await getProfileDetailsByMemberId();
      if(data == null) return false;
      for (var entry in data.entries) {
        if (entry.value == null) {
          return false;
        }
      }
    }catch(exception,trace){
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return true;
  }

}