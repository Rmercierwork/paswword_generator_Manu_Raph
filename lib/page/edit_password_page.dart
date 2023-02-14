import 'package:flutter/material.dart';
import 'package:paswword_generator_manu_raph/db/passwords_database.dart';
import 'package:paswword_generator_manu_raph/model/password.dart';
import 'package:paswword_generator_manu_raph/widget/password_form_widget.dart';

class AddEditPasswordPage extends StatefulWidget {
  final Password? password;

  const AddEditPasswordPage({
    Key? key,
    this.password,
  }) : super(key: key);
  @override
  _AddEditPasswordPageState createState() => _AddEditPasswordPageState();
}

class _AddEditPasswordPageState extends State<AddEditPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late String password;

  @override
  void initState() {
    super.initState();

    password = widget.password?.password ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: PasswordFormWidget(
            password: password,
            onChangedPassword: (password) =>
                setState(() => this.password = password),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = password.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdatePassword,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdatePassword() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.password != null;

      if (isUpdating) {
        await updatePassword();
      } else {
        await addPassword();
      }

      Navigator.of(context).pop();
    }
  }

  Future updatePassword() async {
    final note = widget.password!.copy(
      password: password,
    );

    await PasswordsDatabase.instance.update(note);
  }

  Future addPassword() async {
    final note = Password(
      password: password,
    );

    await PasswordsDatabase.instance.create(note);
  }
}
