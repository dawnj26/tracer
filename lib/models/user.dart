class Client {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const Client({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

class BusinessUser extends Client {
  final String businessName;

  const BusinessUser({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.password,
    required this.businessName,
  });
}
