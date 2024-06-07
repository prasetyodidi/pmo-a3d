class User {
  final int uid;
  final String name;

  User({
    required this.uid,
    required this.name,
  });

  // fromJson: Factory constructor to create an instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
    );
  }

  // toJson: Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'name': name,
    };
  }
}
