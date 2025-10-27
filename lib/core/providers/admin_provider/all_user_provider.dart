import 'package:flutter/material.dart';
import 'package:tipl_app/api_service/admin_api/users_details_api.dart';


class AllUserDetailsProvider extends ChangeNotifier {
  int inactiveUser = 0;
  int activeUser = 0;
  int totalUser = 0;

  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  final BuildContext? context;
  String _currentStatusFilter = 'all';
  String _currentSearchQuery = '';

  AllUserDetailsProvider({this.context});

  Future<void> initialized() async {
    try {
      users = List<Map<String, dynamic>>.from(
        await UsersDetailsApi(context: context).getAllUsers(),
      );

      totalUser = users.length;
      activeUser = users.where((u) => (u['status']?.toString().toLowerCase() ?? '') == 'active').length;
      inactiveUser = totalUser - activeUser;

      filteredUsers = List.from(users);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading users: $e");
    }

  }

  void _applyFilters() {
    List<Map<String, dynamic>> tempList = List.from(users);

    if (_currentSearchQuery.isNotEmpty) {
      final query = _currentSearchQuery.trim().toLowerCase();

      tempList = tempList.where((user) {
        final memberId = user['member_id']?.toString().toLowerCase() ?? '';
        final mobile = user['mobile_no']?.toString().toLowerCase() ?? '';
        final email = user['email']?.toString().toLowerCase() ?? '';
        final fullName = user['full_name']?.toString().toLowerCase() ?? '';

        return memberId.contains(query) ||
            mobile.contains(query) ||
            email.contains(query) ||
            fullName.contains(query);
      }).toList();
    }

    if (_currentStatusFilter != 'all') {
      final lowerStatus = _currentStatusFilter.toLowerCase();
      tempList = tempList.where((u) =>
      (u['status']?.toString().toLowerCase() ?? '') == lowerStatus).toList();
    }

    filteredUsers = tempList;
    notifyListeners();
  }

  void searchUsers(String query) {
    _currentSearchQuery = query;
    _applyFilters();
  }

  void filterByStatus(String status) {
    _currentStatusFilter = status.toLowerCase();
    _applyFilters();
  }


  void resetFilters() {
    _currentStatusFilter = 'all';
    _currentSearchQuery = '';
    filteredUsers = List.from(users);
    notifyListeners();
  }

  Future<bool> blockAndUnblockUser({required String userMemberID,bool? block = true})async{
    final isUpdated = await UsersDetailsApi(context: context).updateUser(userMemberID: userMemberID,status: block! ? 'Inactive':'Active');
    if(isUpdated){
      initialized();
      _applyFilters();
      notifyListeners();
    }
    return isUpdated;
  }

  Future<bool> updateUserDetails({
    required String userMemberID,
    String? status,
    String? state,
    String? address,
    String? district,
    String? dob,
    String? full_name,
    String? gender,
    String? marital_status,
    String? package_type,
    String? pan_number,
    String? pincode,
    String? sponsor_id,
})async{
    final isUpdated = await UsersDetailsApi(context: context).updateUser(
        userMemberID: userMemberID,
        status: status,
      state: state,
      address: address,
      district: district,
      dob: dob,
      full_name: full_name,
      gender: gender,
      marital_status: marital_status,
      package_type: package_type,
      pan_number: pan_number,
      pincode: pincode,
      sponsor_id: sponsor_id
    );
    if(isUpdated){
      initialized();
      _applyFilters();
      notifyListeners();
    }
    return isUpdated;
  }

}

