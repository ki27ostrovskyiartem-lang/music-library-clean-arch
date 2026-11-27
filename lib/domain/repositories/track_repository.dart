import '../entities/track.dart';

/// Абстракція сховища треків (інтерфейс).
/// Оголошена в Domain, а реалізації лежать в Infrastructure.
abstract class TrackRepository {
  List<Track> getAll();
  Track? getById(String id);
  void add(Track track);
  void update(Track track);
  void remove(String id);
}
