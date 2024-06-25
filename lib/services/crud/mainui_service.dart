import 'package:aiguru/services/crud/crud_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;



class MainService {

  Database? _db;

  Future<DatabaseMain> updateMain({
    required DatabaseMain main,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    await getMain(id: main.id);


    final updatesCount = await db.update(mainTable, {
      textColumn: text,
      isSyncedWithCloudColumn:0,
    });

    if(updatesCount == 0){
      throw CouldNotUpdateMain();
    } else {
      return await getMain(id: main.id);
    }
  }

  Future<Iterable<DatabaseMain>> getAllMains() async {
    final db = _getDatabaseOrThrow();
    final mains = await db.query(
      mainTable,
    );
    
    return mains.map((mainRow) => DatabaseMain.fromRow(mainRow));
  }

  Future<DatabaseMain> getMain ({ required int id}) async {
    final db = _getDatabaseOrThrow();
    final mains = await db.query(
      mainTable,
      limit: 1,
      where: 'id = ?',
      whereArgs:  [id],
    );

    if(mains.isEmpty){
      throw CouldNotFindMain();
    } else {
      return DatabaseMain.fromRow(mains.first);
    }
  }

  Future<int> deleteAllMain() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(mainTable);
  }

  Future<void> deleteMain({ required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      mainTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeletMain();
    }
  }

  Future<DatabaseMain> createMain({required DatabaseUser owner}) async  {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in the database with correct id
    final dbUser = await getUser(email: owner.email);
    if(dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text ='';
    // create the note
    final mainId = await db.insert(mainTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final main = DatabaseMain(
      id: mainId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    return main;


  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty){
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId, 
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable, 
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],    
    );

    if (deletedCount != 1){
      throw CouldNotDeleteUser();
    }

  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
      final db = _db;
      if (db == null) {
        throw DatabaseIsNotOpen();
      
      }else {
        await db.close();
        _db = null;
      }

  }

  Future<void> open() async {
    if(_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create user table
        await db.execute(createUserTable);

        //create main table
        await db.execute(createMainTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirecory();
    }


  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id, 
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int,
   email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override bool operator == (covariant DatabaseUser other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
}

class DatabaseMain {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseMain({
    required this.id, 
    required this.userId, 
    required this.text, 
    required this.isSyncedWithCloud,
  });

  DatabaseMain.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int,
   userId = map[userIdColumn] as int,
   text = map[textColumn] as String,
   isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int ) == 1 ? true :false;

  @override
  String toString()=>'Note, ID =$id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud';

   @override bool operator == (covariant DatabaseMain other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

const dbName = 'avinyaai.db';
const mainTable = 'main';
const userTable = 'user';
const idColumn  = "id";
const emailColumn = ' email';
const userIdColumn = ' user_id';
const textColumn = "text";
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = ''' CREATE TABLE IF NOT EXISTS "user" (
          "id"	INTEGER NOT NULL,
          "email"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("id" AUTOINCREMENT)
        );''';

const createMainTable = '''CREATE TABLE IF NOT EXISTS "main" (
          "id"	INTEGER NOT NULL,
          "user_id"	INTEGER NOT NULL,
          "text"	TEXT,
          PRIMARY KEY("id" AUTOINCREMENT),
          FOREIGN KEY("user_id") REFERENCES "user"("id")
        );''';