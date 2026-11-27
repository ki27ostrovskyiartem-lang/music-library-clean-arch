import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Use case: додати трек в улюблені або прибрати з улюблених.
class ToggleFavoriteUseCase {
  final TrackRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  Track? execute(String id) {
    final track = _repository.getById(id);
    if (track == null) {
      return null;
    }
    final updated = track.copyWith(isFavorite: !track.isFavorite);
    _repository.update(updated);
    return updated;
  }
}
