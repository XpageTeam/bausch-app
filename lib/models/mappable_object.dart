abstract class MappableInterface<T> {
  @override
  String toString() => toMap().toString();

  // static T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}
