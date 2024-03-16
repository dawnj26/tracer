import 'package:intl/intl.dart';

class Client {
  String firstName;
  String middleName;
  String lastName;
  String address;
  DateTime? birthdate;
  final String email;
  String role;

  Client({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.middleName = '',
    this.address = '',
    this.role = 'client',
    this.birthdate,
  });

  Client.fromMap(Map<String, dynamic> map)
      : firstName = map['firstName'].toString(),
        middleName =
            map['middleName'] == null ? '' : map['middleName'].toString(),
        lastName = map['lastName'].toString(),
        email = map['email'].toString(),
        address = map['address'] == null ? '' : map['address'].toString(),
        birthdate = map['birthdate'] != null && map['birthdate'] != ''
            ? DateFormat('yyyy-MM-dd').parse(map['birthdate'].toString())
            : null,
        role = map['role'].toString();

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'address': address,
      'birthdate':
          birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : '',
      'role': role,
    };
  }
}

class BusinessUser extends Client {
  String businessName;

  BusinessUser({
    required super.firstName,
    required super.lastName,
    required super.email,
    required this.businessName,
    super.address = '',
    super.middleName = '',
    super.role = 'business',
  });

  BusinessUser.fromMap(super.map)
      : businessName = map['businessName'].toString(),
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'businessName': businessName,
    };
  }
}
