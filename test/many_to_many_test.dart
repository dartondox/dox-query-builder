import 'package:dox_query_builder/dox_query_builder.dart';
import 'package:test/test.dart';

import 'connection.dart';
import 'models/artist/artist.model.dart';
import 'models/artist_song/artist_song.model.dart';
import 'models/song/song.model.dart';

void main() async {
  SqlQueryBuilder.initialize(database: await connection(), debug: false);

  group('Model', () {
    setUp(() {
      Schema.drop('artist');
      Schema.drop('song');
      Schema.drop('artist_song');
      Schema.create('artist', (Table table) {
        table.id();
        table.string('name');
        table.timestamps();
      });

      Schema.create('song', (Table table) {
        table.id();
        table.string('title');
        table.timestamps();
      });

      Schema.create('artist_song', (Table table) {
        table.id('id');
        table.integer('song_id');
        table.integer('artist_id');
        table.timestamps();
      });
    });

    test('Many to Many', () async {
      await Artist().insertMultiple([
        {'name': "Arijit Singh"},
        {'name': "Naw Naw"},
        {'name': "Lay Phy"},
      ]);

      await Song().insertMultiple([
        {'title': "Tum hi ho"},
        {'title': "Di Lo Nya Tine"},
        {'title': "Aein Mat"},
      ]);

      await ArtistSong().insertMultiple([
        {'song_id': '1', 'artist_id': '1'},
        {'song_id': '2', 'artist_id': '1'},
        {'song_id': '2', 'artist_id': '2'},
        {'song_id': '3', 'artist_id': '2'},
        {'song_id': '2', 'artist_id': '3'},
        {'song_id': '1', 'artist_id': '3'},
      ]);

      Artist artist = await Artist().preload('songs').find(1);

      expect(artist.songs.length, 2);
      expect(artist.songs.map((e) => e.id).toList(), [1, 2]);

      Song song = await Song().preload('artists').find(2);

      expect(song.artists.length, 3);
      expect(song.artists.map((e) => e.id).toList(), [1, 2, 3]);
    });
  });
}
