import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';

/// Use case: пошук треків за назвою або виконавцем.
class SearchTracksUseCase {
  final TrackRepository _repository;

  SearchTracksUseCase(this._repository);

  List<Track> execute(String query) {
    final text = query.trim();
    return _repository
        .getAll()
        .where((t) => t.title.contains(text) || t.artist.contains(text))
        .toList();
  }
}
