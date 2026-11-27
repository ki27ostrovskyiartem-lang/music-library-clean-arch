import 'package:music_library/application/use_cases/add_track.dart';
import 'package:music_library/application/use_cases/get_all_tracks.dart';
import 'package:music_library/application/use_cases/remove_track.dart';
import 'package:music_library/application/use_cases/search_tracks.dart';
import 'package:music_library/application/use_cases/toggle_favorite.dart';
import 'package:music_library/domain/repositories/track_repository.dart';
import 'package:music_library/infrastructure/config/app_config.dart';
import 'package:music_library/infrastructure/repositories/in_memory_track_repository.dart';
import 'package:music_library/infrastructure/repositories/json_track_repository.dart';
import 'package:music_library/presentation/cli/cli.dart';

/// Точка входу. Тут збираються всі шари (Dependency Injection).
void main(List<String> args) {
  final demo = args.contains('demo');

  // 1. Налаштування
  final config = AppConfig.load('config/app_config.json');

  // 2. Конкретна реалізація сховища (Infrastructure).
  //    У режимі demo завжди пам'ять, щоб не створювати файли.
  final TrackRepository repository =
      demo ? InMemoryTrackRepository() : _createRepository(config);

  // 3. Use cases отримують репозиторій через конструктор (Application)
  final cli = Cli(
    appName: config.appName,
    addTrack: AddTrackUseCase(repository),
    getAllTracks: GetAllTracksUseCase(repository),
    removeTrack: RemoveTrackUseCase(repository),
    toggleFavorite: ToggleFavoriteUseCase(repository),
    searchTracks: SearchTracksUseCase(repository),
  );

  // 4. Запуск інтерфейсу (Presentation)
  if (demo) {
    cli.runDemo();
  } else {
    cli.run();
  }
}

/// Обирає сховище за налаштуванням. Щоб змінити спосіб зберігання,
/// достатньо змінити поле storage у config/app_config.json.
TrackRepository _createRepository(AppConfig config) {
  switch (config.storage) {
    case 'json':
      return JsonTrackRepository(config.dataFile);
    default:
      return InMemoryTrackRepository();
  }
}
