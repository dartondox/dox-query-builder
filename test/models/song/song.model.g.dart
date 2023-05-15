// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class SongGenerator extends Model<Song> {
  @override
  String get primaryKey => 'id';

  int? get id => tempIdValue;

  set id(val) => tempIdValue = val;

  Song get newQuery => Song();

  @override
  List get preloadList => [];

  @override
  Map<String, Function> get relationsResultMatcher => {
        'artists': getArtists,
      };

  @override
  Map<String, Function> get relationsQueryMatcher => {
        'artists': queryArtists,
      };

  static Future getArtists(List list) async {
    var result = await getManyToMany<Artist>(queryArtists(list), list);
    for (Song i in list) {
      i.artists = result[i.tempIdValue.toString()];
      if (list.length == 1) {
        return i.artists;
      }
    }
  }

  static Artist? queryArtists(List list) {
    return manyToMany<Artist>(list, () => Artist());
  }

  @override
  Song fromMap(Map<String, dynamic> m) => Song()
    ..id = m['id'] as int?
    ..title = m['title'] as String?;

  @override
  Map<String, dynamic> convertToMap(i) {
    Song instance = i as Song;
    return {
      'id': instance.id,
      'title': instance.title,
    };
  }
}
