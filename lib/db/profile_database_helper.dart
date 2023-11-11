import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfileDatabaseHelper {
  static final ProfileDatabaseHelper _instance = ProfileDatabaseHelper.internal();

  factory ProfileDatabaseHelper() => _instance;

  ProfileDatabaseHelper.internal();

  Database? _db;

  final _profileController = StreamController<void>.broadcast();

  Stream<void> get profileChanges => _profileController.stream;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'profile_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE profile (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        aboutMe TEXT,
        location TEXT
      )
    ''');
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final dbClient = await db;
    await dbClient.update('profile', profileData);
    _profileController.add(null); // Notify listeners about the profile change
  }

  Future<Map<String, dynamic>> getProfile() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> profiles = await dbClient.query('profile');
    if (profiles.isNotEmpty) {
      return profiles.first;
    }
    return {};
  }
}
