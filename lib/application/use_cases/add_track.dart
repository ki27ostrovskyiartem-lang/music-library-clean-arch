import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Use case: додати новий трек.
/// Працює тільки з інтерфейсом TrackRepository (принцип інверсії залежностей).
class AddTrackUseCase {
  final TrackRepository _repository;

  /// Лічильник потрібен, бо час може збігатися у треків, доданих поспіль.
  static int _sequence = 0;

  AddTrackUseCase(this._repository);

  Track execute({
    required String title,
    required String artist,
    required int durationSeconds,
  }) {
    final id = '${DateTime.now().microsecondsSinceEpoch}-${_sequence++}';
    final track = Track.create(
      id: id,
      title: title,
      artist: artist,
      durationSeconds: durationSeconds,
    );
    _repository.add(track);
    return track;
  }
}
