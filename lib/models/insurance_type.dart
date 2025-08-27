class InsuranceType {
  final String id;
  final String name;
  final String description;

  InsuranceType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory InsuranceType.fromJson(Map<String, dynamic> json) {
    return InsuranceType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
