final String tablePasswords = 'passwords';

class PasswordFields {
  static final List<String> values = [
    id,
    password,
  ];

  static final String id = '_id';
  static final String password = 'password';
}

class Password {
  final int? id;
  final String password;

  const Password({
    this.id,
    required this.password,
  });

  Password copy({
    int? id,
    String? password,
  }) =>
      Password(
        id: id ?? this.id,
        password: password ?? this.password,
      );

  static Password fromJson(Map<String, Object?> json) => Password(
        id: json[PasswordFields.id] as int?,
        password: json[PasswordFields.password] as String,
      );

  Map<String, Object?> toJson() => {
        PasswordFields.id: id,
        PasswordFields.password: password,
      };
}
