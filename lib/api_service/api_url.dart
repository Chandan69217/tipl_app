class Urls{
  static const String baseUrl = 'api.neuralpool.in';
  static const String login = '/api/auth/login-basic/';
  static const String register = '/api/auth/register/';
  static const String getUserDetailsBySponserId = '/api/auth/users-by-sponsor';
  static const String UpdateProfile = '/api/auth/update-profile/';
  static const String getProfile = '/api/auth/get-profile/';
  static const String welcomeLetter = '/api/user/welcomeLetter';
  static const String userViewAndUpdate = '/api/user/updateProfile';
  static const String changeUserTransPassword = '/api/user/updateTrans_password';
  static const String userIdCard = '/api/user/idCard';
  static const String getAllUsers = '/api/user/getAllUserDetails';
  static const String userUpdate = '/api/user/updateUser';
  static const String addBankDetails = '/api/bank/addBankDetail';
  static const String updateBankDetails = '/api/bank/updateBankDetail';
  static const String getBankDetails = '/api/bank/getBankDetail';
  static const String getAllBankRecords = '/api/bank/getAllBankDetails';
  static const String deleteBankRecords = '/api/bank/deleteBankDetail';

          // Meeting URLS
  static const String getMeeting = '/api/meetings/all';
  static const String getMeetingByFilter = '/api/meetings/filter';
  static const String addNewMeeting = '/api/meetings/add';
}