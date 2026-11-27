import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Реалізація сховища в оперативній пам'яті.
class InMemoryTrackRepository implements TrackRepository {
  final Map<String, Track> _items = {};

  @override
  List<Track> getAll() => List<Track>.unmodifiable(_items.values);

  @override
  Track? getById(String id) => _items[id];

  @override
  void add(Track track) {
    _items[track.id] = track;
  }

  @override
  void update(Track track) {
    if (_items.containsKey(track.id)) {
      _items[track.id] = track;
    }
  }

  @override
  void remove(String id) {
    _items.remove(id);
  }
}
