import 'package:dox_query_builder/dox_query_builder.dart';

import '../song/song.model.dart';

part 'artist.model.g.dart';

@DoxModel()
class Artist extends ArtistGenerator {
  @Column()
  String? name;

  @ManyToMany(Song)
  List<Song> songs = [];
}
