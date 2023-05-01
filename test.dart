class Person {
  String name;

  Person(this.name);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    print(
        'The method ${invocation.memberName} was called on an instance of Person, but it does not exist.');
    return super.noSuchMethod(invocation);
  }
}
