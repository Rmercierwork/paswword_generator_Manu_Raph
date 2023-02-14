import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paswword_generator_manu_raph/db/passwords_database.dart';
import 'package:paswword_generator_manu_raph/model/password.dart';
import 'package:paswword_generator_manu_raph/page/edit_password_page.dart';

class PasswordDetailPage extends StatefulWidget {
  final int passwordId;

  const PasswordDetailPage({
    Key? key,
    required this.passwordId,
  }) : super(key: key);

  @override
  _PasswordDetailPageState createState() => _PasswordDetailPageState();
}

class _PasswordDetailPageState extends State<PasswordDetailPage> {
  late Password password;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPassword();
  }

  Future refreshPassword() async {
    setState(() => isLoading = true);

    this.password =
        await PasswordsDatabase.instance.readPassword(widget.passwordId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(12),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      password.password,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(height: 8),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditPasswordPage(password: password),
        ));

        refreshPassword();
      });

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await PasswordsDatabase.instance.delete(widget.passwordId);

          Navigator.of(context).pop();
        },
      );
}
