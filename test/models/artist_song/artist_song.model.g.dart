// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_song.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class ArtistSongGenerator extends Model<ArtistSong> {
  @override
  String get primaryKey => 'id';

  int? get id => tempIdValue;

  set id(val) => tempIdValue = val;

  ArtistSong get newQuery => ArtistSong();

  @override
  List get preloadList => [];

  @override
  Map<String, Function> get relationsResultMatcher => {};

  @override
  Map<String, Function> get relationsQueryMatcher => {};

  @override
  ArtistSong fromMap(Map<String, dynamic> m) => ArtistSong()
    ..id = m['id'] as int?
    ..songId = m['blog_id'] as int?
    ..artistId = m['artist_id'] as int?;

  @override
  Map<String, dynamic> convertToMap(i) {
    ArtistSong instance = i as ArtistSong;
    return {
      'id': instance.id,
      'blog_id': instance.songId,
      'artist_id': instance.artistId,
    };
  }
}
