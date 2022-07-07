import 'package:dotenv/dotenv.dart';

class AppConfig {
  const AppConfig._();

  static final env = DotEnv(includePlatformEnvironment: true)..load();
}
