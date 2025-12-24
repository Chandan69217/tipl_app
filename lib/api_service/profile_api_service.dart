import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/models/user_profile.dart';
import 'package:tipl_app/core/utilities/preference.dart';


class ProfileAPIService {
  BuildContext? context;
  ProfileAPIService({this.context});

  Future<Map<String, dynamic>?> getProfileDetailsByMemberId({String? id}) async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      final url = Uri.https(Urls.baseUrl, Urls.getProfile, {
        'member_id': id??memberId,
      });

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
          final data = body['data'] as Map<String, dynamic>;
          return data;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return null;
  }

  Future<bool> isProfileCompleted() async {
    try {
      final data = await getProfileDetailsByMemberId();
      if (data == null) return false;
      for (var entry in data.entries) {
        if (entry.value == null) {
          return false;
        }
      }
    } catch (exception, trace) {
      print('Exception: ${exception}, Trace: ${trace}');
    }
    return true;
  }

  Future<Map<String, dynamic>?> getWelcomeLetterDetails() async {
    try {
      final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final url = Uri.https(Urls.baseUrl, Urls.welcomeLetter, {
        'member_id': memberId,
      });

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
        final status = body['isSuccess'];
        if (status) {
          final data = body['data'] as List<dynamic>;
          return data.first;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception},Trace: ${trace}");
    }
    return null;
  }

  // Future<Map<String, dynamic>?> getUserProfileUpdate({
  //   UserProfile? details,
  // }) async {
  //   final token = Pref.instance.getString(PrefConst.TOKEN);
  //   final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);
  //   try {
  //     final url = Uri.https(Urls.baseUrl, Urls.userViewAndUpdate, {
  //       'member_id': member_id,
  //     });
  //
  //
  //     final body = details != null ? json.encode({
  //       "full_name": details.fullName,
  //       "mobile_no": details.mobileNo,
  //       "email": details.email,
  //       "gender": details.gender,
  //       "state": details.state,
  //       "district": details.district,
  //     }) : null;
  //
  //     final response = await put(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-type': 'Application/json',
  //       },
  //       body: body,
  //     );
  //
  //     printAPIResponse(response);
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body) as Map<String, dynamic>;
  //       final status = data['isSuccess'] ?? false;
  //       if (status) {
  //         final values = data['data'] as Map<String, dynamic>;
  //         return values;
  //       }
  //     } else {
  //       handleApiResponse(context, response);
  //     }
  //   } catch (exception, trace) {
  //     print("Exception: ${exception},Trace ${trace}");
  //   }
  //   return null;
  // }


  Future<Map<String, dynamic>?> getUserProfileUpdate({
    UserProfile? details,
    File? photo,
  }) async {
    final token = Pref.instance.getString(PrefConst.TOKEN);
    final memberId = Pref.instance.getString(PrefConst.MEMBER_ID);

    try {
      final uri = Uri.https(
        Urls.baseUrl,
        Urls.userViewAndUpdate,
        {'member_id': memberId},
      );

      final request = http.MultipartRequest('PUT', uri);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (details != null) {
        request.fields.addAll({
          'full_name': details.fullName ?? '',
          'mobile_no': details.mobileNo ?? '',
          'email' : details.email??'',
          'gender': details.gender ?? '',
          'state': details.state ?? '',
          'marital_status' : details.maritalStatus??'',
          'date_of_birth' : details.dob??'',
          'address' : details.address??'',
          'pin_code' : details.pinCode??'',
          'district': details.district ?? '',
        });
      }

      // Image upload
      if (photo != null) {
        final fileExtension = photo.path.split('.').last.toLowerCase();

        if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photo',
              photo.path,
              contentType: MediaType('image', fileExtension == 'png' ? 'png' : 'jpeg'),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      printAPIResponse(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['isSuccess'] == true) {
          return data['data'] as Map<String, dynamic>;
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (e, stack) {
      debugPrint("Exception: $e");
      debugPrintStack(stackTrace: stack);
    }

    return null;
  }


}



