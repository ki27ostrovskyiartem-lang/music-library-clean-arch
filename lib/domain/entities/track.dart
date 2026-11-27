import '../errors/domain_exception.dart';

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

  /// Створює трек і перевіряє бізнес-правила.
  factory Track.create({
    required String id,
    required String title,
    required String artist,
    required int durationSeconds,
    bool isFavorite = false,
  }) {
    if (title.trim().isEmpty) {
      throw const DomainException('Назва треку не може бути порожньою');
    }
    if (artist.trim().isEmpty) {
      throw const DomainException('Виконавець не може бути порожнім');
    }
    if (durationSeconds <= 0) {
      throw const DomainException('Тривалість має бути більшою за 0');
    }
    return Track(
      id: id,
      title: title.trim(),
      artist: artist.trim(),
      durationSeconds: durationSeconds,
      isFavorite: isFavorite,
    );
  }

  /// Копія треку зі зміненим станом "улюблений".
  Track copyWith({bool? isFavorite}) {
    return Track(
      id: id,
      title: title,
      artist: artist,
      durationSeconds: durationSeconds,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Тривалість у форматі м:сс.
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = (durationSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Короткий текстовий вигляд треку для виводу в консоль.
  @override
  String toString() {
    final mark = isFavorite ? '[*]' : '[ ]';
    return '$mark $artist - $title ($formattedDuration)';
  }
}
