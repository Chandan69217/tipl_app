import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/utilities/preference.dart';
import 'package:tipl_app/core/widgets/custom_message_dialog.dart';

class BankServiceAPI {
  final BuildContext context;
  BankServiceAPI({required this.context});
  //
  // Future<bool> addBankDetails({
  //   required String branch_name,
  //   required String ifsc_code,
  //   required String bank_name,
  //   required String accoune_type,
  //   required String account_name,
  //   required String account_no,
  //   required String pan_number,
  //   required File pan_img,
  //   required File bank_acc_img,
  // }) async {
  //   final token = Pref.instance.getString(PrefConst.TOKEN);
  //   final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
  //   try {
  //     final url = Uri.https(Urls.baseUrl, Urls.addBankDetails);
  //
  //     final request = http.MultipartRequest('post', url)
  //       ..headers['Authorization'] = 'Bearer $token'
  //       ..fields['branch_name'] = branch_name
  //       ..fields['account_type'] = accoune_type
  //       ..fields['account_no'] = account_no
  //       ..fields['pan_number'] = pan_number
  //       ..fields['bank_name'] = bank_name
  //       ..fields['account_name'] = account_name
  //       ..fields['member_id'] = member_id ?? ''
  //       ..fields['ifsc_code'] = ifsc_code
  //       ..fields['account_type'] = accoune_type;
  //
  //     final compress_pan = await compressImage(pan_img);
  //     var multipartFile = await http.MultipartFile.fromPath(
  //       'pan_card_photo',
  //       compress_pan.path,
  //     );
  //     request.files.add(multipartFile);
  //     final compress_acc = await compressImage(bank_acc_img);
  //     multipartFile = await http.MultipartFile.fromPath(
  //       'bank_account_photo',
  //       compress_acc.path,
  //     );
  //     request.files.add(multipartFile);
  //
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //     printAPIResponse(response);
  //     if (response.statusCode == 200) {
  //       final body = json.decode(response.body) as Map<String, dynamic>;
  //       final status = body['isSuccess'] ?? false;
  //       final message = body['message']??'';
  //       if (status) {
  //         CustomMessageDialog.show(
  //           context,
  //           title: 'Bank Details',
  //           message: 'Your bank details updated Successfully',
  //           onConfirm: (){
  //             Navigator.of(context).pop();
  //           }
  //         );
  //         return true;
  //       }
  //       CustomMessageDialog.show(
  //         context,
  //         title: 'Bank Details',
  //         message: message,
  //       );
  //     } else {
  //       handleApiResponse(context, response);
  //     }
  //   } catch (exception, trace) {
  //     print('Exception: ${exception},Trace: ${trace}');
  //   }
  //   return false;
  // }

  Future<bool> addBankDetails({
    required String branch_name,
    required String ifsc_code,
    required String bank_name,
    required String accoune_type,
    required String account_name,
    required String account_no,
    required String pan_number,
    required File pan_img,
    required File bank_acc_img,
  }) async {
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

    try {
      final url = Uri.https(Urls.baseUrl, Urls.addBankDetails);

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['branch_name'] = branch_name
        ..fields['ifsc_code'] = ifsc_code
        ..fields['bank_name'] = bank_name
        ..fields['account_type'] = accoune_type
        ..fields['account_name'] = account_name
        ..fields['account_no'] = account_no
        ..fields['pan_number'] = pan_number
        ..fields['member_id'] = member_id ?? '';


      final panBytes = await pan_img.readAsBytes();
      final accBytes = await bank_acc_img.readAsBytes();

      final panFile = http.MultipartFile.fromBytes(
        'pan_card_photo',
        panBytes,
        filename: pan_img.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      final bankFile = http.MultipartFile.fromBytes(
        'bank_account_photo',
        accBytes,
        filename: bank_acc_img.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(panFile);
      request.files.add(bankFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      printAPIResponse(response);

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isSuccess'] ?? false;
        final message = body['message'] ?? '';

        if (status) {
          CustomMessageDialog.show(
            context,
            title: 'Bank Details',
            message: 'Your bank details updated successfully',
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
          return true;
        } else {
          CustomMessageDialog.show(
            context,
            title: 'Bank Details',
            message: message,
          );
        }
      } else {
        handleApiResponse(context, response);
      }

    } catch (exception, trace) {
      print('Exception: $exception\nTrace: $trace');
    }

    return false;
  }

  Future<Map<String, dynamic>?> getBankDetails({
    String? branch_name,
    String? ifsc_code,
    String? bank_name,
    String? accoune_type,
    String? account_name,
    String? account_no,
    String? pan_number,
    File? pan_img,
    File? bank_acc_img,
  }) async {
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

    try {
      final url = Uri.https(Urls.baseUrl, Urls.updateBankDetails, {
        'member_id': member_id,
      });
      final request = http.MultipartRequest('put', url)
        ..headers['Authorization'] = 'Bearer $token';

      if (branch_name != null && branch_name.isNotEmpty) request.fields['branch_name'] = branch_name;

      if (ifsc_code != null && ifsc_code.isNotEmpty) request.fields['ifsc_code'] = ifsc_code;

      if (bank_name != null && bank_name.isNotEmpty) request.fields['bank_name'] = bank_name;

      if (accoune_type != null && accoune_type.isNotEmpty) request.fields['account_type'] = accoune_type;

      if (account_name != null && account_name.isNotEmpty) request.fields['account_name'] = account_name;

      if (account_no != null && account_no.isNotEmpty) request.fields['account_no'] = account_no;

      if (pan_number != null && pan_number.isNotEmpty) request.fields['pan_number'] = pan_number;

      if (pan_img != null) {
        final pan_img_bytes = await pan_img.readAsBytes();
        final multipartFile = await http.MultipartFile.fromBytes(
          'pan_card_photo',
          pan_img_bytes,
          filename: pan_img.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      if (bank_acc_img != null) {
        final bank_acc_img_bytes = await bank_acc_img.readAsBytes();
        final multipartFile = await http.MultipartFile.fromBytes(
          'bank_account_photo',
          bank_acc_img_bytes,
          filename: bank_acc_img.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      printAPIResponse(response);

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final status = body['isSuccess'] ?? false;
        if (status) {
          final data = body['data'];
          return data;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: $exception,Trace: $trace");
    }
    return null;
  }

  Future<bool> isBankAccountUpdated() async {
    final accountDetails = await getBankDetails();

    if (accountDetails == null) return false;

    for (var entry in accountDetails.entries) {
      final value = entry.value;

      if (value != null || value.toString().trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }

}
