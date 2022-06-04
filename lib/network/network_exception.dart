class NetworkException implements Exception {
  final String message;
  final String prefix;
  final int responseCode;

  NetworkException(
      {required this.message,
      required this.prefix,
      required this.responseCode});

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends NetworkException {
  FetchDataException(String message, [code = 500])
      : super(
            message: message,
            prefix: "Error During Communication: ",
            responseCode: code);
}

class BadRequestException extends NetworkException {
  BadRequestException(String message, [code = 400])
      : super(
            message: message, prefix: "Invalid Request: ", responseCode: code);
}

class UnauthorisedException extends NetworkException {
  UnauthorisedException(String message, [code = 403])
      : super(message: message, prefix: "Unauthorised: ", responseCode: code);
}

class InvalidInputException extends NetworkException {
  InvalidInputException(String message, [code = 500])
      : super(message: message, prefix: "Invalid Input: ", responseCode: code);
}
