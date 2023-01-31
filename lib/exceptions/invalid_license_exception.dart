class InvalidLicenceException implements Exception {
  final String message;

  const InvalidLicenceException([this.message = 'Invalid Licence']);

  @override
  String toString() => message;
}
