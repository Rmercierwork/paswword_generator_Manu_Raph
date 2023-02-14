import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:paswword_generator_manu_raph/model/password.dart';

class PasswordsDatabase {
  static final PasswordsDatabase instance = PasswordsDatabase._init();

  static Database? _database;

  PasswordsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('passwords.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tablePasswords ( 
  ${PasswordFields.id} $idType, 
  ${PasswordFields.password} $textType,
  )
''');
  }

  Future<Password> create(Password password) async {
    final db = await instance.database;

    final id = await db.insert(tablePasswords, password.toJson());
    return password.copy(id: id);
  }

  Future<Password> readPassword(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePasswords,
      columns: PasswordFields.values,
      where: '${PasswordFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Password.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Password>> readAllPasswords() async {
    final db = await instance.database;

    final orderBy = '${PasswordFields.id} ASC';

    final result = await db.query(tablePasswords, orderBy: orderBy);

    return result.map((json) => Password.fromJson(json)).toList();
  }

  Future<int> update(Password password) async {
    final db = await instance.database;

    return db.update(
      tablePasswords,
      password.toJson(),
      where: '${PasswordFields.id} = ?',
      whereArgs: [password.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tablePasswords,
      where: '${PasswordFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
