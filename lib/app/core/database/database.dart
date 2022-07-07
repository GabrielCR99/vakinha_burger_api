import 'dart:io';

import 'package:mysql1/mysql1.dart';

import '../../config/app_config.dart';

class Database {
  Future<MySqlConnection> openConnection() async {
    final connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: AppConfig.env['DATABASE_HOST'] ??
            AppConfig.env['databaseHost'] ??
            '',
        port: int.tryParse(
              AppConfig.env['DATABASE_PORT'] ??
                  AppConfig.env['databasePort'] ??
                  '',
            ) ??
            3306,
        user: AppConfig.env['DATABASE_USER'] ?? AppConfig.env['databaseUser'],
        password: AppConfig.env['DATABASE_PASSWORD'] ??
            AppConfig.env['databasePassword'],
        db: AppConfig.env['DATABASE_NAME'] ?? AppConfig.env['databaseName'],
      ),
    );
    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    return connection;
  }
}
