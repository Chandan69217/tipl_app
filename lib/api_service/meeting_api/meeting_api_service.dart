import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';

class MeetingApiService{
  final BuildContext context;
  MeetingApiService({required this.context});

  Future<List<dynamic>> getAllMeetings()async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.getMeeting);
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          final data = body['data'] as List<dynamic>;
          return data;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: $exception, Trace: $trace");
    }
    return [];
  }

  Future<List<dynamic>> getAllMeetingsByFilter({String? status,DateTime? startData,DateTime? endData})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final formatData = DateFormat('yyyy-MM-dd');
    String? formattedStartData;
    String? formattedEndData;
    try{
      if(startData != null)
        formattedStartData = formatData.format(startData);
      if(endData != null)
        formattedEndData = formatData.format(endData);
    }catch(exception,trace){
      print('Exception: $exception, Trace: $trace');
    }
    try{
      final url = Uri.https(Urls.baseUrl,Urls.getMeetingByFilter,{
        'status' : status,
        'start_date' : formattedStartData,
        'end_date' : formattedEndData
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
          final data = body['data'] as List<dynamic>;
          return data;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: $exception, Trace: $trace");
    }
    return [];
  }

  Future<bool> addNewMeeting({required String title,String? description,required String meeting_date,required String meeting_link})async{
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.addNewMeeting);
      final response = await post(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      },body: json.encode({
        'member_id' : member_id,
        "title": title,
        "description": description,
        "meeting_date":meeting_date,
        "meeting_link": meeting_link
      }));
      printAPIResponse(response);
      if(response.statusCode == 200 || response.statusCode == 201){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final status = body['isSuccess']??false;
        if(status){
          CustomMessageDialog.show(context, title: 'Meeting Scheduled', message: 'Your meeting has been successfully scheduled!');
          return true;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: $exception, Trace: $trace");
    }
    return false;
  }

}