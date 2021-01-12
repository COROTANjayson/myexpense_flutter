class HttpExceptionModel implements Exception {
  final String message;

  HttpExceptionModel(this.message);

  @override
  String toString() {
    return message;
  }
}
