class Registration {
  final String message;
  final Map user;
  final Map errors;

  Registration({this.message, this.user, this.errors});
  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      message: json['message'],
      user: json['user'],
      errors: json['errors'],
    );
  }
}

class RegistrationInfo {
  final String id;
  final String name;
  final String category;
  final String description;
  final String created;
  RegistrationInfo(
      {this.id, this.name, this.category, this.description, this.created});
  factory RegistrationInfo.fromJson(Map<String, dynamic> json) {
    return RegistrationInfo(
        id: json['id'],
        name: json['name'],
        category: json['category_id'],
        description: json['description'],
        created: (json['created_at'] == null)
            ? ""
            : DateTime.parse(json['created_at']).toString());
  }
}
