class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  const AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super("", "Error During Communication,check your internet access");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}

class TimeoutException extends AppException {
  TimeoutException([message]) : super(message, "");
}
