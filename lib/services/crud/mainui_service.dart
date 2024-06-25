import 'dart:async';
import 'package:aiguru/services/crud/crud_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;



class MainService {

  Database? _db;

  List<DatabaseMain> _mains = [];

  static final MainService _shared = MainService._sharedInstance();
  MainService._sharedInstance();
  factory MainService()=> _shared;

  final _mainStreamController = StreamController<List<DatabaseMain>>.broadcast();

  Stream<List<DatabaseMain>> get allMain => _mainStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user =await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<void> _cachedMain() async {
    final allMains = await getAllMains();
    _mains = allMains.toList();
    _mainStreamController.add(_mains);
  }

  Future<DatabaseMain> updateMain({
    required DatabaseMain main,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    
    //make sure main exixts
    await getMain(id: main.id);

    // update DB
    final updatesCount = await db.update(mainTable, {
      textColumn: text,
      isSyncedWithCloudColumn:0,
    });

    if(updatesCount == 0){
      throw CouldNotUpdateMain();
    } else {
      final updatedMain = await getMain(id: main.id);
      _mains.removeWhere((main) => main.id == updatedMain.id);
      _mains.add(updatedMain);
      _mainStreamController.add(_mains);
      return updatedMain;
    }
  }

  Future<Iterable<DatabaseMain>> getAllMains() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final mains = await db.query(
      mainTable,
    );
    
    return mains.map((mainRow) => DatabaseMain.fromRow(mainRow));
  }

  Future<DatabaseMain> getMain ({ required int id}) async {
    await _ensureDbIsOpen();
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
      final main = DatabaseMain.fromRow(mains.first);
      _mains.removeWhere((main) => main.id == id);
      _mains.add(main);
      _mainStreamController.add(_mains);
      return main;
    }
  }

  Future<int> deleteAllMain() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions =  await db.delete(mainTable);
    _mains =[];
    _mainStreamController.add(_mains);
    return numberOfDeletions;
  }

  Future<void> deleteMain({ required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      mainTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeletMain();
    } else {
      _mains.removeWhere((main) => main.id == id);
      _mainStreamController.add(_mains);
    }
  }

  Future<DatabaseMain> createMain({required DatabaseUser owner}) async  {
    await _ensureDbIsOpen();
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

    _mains.add(main);
    _mainStreamController.add(_mains);

    return main;


  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException{
      //empty
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
        await _cachedMain();

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