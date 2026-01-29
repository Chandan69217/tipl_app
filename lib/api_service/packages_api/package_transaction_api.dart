import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/compress_image.dart';
import 'package:tipl_app/core/utilities/dashboard_type/dashboard_type.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';


class PackageTransactionApiService {
  final BuildContext? context;

  PackageTransactionApiService({this.context});

  Future<List<dynamic>> getPackagesTransactionList()async{

    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = UserRole.admin == UserType.role ? Uri.https(Urls.baseUrl,'/api/payouts/admin'):Uri.https(Urls.baseUrl,'/api/payouts/user');
      final response = await get(url,headers: {
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $token'
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

  Future<Map<String,dynamic>?> getPackagesTransactionByID(String id)async{

    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl,'/api/payouts/admin/${id}');
      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
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

  Future<List<dynamic>> getPackagesTransactionMemberID(String member_id ,String id)async{

    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl,'/api/payouts/user/payout',{
        'member_id' : member_id,
        'transaction_id' : id
      });

      final response = await get(url,headers: {
        'Authorization' : 'Bearer $token',
        'Content-type' : 'application/json'
      });

      printAPIResponse(response);
      if(response.statusCode == 200){
        final body = json.decode(response.body) as Map<String,dynamic>;
        final isSuccess = body['isSuccess']??false;
        if(isSuccess){
          return (body['data']??{}) as List<dynamic>;
        }
      }else{
        handleApiResponse(context, response);
      }
    }catch(exception,trace){
      print("Exception: ${exception},Trace: ${trace}");
    }
    return [];
  }


  Future<bool> deletePackageTransaction(String id)async{
    try{
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl,'/api/payouts/admin/${id}');
      final response = await delete(url,headers: {
        'Authorization' : 'Bearer $token',
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



  Future<bool> createPackageTransaction({
    required String memberId,
    required String payoutDate,
    required double amount,
    required String upiId,
    required String transactionId,
    required String paymentTransactionId,
    required String remarks
  }) async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl, '/api/payouts/admin');

      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'member_id': memberId,
          'payout_date': payoutDate,
          'amount': amount,
          'transaction_id': transactionId,
          'upi_id': upiId,
          'upi_transaction_id' : paymentTransactionId,
          'remarks': remarks,
        }),
      );

      printAPIResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        return body['isSuccess'] == true;
      } else {
        handleApiResponse(context, response);
      }
    } catch (e, stack) {
      debugPrint('Exception: $e');
      debugPrint('Stack: $stack');
    }

    return false;
  }


  Future<bool> updatePackageTransactionId({
    required String transactionId,
    String? status,
    String? remarks,
    double? amount,
  }) async {

    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl, '/api/payouts/admin/$transactionId');

      var request = http.MultipartRequest('PUT', url);


      // ----------- ADD ONLY NON-NULL FIELDS ------------
      if (amount != null) request.fields['amount'] = amount.toString();
      if (status != null) request.fields['status'] = status;
      if (remarks != null) {
        request.fields['remarks'] = remarks;
      }


      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

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