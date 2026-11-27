import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Use case: пошук треків за назвою або виконавцем (без урахування регістру).
class SearchTracksUseCase {
  final TrackRepository _repository;

  SearchTracksUseCase(this._repository);

  List<Track> execute(String query) {
    final text = query.trim().toLowerCase();
    return _repository
        .getAll()
        .where(
          (t) =>
              t.title.toLowerCase().contains(text) ||
              t.artist.toLowerCase().contains(text),
        )
        .toList();
  }
}
