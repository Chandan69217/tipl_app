import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:tipl_app/api_service/api_url.dart';
import 'package:tipl_app/api_service/handle_reposone.dart';
import 'package:tipl_app/api_service/log_api_response.dart';
import 'package:tipl_app/core/models/income_model.dart';
import 'package:tipl_app/core/utilities/preference.dart';


class IncomeApiService {
  final BuildContext? context;

  IncomeApiService({this.context});

  Future<List<IncomeModel>> getAllIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(Urls.baseUrl, '${Urls.getAllIncomes}${member_id}');

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getDirectIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getDirectIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getLevelIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getLevelIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getCashbackIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getCashbackIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getMatchingIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getMatchingIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getDailyIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getDailyIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getSalaryIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getSalaryIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

  Future<List<IncomeModel>> getRewardsIncome() async {
    try {
      final token = Pref.instance.getString(PrefConst.TOKEN);
      final member_id = Pref.instance.getString(PrefConst.MEMBER_ID);

      final url = Uri.https(
        Urls.baseUrl,
        '${Urls.getRewardsIncomes}${member_id}',
      );

      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
      );

      printAPIResponse(response);
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final isSuccess = body['isSuccess'] ?? false;
        if (isSuccess) {
          final data = body['data'] as List<dynamic>;
          return data.map<IncomeModel>((e) => IncomeModel.fromJson(e)).toList();
        }
      } else {
        handleApiResponse(context, response);
      }
    } catch (exception, trace) {
      print("Exception: ${exception}, Trace: ${trace}");
    }
    return [];
  }

}
