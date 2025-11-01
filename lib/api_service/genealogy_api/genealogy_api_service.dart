import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';


class GenealogyAPIService{

  final BuildContext? context;
  GenealogyAPIService({this.context});

  Future<Map<String,dynamic>?> getGenealogyTree()async{
    final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.genealogyTree,{
        'associate_id' : member_id
      });
      
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          return body['data'] as Map<String,dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return null;
  }

  Future<List<dynamic>> getGenealogyInactiveTeam({DateTime? from_date,DateTime? to_date})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final date_format = DateFormat('yyyy-MMM-dd');
    try{
      final url = Uri.https(Urls.baseUrl,Urls.genealogyInactiveTeam,{
        'from_date' : from_date != null ? date_format.format(from_date):null,
        'to_date' : to_date != null ? date_format.format(to_date):null,
      });

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          return body['data'] as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return [];
  }

  Future<List<dynamic>> getGenealogyActiveTeam({DateTime? from_date,DateTime? to_date})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final date_format = DateFormat('yyyy-MMM-dd');
    try{
      final url = Uri.https(Urls.baseUrl,Urls.genealogyActiveTeam,{
        'from_date' : from_date != null ? date_format.format(from_date):null,
        'to_date' : to_date != null ? date_format.format(to_date):null,
      });

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          return body['data'] as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return [];
  }

  Future<List<dynamic>> getGenealogyAllTeam({DateTime? from_date,DateTime? to_date})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final date_format = DateFormat('yyyy-MMM-dd');
    try{
      final url = Uri.https(Urls.baseUrl,Urls.genealogyAllTeam,{
        'from_date' : from_date != null ? date_format.format(from_date):null,
        'to_date' : to_date != null ? date_format.format(to_date):null,
      });

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          return body['data'] as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return [];
  }

  Future<List<dynamic>> getGenealogyDirectMember()async{
    final token = Pref.instance.getString(PrefConst.TOKEN);

    try{
      final url = Uri.https(Urls.baseUrl,Urls.genealogyDirectMembers,);

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          return body['data'] as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return [];
  }

  Future<bool> createGenealogy({required String member_id,required String sponsor_id,required String position})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try{
      final url  = Uri.https(Urls.baseUrl,Urls.createGenealogy);
      final body = {
        "member_id": member_id.toUpperCase(),
        "sponsor_id": sponsor_id.toUpperCase(),
        "position": position
      };
      final response = await post(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      },
      body: json.encode(body)
      );
      printAPIResponse(response);
      if(response.statusCode == 200){
        final value = json.decode(response.body) as Map<String,dynamic>;
        final status = value['isSuccess']??false;
        if(status){
          return true;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return false;
  }

  Future<bool> updateGenealogy({required String member_id,required String sponsor_id,required String position})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try{
      final url  = Uri.https(Urls.baseUrl,Urls.genealogyUpdate);
      final body = {
        "member_id": member_id.toUpperCase(),
        "position": position,
        'sponsor_id' : sponsor_id,
      };
      final response = await put(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      },
          body: json.encode(body)
      );
      printAPIResponse(response);
      if(response.statusCode == 200){
        final value = json.decode(response.body) as Map<String,dynamic>;
        final status = value['isSuccess']??false;
        final message = value['message'];
        if(context != null && !status){
          CustomMessageDialog.show(context!, title: 'Genealogy', message: message);
        }
        if(status){
          return true;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: $exception,Trace: $trace');
    }
    return false;
  }

}