T hasOne<T>(T Function() model) {
  return model();
}

class BlogInfo {}

class Blog {
  BlogInfo? get blogInfo => hasOne(() => BlogInfo());
}
