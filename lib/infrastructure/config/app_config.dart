import 'dart:convert';
import 'dart:io';

/// Налаштування застосунку з файлу config/app_config.json.
class AppConfig {
  final String appName;
  final String storage; // memory або json
  final String dataFile;

  const AppConfig({
    required this.appName,
    required this.storage,
    required this.dataFile,
  });

  factory AppConfig.load(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return const AppConfig(
        appName: 'Music Library',
        storage: 'memory',
        dataFile: 'data/tracks.json',
      );
    }
    final map = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return AppConfig(
      appName: map['appName'] as String? ?? 'Music Library',
      storage: map['storage'] as String? ?? 'memory',
      dataFile: map['dataFile'] as String? ?? 'data/tracks.json',
    );
  }
}
