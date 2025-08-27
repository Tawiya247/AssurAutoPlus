class User {
  final String userId;
  final String phone;
  final String? firstName;
  final String? lastName;
  final double? totalBalance;
  final double? monthlyContribution;

  User({
    required this.userId,
    required this.phone,
    this.firstName,
    this.lastName,
    this.totalBalance,
    this.monthlyContribution,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'], // L'API retourne 'id' pour userId
      phone: json['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      totalBalance: (json['totalBalance'] as num?)?.toDouble(),
      monthlyContribution: (json['monthlyContribution'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'totalBalance': totalBalance,
      'monthlyContribution': monthlyContribution,
    };
  }
}
