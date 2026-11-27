import '../../domain/repositories/track_repository.dart';

/// Use case: видалити трек за id. Повертає true, якщо трек існував.
class RemoveTrackUseCase {
  final TrackRepository _repository;

  RemoveTrackUseCase(this._repository);

  bool execute(String id) {
    if (_repository.getById(id) == null) {
      return false;
    }
    _repository.remove(id);
    return true;
  }
}
