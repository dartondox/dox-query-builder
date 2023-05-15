// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.model.dart';

// **************************************************************************
// Generator: DoxModelBuilder
// **************************************************************************

class ArtistGenerator extends Model<Artist> {
  @override
  String get primaryKey => 'id';

  int? get id => tempIdValue;

  set id(val) => tempIdValue = val;

  Artist get newQuery => Artist();

  @override
  List get preloadList => [];

  @override
  Map<String, Function> get relationsResultMatcher => {
        'songs': getSongs,
      };

  @override
  Map<String, Function> get relationsQueryMatcher => {
        'songs': querySongs,
      };

  static Future getSongs(List list) async {
    var result = await getManyToMany<Song>(querySongs(list), list);
    for (Artist i in list) {
      i.songs = result[i.tempIdValue.toString()];
      if (list.length == 1) {
        return i.songs;
      }
    }
  }

  static Song? querySongs(List list) {
    return manyToMany<Song>(list, () => Song());
  }

  @override
  Artist fromMap(Map<String, dynamic> m) => Artist()
    ..id = m['id'] as int?
    ..name = m['name'] as String?;

  @override
  Map<String, dynamic> convertToMap(i) {
    Artist instance = i as Artist;
    return {
      'id': instance.id,
      'name': instance.name,
    };
  }
}
