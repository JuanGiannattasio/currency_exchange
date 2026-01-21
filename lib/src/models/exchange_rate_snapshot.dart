import 'currency.dart';

/// A snapshot of exchange rates at a specific point in time.
///
/// Contains the base currency, timestamp, and conversion rates for all
/// available currencies relative to the base.
class ExchangeRateSnapshot {
  /// The base currency for all rates in this snapshot
  final Currency baseCurrency;

  /// The timestamp when these rates were fetched
  final DateTime timestamp;

  /// Map of currency codes to their exchange rates relative to the base currency
  final Map<Currency, double> rates;

  /// Creates an exchange rate snapshot
  const ExchangeRateSnapshot({
    required this.baseCurrency,
    required this.timestamp,
    required this.rates,
  });

  /// Gets the exchange rate for a specific target currency
  ///
  /// Returns null if the currency is not available in this snapshot.
  double? rateFor(Currency currency) => rates[currency];

  /// Checks if a currency is available in this snapshot
  bool hasCurrency(Currency currency) => rates.containsKey(currency);

  /// Creates a snapshot from JSON API response
  factory ExchangeRateSnapshot.fromJson(
    Map<String, dynamic> json,
    Currency baseCurrency,
  ) {
    final ratesJson = json['rates'] as Map<String, dynamic>;
    final timestamp = DateTime.fromMillisecondsSinceEpoch(
      (json['time_last_update_unix'] as int) * 1000,
    );

    final rates = <Currency, double>{};

    for (final entry in ratesJson.entries) {
      try {
        final currency = Currency.fromCode(entry.key);
        final rate = (entry.value as num).toDouble();
        rates[currency] = rate;
      } catch (_) {
        // Skip unsupported currencies silently
      }
    }

    return ExchangeRateSnapshot(
      baseCurrency: baseCurrency,
      timestamp: timestamp,
      rates: rates,
    );
  }

  @override
  String toString() {
    return 'ExchangeRateSnapshot(base: ${baseCurrency.code}, '
        'timestamp: $timestamp, rates: ${rates.length} currencies)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExchangeRateSnapshot &&
          runtimeType == other.runtimeType &&
          baseCurrency == other.baseCurrency &&
          timestamp == other.timestamp &&
          _mapsEqual(rates, other.rates);

  @override
  int get hashCode =>
      baseCurrency.hashCode ^ timestamp.hashCode ^ rates.length.hashCode;

  bool _mapsEqual(Map<Currency, double> a, Map<Currency, double> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
