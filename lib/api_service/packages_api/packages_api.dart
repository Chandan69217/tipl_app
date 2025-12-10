

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/compress_image.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';

class PackagesApiService {
  final BuildContext? context;

  PackagesApiService({this.context});

  Future<List<dynamic>> getPackagesType()async{

    try{
      final url = Uri.https(Urls.baseUrl,'/api/packages');
      final response = await get(url,headers: {
        'Content-type' : 'application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          return (body['data']??[]) as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: ${exception},Trace: ${trace}");
    }
    return [];
  }

  Future<Map<String,dynamic>?> getPackagesTypeByID(String id)async{

    try{
      final url = Uri.https(Urls.baseUrl,'/api/packages/${id}');
      final response = await get(url,headers: {
        'Content-type' : 'application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          return (body['data']??{}) as Map<String,dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: ${exception},Trace: ${trace}");
    }
    return null;
  }

  Future<bool> deletePackage(String id)async{
    try{
      final url = Uri.https(Urls.baseUrl,'/api/packages/${id}');
      final response = await delete(url,headers: {
        'Content-type' : 'application/json'
      });
      printAPIResponse(response);
      if(response.statusCode == 200 ){
        final body = json.decode(response.body);
        final isSuccess = body['isSuccess']??false;
        final message = body['message']??'';
        if(context != null){
          CustomMessageDialog.show(context!, title: 'Delete', message: message);
        }
        if(isSuccess){
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

//   Future<bool> getCreatePackage({
//     required String packageName,
//     required String desc,
//     required double amount,
//     required int duration,
// })async{
//
//     try{
//       final url = Uri.https(Urls.baseUrl,'/api/packages');
//       final body = {
//         "package_name": packageName,
//         "description": desc,
//         "amount": amount,
//         "duration_in_days": duration
//       };
//       final response = await post(url,
//           body: json.encode(body),
//           headers: {
//         'Content-type' : 'application/json'
//       });
//
//       printAPIResponse(response);
//       if(response.statusCode == 200){
//         final body = json.decode(response.body) as Map<String,dynamic>;
//         final isSuccess = body['isSuccess']??false;
//         if(isSuccess){
//           return true;
//         }
//       }else{
//         handleApiResponse(context, response);
//       }
//     }catch(exception,trace){
//       print("Exception: ${exception},Trace: ${trace}");
//     }
//     return false;
//   }



  Future<bool> createPackage({
    required String packageName,
    required String desc,
    required double amount,
    required int duration,
    required int monthly_roi_percent,
    required int halfyearly_roi_percent,
    required int yearly_roi_percent,
    required File imageFile,
  }) async {
    try {
      final url = Uri.https(Urls.baseUrl, '/api/packages');

      // ---------- COMPRESS IMAGE ----------
      File compressedFile = await compressImage(imageFile);

      var request = http.MultipartRequest('POST', url);

      request.fields['package_name'] = packageName;
      request.fields['description'] = desc;
      request.fields['amount'] = amount.toString();
      request.fields['duration_in_days'] = duration.toString();
      request.fields['monthly_roi_percent'] = monthly_roi_percent.toString();
      request.fields['halfyearly_roi_percent'] = halfyearly_roi_percent.toString();
      request.fields['yearly_roi_percent'] = yearly_roi_percent.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          'qr_image',
          compressedFile.path,
        ),
      );

      request.headers['Content-Type'] = 'multipart/form-data';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      printAPIResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) return true;
      } else {
        handleApiResponse(context, response);
      }

    } catch (exception, trace) {
      print("Exception: $exception, Trace: $trace");
    }

    return false;
  }

  Future<bool> updatePackage({
    required String packageId,
    String? packageName,
    String? desc,
    double? amount,
    int? duration,
    int? monthly_roi_percent,
    int? halfyearly_roi_percent,
    int? yearly_roi_percent,
    File? imageFile,
  }) async {

    try {
      final url = Uri.https(Urls.baseUrl, '/api/packages/$packageId');

      var request = http.MultipartRequest('PUT', url);

      // ----------- ADD ONLY NON-NULL FIELDS ------------
      if (packageName != null) request.fields['package_name'] = packageName;
      if (desc != null) request.fields['description'] = desc;
      if (amount != null) request.fields['amount'] = amount.toString();
      if (duration != null) request.fields['duration_in_days'] = duration.toString();
      if (monthly_roi_percent != null) {
        request.fields['monthly_roi_percent'] = monthly_roi_percent.toString();
      }
      if (halfyearly_roi_percent != null) {
        request.fields['halfyearly_roi_percent'] = halfyearly_roi_percent.toString();
      }
      if (yearly_roi_percent != null) {
        request.fields['yearly_roi_percent'] = yearly_roi_percent.toString();
      }


      if (imageFile != null) {
        File compressedFile = await compressImage(imageFile);

        request.files.add(
          await http.MultipartFile.fromPath(
            'qr_image',
            compressedFile.path,
          ),
        );
      }

      request.headers['Content-Type'] = 'multipart/form-data';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      printAPIResponse(response);

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;

        if (isSuccess) return true;
      } else {
        handleApiResponse(context, response);
      }

    } catch (exception, trace) {
      print("Exception: $exception, Trace: $trace");
    }

    return false;
  }



}