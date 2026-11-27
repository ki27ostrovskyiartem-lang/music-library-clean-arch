/// Сутність "Трек" (шар Domain). Не залежить від інших шарів.
class Track {
  final String id;
  final String title;
  final String artist;
  final int durationSeconds;
  final bool isFavorite;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.durationSeconds,
    this.isFavorite = false,
  });
}
