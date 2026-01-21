/// Base exception class for currency exchange errors
abstract class CurrencyExchangeException implements Exception {
  /// Human-readable error message
  final String message;

  const CurrencyExchangeException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a currency code is not supported
class UnsupportedCurrencyException extends CurrencyExchangeException {
  /// The unsupported currency code
  final String currencyCode;

  const UnsupportedCurrencyException(this.currencyCode)
    : super('Unsupported currency code: $currencyCode');
}

/// Thrown when a network request fails
class NetworkException extends CurrencyExchangeException {
  /// The underlying error that caused the network failure
  final Object? cause;

  const NetworkException(super.message, [this.cause]);

  @override
  String toString() => cause != null
      ? '$runtimeType: $message (caused by: $cause)'
      : super.toString();
}

/// Thrown when the API response is invalid or cannot be parsed
class InvalidResponseException extends CurrencyExchangeException {
  /// The underlying error that occurred during parsing
  final Object? cause;

  const InvalidResponseException(super.message, [this.cause]);

  @override
  String toString() => cause != null
      ? '$runtimeType: $message (caused by: $cause)'
      : super.toString();
}
