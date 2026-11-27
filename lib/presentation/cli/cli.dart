import 'dart:io';

import '../../application/use_cases/add_track.dart';
import '../../application/use_cases/get_all_tracks.dart';
import '../../application/use_cases/remove_track.dart';
import '../../application/use_cases/search_tracks.dart';
import '../../application/use_cases/toggle_favorite.dart';
import '../../domain/entities/track.dart';
import '../../domain/errors/domain_exception.dart';

/// Консольний інтерфейс (шар Presentation).
/// Містить тільки взаємодію з користувачем, а логіку виконують use cases.
class Cli {
  final String appName;
  final AddTrackUseCase addTrack;
  final GetAllTracksUseCase getAllTracks;
  final RemoveTrackUseCase removeTrack;
  final ToggleFavoriteUseCase toggleFavorite;
  final SearchTracksUseCase searchTracks;

  Cli({
    required this.appName,
    required this.addTrack,
    required this.getAllTracks,
    required this.removeTrack,
    required this.toggleFavorite,
    required this.searchTracks,
  });

  /// Інтерактивний режим.
  void run() {
    print('=== $appName ===');
    while (true) {
      _printMenu();
      final choice = _ask('>');
      switch (choice) {
        case '1':
          _showAll();
          break;
        case '2':
          _add();
          break;
        case '3':
          _remove();
          break;
        case '4':
          _toggle();
          break;
        case '5':
          _search();
          break;
        case '0':
          print('До побачення!');
          return;
        default:
          print('Невідома команда.');
      }
    }
  }

  /// Автоматичний сценарій для перевірки роботи всіх use cases.
  void runDemo() {
    print('=== $appName (demo) ===');
    final first = addTrack.execute(
      title: 'Midnight Dreams',
      artist: 'Luna Wave',
      durationSeconds: 222,
    );
    addTrack.execute(title: 'Neon Streets', artist: 'The Pulse', durationSeconds: 198);
    addTrack.execute(title: 'Ocean Drive', artist: 'Aurora Sky', durationSeconds: 245);
    print('Після додавання:');
    _printTracks(getAllTracks.execute());

    toggleFavorite.execute(first.id);
    print('Після додавання в улюблені першого треку:');
    _printTracks(getAllTracks.execute());

    print('Пошук "neon":');
    _printTracks(searchTracks.execute('neon'));

    final second = getAllTracks.execute()[1];
    removeTrack.execute(second.id);
    print('Після видалення другого треку:');
    _printTracks(getAllTracks.execute());
  }

  void _printMenu() {
    print('');
    print('1. Список треків');
    print('2. Додати трек');
    print('3. Видалити трек');
    print('4. Улюблений / не улюблений');
    print('5. Пошук');
    print('0. Вихід');
  }

  String _ask(String label) {
    stdout.write('$label ');
    return (stdin.readLineSync() ?? '0').trim();
  }

  void _printTracks(List<Track> tracks) {
    if (tracks.isEmpty) {
      print('  (порожньо)');
      return;
    }
    for (var i = 0; i < tracks.length; i++) {
      print('  ${i + 1}. ${tracks[i]}');
    }
  }

  void _showAll() {
    _printTracks(getAllTracks.execute());
  }

  void _add() {
    final title = _ask('Назва:');
    final artist = _ask('Виконавець:');
    final seconds = int.tryParse(_ask('Тривалість (секунди):'));
    if (seconds == null) {
      print('Тривалість має бути числом.');
      return;
    }
    try {
      final track = addTrack.execute(
        title: title,
        artist: artist,
        durationSeconds: seconds,
      );
      print('Додано: $track');
    } on DomainException catch (e) {
      print('Помилка: ${e.message}');
    }
  }

  /// Запитує номер треку зі списку.
  Track? _pick() {
    final tracks = getAllTracks.execute();
    if (tracks.isEmpty) {
      print('Бібліотека порожня.');
      return null;
    }
    _printTracks(tracks);
    final number = int.tryParse(_ask('Номер треку:'));
    if (number == null || number < 1 || number > tracks.length) {
      print('Некоректний номер.');
      return null;
    }
    return tracks[number - 1];
  }

  void _remove() {
    final track = _pick();
    if (track == null) {
      return;
    }
    removeTrack.execute(track.id);
    print('Видалено: $track');
  }

  void _toggle() {
    final track = _pick();
    if (track == null) {
      return;
    }
    final updated = toggleFavorite.execute(track.id);
    print('Оновлено: $updated');
  }

  void _search() {
    final query = _ask('Пошуковий запит:');
    _printTracks(searchTracks.execute(query));
  }
}
