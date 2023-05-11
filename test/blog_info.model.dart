import 'package:dox_query_builder/dox_query_builder.dart';

part 'blog_info.model.g.dart';

@DoxModel()
class BlogInfo extends BlogInfoGenerator {
  @Column()
  String? category;
}
