// import 'package:flutter/cupertino.dart';
// import 'package:tipl_app/api_service/income_api/income_api_service.dart';
// import 'package:tipl_app/core/models/income_model.dart';
//
// class IncomeProvider extends ChangeNotifier {
//   List<IncomeModel> allIncome = [];
//   List<IncomeModel> cashbackIncome = [];
//   List<IncomeModel> dailyIncome = [];
//   List<IncomeModel> rewardsIncome = [];
//   List<IncomeModel> levelIncome = [];
//   List<IncomeModel> directIncome = [];
//   List<IncomeModel> matchingIncome = [];
//   List<IncomeModel> salaryIncome = [];
//
//   Future<void> initialized() async {
//     final api = IncomeApiService();
//
//     final results = await Future.wait([
//       api.getAllIncome(),
//       api.getCashbackIncome(),
//       api.getDailyIncome(),
//       api.getRewardsIncome(),
//       api.getLevelIncome(),
//       api.getDirectIncome(),
//       api.getMatchingIncome(),
//       api.getSalaryIncome(),
//     ]);
//
//     allIncome = results[0];
//     cashbackIncome = results[1];
//     dailyIncome = results[2];
//     rewardsIncome = results[3];
//     levelIncome = results[4];
//     directIncome = results[5];
//     matchingIncome = results[6];
//     salaryIncome = results[7];
//
//     notifyListeners();
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/income_api/income_api_service.dart';
import 'package:tipl_app/core/models/income_model.dart';

class IncomeProvider extends ChangeNotifier {
  // ------------------ LISTS ------------------
  List<IncomeModel> allIncome = [];
  List<IncomeModel> cashbackIncome = [];
  List<IncomeModel> dailyIncome = [];
  List<IncomeModel> rewardsIncome = [];
  List<IncomeModel> levelIncome = [];
  List<IncomeModel> directIncome = [];
  List<IncomeModel> matchingIncome = [];
  List<IncomeModel> salaryIncome = [];

  // ------------------ TOTALS ------------------
  double totalAllIncome = 0.0;
  double totalCashbackIncome = 0.0;
  double totalDailyIncome = 0.0;
  double totalRewardsIncome = 0.0;
  double totalLevelIncome = 0.0;
  double totalDirectIncome = 0.0;
  double totalMatchingIncome = 0.0;
  double totalSalaryIncome = 0.0;

  Future<void> initialized() async {
    final api = IncomeApiService();

    final results = await Future.wait([
      api.getAllIncome(),
      api.getCashbackIncome(),
      api.getDailyIncome(),
      api.getRewardsIncome(),
      api.getLevelIncome(),
      api.getDirectIncome(),
      api.getMatchingIncome(),
      api.getSalaryIncome(),
    ]);

    allIncome = results[0];
    cashbackIncome = results[1];
    dailyIncome = results[2];
    rewardsIncome = results[3];
    levelIncome = results[4];
    directIncome = results[5];
    matchingIncome = results[6];
    salaryIncome = results[7];

    _calculateAllTotals();

    notifyListeners();
  }

  // ------------------ CALCULATE TOTALS ------------------
  double _sum(List<IncomeModel> list) =>
      list.fold(0.0, (sum, item) => sum + (item.amount ?? 0.0));

  void _calculateAllTotals() {
    totalAllIncome = _sum(allIncome);
    totalCashbackIncome = _sum(cashbackIncome);
    totalDailyIncome = _sum(dailyIncome);
    totalRewardsIncome = _sum(rewardsIncome);
    totalLevelIncome = _sum(levelIncome);
    totalDirectIncome = _sum(directIncome);
    totalMatchingIncome = _sum(matchingIncome);
    totalSalaryIncome = _sum(salaryIncome);
  }
}
