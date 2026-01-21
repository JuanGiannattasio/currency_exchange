import '../models/currency.dart';
import '../models/exchange_rate_snapshot.dart';

/// Result of a single currency conversion
class ConversionResult {
  /// The original amount
  final double amount;

  /// The source currency
  final Currency from;

  /// The target currency
  final Currency to;

  /// The converted amount
  final double convertedAmount;

  /// The exchange rate used
  final double rate;

  /// The timestamp of the exchange rate
  final DateTime timestamp;

  const ConversionResult({
    required this.amount,
    required this.from,
    required this.to,
    required this.convertedAmount,
    required this.rate,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'ConversionResult($amount ${from.code} = '
        '$convertedAmount ${to.code} @ rate $rate)';
  }
}

/// Result of a multi-currency conversion
class MultiConversionResult {
  /// The original amount
  final double amount;

  /// The source currency
  final Currency from;

  /// Map of target currencies to their converted amounts
  final Map<Currency, double> conversions;

  /// The timestamp of the exchange rates
  final DateTime timestamp;

  const MultiConversionResult({
    required this.amount,
    required this.from,
    required this.conversions,
    required this.timestamp,
  });

  /// Gets the converted amount for a specific currency
  double? getConversion(Currency currency) => conversions[currency];

  @override
  String toString() {
    return 'MultiConversionResult($amount ${from.code} to '
        '${conversions.length} currencies)';
  }
}

/// Utility class for currency conversions using exchange rate snapshots
class CurrencyConverter {
  /// Gets all conversion rates from the base currency
  ///
  /// Returns a map of all available currencies to their exchange rates.
  ///
  /// Example:
  /// ```dart
  /// final rates = CurrencyConverter.getRates(snapshot);
  /// print(rates[Currency.eur]); // 0.85
  /// ```
  static Map<Currency, double> getRates(ExchangeRateSnapshot snapshot) {
    return Map.unmodifiable(snapshot.rates);
  }

  /// Gets a single conversion rate from base currency to target currency
  ///
  /// Returns the exchange rate, or null if the target currency is not available.
  ///
  /// Example:
  /// ```dart
  /// final rate = CurrencyConverter.getRate(snapshot, Currency.eur);
  /// if (rate != null) {
  ///   print('1 USD = $rate EUR');
  /// }
  /// ```
  static double? getRate(
    ExchangeRateSnapshot snapshot,
    Currency targetCurrency,
  ) {
    return snapshot.rateFor(targetCurrency);
  }

  /// Converts an amount from base currency to all available currencies
  ///
  /// Returns a [MultiConversionResult] containing conversions to all currencies.
  ///
  /// Example:
  /// ```dart
  /// final result = CurrencyConverter.convertToAll(snapshot, 100.0);
  /// print(result.conversions[Currency.eur]); // 85.0
  /// ```
  static MultiConversionResult convertToAll(
    ExchangeRateSnapshot snapshot,
    double amount,
  ) {
    final conversions = <Currency, double>{};

    for (final entry in snapshot.rates.entries) {
      conversions[entry.key] = amount * entry.value;
    }

    return MultiConversionResult(
      amount: amount,
      from: snapshot.baseCurrency,
      conversions: conversions,
      timestamp: snapshot.timestamp,
    );
  }

  /// Converts an amount from base currency to a specific target currency
  ///
  /// Returns a [ConversionResult] with the converted amount, or null if the
  /// target currency is not available.
  ///
  /// Example:
  /// ```dart
  /// final result = CurrencyConverter.convert(
  ///   snapshot,
  ///   100.0,
  ///   Currency.eur,
  /// );
  /// if (result != null) {
  ///   print('100 USD = ${result.convertedAmount} EUR');
  /// }
  /// ```
  static ConversionResult? convert(
    ExchangeRateSnapshot snapshot,
    double amount,
    Currency targetCurrency,
  ) {
    final rate = snapshot.rateFor(targetCurrency);
    if (rate == null) return null;

    return ConversionResult(
      amount: amount,
      from: snapshot.baseCurrency,
      to: targetCurrency,
      convertedAmount: amount * rate,
      rate: rate,
      timestamp: snapshot.timestamp,
    );
  }
}
