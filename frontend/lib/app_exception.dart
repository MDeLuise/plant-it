class AppException implements Exception {
  String cause;
  Exception? innerException;

  AppException(this.cause);

  AppException.withInnerException(this.innerException)
      : cause = innerException?.toString() ?? 'Unknown error';

  @override
  String toString() {
    return cause;
  }
}
