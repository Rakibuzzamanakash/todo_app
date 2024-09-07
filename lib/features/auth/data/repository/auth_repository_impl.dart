import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import '../../domain/repository/auth_use_case.dart';
import '../../domain/user_entity/uesr_entity.dart';
import '../data_sources/database_helper/auth_helper.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper databaseHelper;

  AuthRepositoryImpl(this.databaseHelper);

  @override
  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(json.decode(response.body));

      // Retrieve the database instance from the DatabaseHelper
      final Database db = await databaseHelper.database;

      // Save only the token to the database, not the entire user object
      await db.insert(
        'auth',
        {'token': user.token},  // Store only the token
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return user;  // Return the user object for the app to use
    } else {
      throw Exception('Failed to login');
    }
  }

  // Fetch the token from the auth table
  Future<String?> getToken() async {
    // Retrieve the database instance
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query('auth', limit: 1);
    if (result.isNotEmpty) {
      return result.first['token'] as String?;
    }
    return null;  // Return null if no token found
  }

  // Implement a logout method to remove the token
  Future<void> logout() async {
    // Retrieve the database instance
    final Database db = await databaseHelper.database;

    await db.delete('auth');
  }
}
