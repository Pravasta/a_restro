import 'package:sqflite/sqflite.dart';

import 'package:a_restro/data/model/request/add_favorite_resto_request_model.dart';
import 'package:a_restro/data/model/response/restaurant_response_model.dart';

class RestaurantLocalService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'restaurant';
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  Future<int> insertRestaurant(AddFavoriteRestoRequestModel data) async {
    final db = await database;

    final id = await db.insert(
      _tableName,
      data.toLocalJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Restaurant>> getAllFavoriteRestaurant() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(_tableName);

    return result.map((e) => Restaurant.fromMap(e)).toList();
  }

  Future<int> deleteRestaurant(String id) async {
    final db = await database;

    final result = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<Restaurant> getRestaurantById(String id) async {
    final db = await database;

    final result = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return result.map((e) => Restaurant.fromMap(e)).first;
  }
}
