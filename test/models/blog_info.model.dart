import 'package:dox_query_builder/dox_query_builder.dart';

import 'blog.model.dart';

part 'blog_info.model.g.dart';

@DoxModel()
class BlogInfo extends BlogInfoGenerator {
  @override
  List get preloadList => [];

  @Column()
  Map<String, dynamic>? info;

  @Column(name: 'blog_id')
  int? blogId;

  @BelongsTo(Blog)
  Blog? blog;
}
