import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:paswword_generator_manu_raph/db/passwords_database.dart';
import 'package:paswword_generator_manu_raph/model/password.dart';
import 'package:paswword_generator_manu_raph/page/edit_password_page.dart';
import 'package:paswword_generator_manu_raph/page/password_detail_page.dart';
import 'package:paswword_generator_manu_raph/widget/password_card_widget.dart';

class PasswordsPage extends StatefulWidget {
  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  late List<Password> passwords;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshPasswords();
  }

  @override
  void dispose() {
    PasswordsDatabase.instance.close();

    super.dispose();
  }

  Future refreshPasswords() async {
    setState(() => isLoading = true);

    this.passwords = await PasswordsDatabase.instance.readAllPasswords();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Passwords',
            style: TextStyle(fontSize: 24),
          ),
          actions: [Icon(Icons.search), SizedBox(width: 12)],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : passwords.isEmpty
                  ? Text(
                      'No Passwords',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : buildPasswords(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditPasswordPage()),
            );

            refreshPasswords();
          },
        ),
      );

  Widget buildPasswords() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: passwords.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final password = passwords[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PasswordDetailPage(passwordId: password.id!),
              ));

              refreshPasswords();
            },
            child: PasswordCardWidget(password: password, index: index),
          );
        },
      );
}
