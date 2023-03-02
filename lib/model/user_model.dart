class UserModel {
  String uid;
  String name;
  String phone;
  String countryCode;
  String isoCode;
  String gender;
  int? dob;
  int createDate;
  String designation;
  String address;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.countryCode,
    required this.isoCode,
    required this.gender,
    this.dob,
    required this.createDate,
    this.designation = '',
    this.address = '',
  });

  UserModel.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        dob = data['dob'],
        gender = data['gender'],
        phone = data['phone'],
        isoCode = data['isoCode'],
        countryCode = data['countryCode'],
        createDate = data['createDate'],
        designation = data['designation'],
        address = data['address'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'createDate': createDate,
      'designation': designation,
      'address': address,
    };
  }
}
