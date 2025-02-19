abstract class BaseModel {
  String? get id;

  Map<String, dynamic> toMap();

  // Optional but useful for debugging
  @override
  String toString() {
    return runtimeType.toString();
  }
}
