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

      final Database db = await databaseHelper.database;

      await db.insert(
        'auth',
        {'token': user.token},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<String?> getToken() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query('auth', limit: 1);
    if (result.isNotEmpty) {
      return result.first['token'] as String?;
    }
    return null;
  }

  Future<void> logout() async {
    final Database db = await databaseHelper.database;

    await db.delete('auth');
  }
}
