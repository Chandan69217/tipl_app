import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';

class UsersDetailsApi {
  final BuildContext? context;
  UsersDetailsApi({this.context});

  Future<List<dynamic>> getAllUsers() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl, Urls.getAllUsers);
      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'Application/json',
        },
      );
      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isSuccess'] ?? false;
        if (status) {
          final data = body['data'] as List<dynamic>;
          return data;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception},Trace: ${trace}");
    }
    return [];
  }

  Future<bool> updateUser({
    required String userMemberID,
    String? sponsor_id,
    String? package_type,
    String? full_name,
    String? marital_status,
    String? gender,
    String? dob,
    String? state,
    String? district,
    String? pincode,
    String? status,
    String? address,
    String? pan_number,
}) async {
    final token = Pref.instance.getString(PrefConst.TOKEN);
    try{
      final url = Uri.https(Urls.baseUrl,Urls.userUpdate,{
        'member_id' : userMemberID
      });

      final Map<String, dynamic> body = {};

      if (sponsor_id != null) body['sponsor_id'] = sponsor_id;
      if (package_type != null) body['package_type'] = package_type;
      if (full_name != null) body['full_name'] = full_name;
      if (marital_status != null) body['marital_status'] = marital_status;
      if (gender != null) body['gender'] = gender;
      if (dob != null) body['date_of_birth'] = dob;
      if (state != null) body['state'] = state;
      if (district != null) body['district'] = district;
      if (pincode != null) body['pin_code'] = pincode;
      if (address != null) body['address'] = address;
      if (status != null) body['status'] = status;
      if (pan_number != null) body['pan_number'] = pan_number;

      final response = await put(url,body: json.encode(body),headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'Application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200){
        final value = json.decode(response.body) as Map<String,dynamic>;
        final status = value['isSuccess']??false;
        return status;
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print('Exception: ${exception},Trace: ${trace}');
    }
    return false;
  }

}
