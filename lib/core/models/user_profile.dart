
class UserProfile {
  UserProfile({
    required this.memberId,
    required this.profile,
    required this.maritalStatus,
    required this.dob,
    required this.sponsorId,
    required this.sponsorName,
    required this.position,
    required this.packageType,
    required this.panNumber,
    required this.fullName,
    required this.mobileNo,
    required this.email,
    required this.gender,
    required this.state,
    required this.district,
    required this.status,
    required this.pinCode,
    required this.address,
    required this.createdAt,
  });

  final String panNumber;
  final String packageType;
  final String memberId;
  final String profile;
  final String maritalStatus;
  final String dob;
  final String sponsorId;
  final String sponsorName;
  final String position;
  final String fullName;
  final String mobileNo;
  final String email;
  final String gender;
  final String state;
  final String district;
  final String status;
  final String pinCode;
  final String address;
  final DateTime? createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
      memberId: json["member_id"] ?? "N/A",
      profile: json["photo"] ?? "",
      maritalStatus: json["marital_status"] ?? "N/A",
      packageType: json["package_type"] ?? "N/A",
      dob: json["date_of_birth"] ?? "N/A",
      sponsorId: json["sponsor_id"] ?? "N/A",
      sponsorName: json["sponsor_name"] ?? "N/A",
      position: json["position"] ?? "N/A",
      fullName: json["full_name"] ?? "N/A",
      mobileNo: json["mobile_no"] ?? "N/A",
      panNumber: json["pan_number"] ?? "N/A",
      email: json["email"] ?? "N/A",
      gender: json["gender"] ?? "N/A",
      state: json["state"] ?? "N/A",
      district: json["district"] ?? "N/A",
      status: json["status"] ?? "N/A",
      pinCode: json["pin_code"] ?? "N/A",
      address: json["address"] ?? "N/A",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "N/A"),
    );
  }

  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "profile": profile,
    "marital_status": maritalStatus,
    "dob": dob,
    "sponsor_id": sponsorId,
    "sponsor_name": sponsorName,
    "position": position,
    "full_name": fullName,
    "mobile_no": mobileNo,
    "email": email,
    "gender": gender,
    "state": state,
    "district": district,
    "status": status,
    "pin_code": pinCode,
    "address": address,
    "createdAt": createdAt?.toIso8601String(),
  };

}
