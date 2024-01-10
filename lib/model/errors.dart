abstract class InfobipRTCError implements Exception {
  final String? message;

  const InfobipRTCError({this.message});
}

class NoTokenError extends InfobipRTCError {
  const NoTokenError();
}

class TokenRegistrationError extends InfobipRTCError {
  const TokenRegistrationError({required super.message});
}

class NoDestinationError extends InfobipRTCError {
  const NoDestinationError();
}
