import 'dart:convert';
import 'dart:io';

import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Реалізація сховища у JSON-файлі.
class JsonTrackRepository implements TrackRepository {
  final String _path;
  final List<Track> _items = [];

  JsonTrackRepository(this._path) {
    _load();
  }

  void _load() {
    final file = File(_path);
    if (!file.existsSync()) {
      return;
    }
    final text = file.readAsStringSync();
    if (text.trim().isEmpty) {
      return;
    }
    final data = jsonDecode(text) as List<dynamic>;
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _items.add(
        Track(
          id: map['id'] as String,
          title: map['title'] as String,
          artist: map['artist'] as String,
          durationSeconds: map['durationSeconds'] as int,
          isFavorite: map['isFavorite'] as bool? ?? false,
        ),
      );
    }
  }

  void _save() {
    final data = _items
        .map(
          (t) => {
            'id': t.id,
            'title': t.title,
            'artist': t.artist,
            'durationSeconds': t.durationSeconds,
            'isFavorite': t.isFavorite,
          },
        )
        .toList();
    final file = File(_path);
    // Створюємо каталог для файлу, якщо його ще немає.
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(data));
  }

  @override
  List<Track> getAll() => List<Track>.unmodifiable(_items);

  @override
  Track? getById(String id) {
    for (final t in _items) {
      if (t.id == id) {
        return t;
      }
    }
    return null;
  }

  @override
  void add(Track track) {
    _items.add(track);
    _save();
  }

  @override
  void update(Track track) {
    final index = _items.indexWhere((t) => t.id == track.id);
    if (index != -1) {
      _items[index] = track;
      _save();
    }
  }

  @override
  void remove(String id) {
    _items.removeWhere((t) => t.id == id);
    _save();
  }
}
