import 'package:flutter/material.dart';

class PasswordFormWidget extends StatelessWidget {
  final String? password;
  final ValueChanged<String> onChangedPassword;

  const PasswordFormWidget({
    Key? key,
    this.password = '',
    required this.onChangedPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [],
              ),
              buildPassword(),
              SizedBox(height: 8),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildPassword() => TextFormField(
        maxLines: 1,
        initialValue: password,
        style: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Password',
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (password) => password != null && password.isEmpty
            ? 'The password cannot be empty'
            : null,
        onChanged: onChangedPassword,
      );
}
