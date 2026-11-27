import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Use case: отримати всі треки.
class GetAllTracksUseCase {
  final TrackRepository _repository;

  GetAllTracksUseCase(this._repository);

  List<Track> execute() => _repository.getAll();
}
