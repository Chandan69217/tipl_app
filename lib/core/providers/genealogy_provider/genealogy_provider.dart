import 'package:flutter/cupertino.dart';
import 'package:tipl_app/api_service/genealogy_api/genealogy_api_service.dart';

class GenealogyProvider extends ChangeNotifier{
  List<dynamic> filterAllTeams = [];
  List<dynamic> filterDirectTeams = [];
  List<dynamic> filterInactiveTeams = [];
  List<dynamic> filterActiveTeams = [];
  List<dynamic> allTeams = [];
  List<dynamic> allDirectTeams = [];
  List<dynamic> inactiveTeams = [];
  List<dynamic> activeTeams = [];

  // Tree view attributes

  List<dynamic> leftMembers = [];
  List<dynamic> rightMembers = [];
  Map<String,dynamic> associate = {};
  int totalLeft = 0;
  int totalRight = 0;
  int activeLeft = 0;
  int activeRight = 0 ;

  void initialized()async{
    allTeams = await GenealogyAPIService().getGenealogyAllTeam();
    allDirectTeams = await GenealogyAPIService().getGenealogyDirectMember();
    inactiveTeams = await GenealogyAPIService().getGenealogyInactiveTeam();
    activeTeams = await GenealogyAPIService().getGenealogyActiveTeam();
    filterAllTeams = allTeams;
    filterDirectTeams = allDirectTeams;
    filterInactiveTeams = inactiveTeams;
    filterActiveTeams = activeTeams;
    final treeView = await GenealogyAPIService().getGenealogyTree();
    if(treeView != null){
      associate = treeView['associate']??{};
      totalLeft = treeView['totalLeft']??0;
      totalRight = treeView['totalRight']??0;
      activeLeft = treeView['activeLeft']??0;
      activeRight = treeView['activeRight']??0;
      leftMembers = treeView['leftMembers']??[];
      rightMembers = treeView['rightMembers']??[];
    }
    notifyListeners();
  }

  _clearSearch(){
    filterAllTeams = allTeams;
    filterDirectTeams = allDirectTeams;
    filterActiveTeams = activeTeams;
    filterInactiveTeams = inactiveTeams;
    notifyListeners();
  }

  Future<List<dynamic>> _getListByQuery(List<dynamic> data, String query) async {
    final lowerQuery = query.toLowerCase().trim();

    return data.where((m) {
      try {
        final name = (m['full_name'] ?? '').toString().toLowerCase();
        final memberId = (m['member_id'] ?? '').toString().toLowerCase();

        return name.contains(lowerQuery) || memberId.contains(lowerQuery);
      } catch (e) {
        print('Search error: $e');
        return false;
      }
    }).toList();
  }


  void search(String? query,int searchIndex)async{
    if(query == null || query.isEmpty){
      _clearSearch();
      return;
    }

    switch(searchIndex){
      case 0:
        filterAllTeams = await _getListByQuery(allTeams, query.trim().toLowerCase());
        break;
      case 1:
        filterDirectTeams = await _getListByQuery(allDirectTeams, query.trim().toLowerCase());
        break;
      case 2:
        filterActiveTeams = await _getListByQuery(activeTeams, query.trim().toLowerCase());
         break;
      case 3:
        filterInactiveTeams = await _getListByQuery(inactiveTeams, query.trim().toLowerCase());
        break;
    }

    notifyListeners();

  }

}