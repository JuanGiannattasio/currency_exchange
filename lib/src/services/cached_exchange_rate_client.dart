import '../api/exchange_rate_api_client.dart';
import '../models/currency.dart';
import '../models/exchange_rate_snapshot.dart';

/// Optional caching wrapper for the exchange rate API client
///
/// This is an opt-in feature that provides in-memory caching with TTL.
/// The default usage of the library remains stateless.
///
/// Example:
/// ```dart
/// final client = ExchangeRateApiClient();
/// final cachedClient = CachedExchangeRateClient(
///   client: client,
///   ttl: Duration(minutes: 30),
/// );
///
/// // First call fetches from API
/// final snapshot1 = await cachedClient.fetchRates(Currency.usd);
///
/// // Second call within TTL returns cached result
/// final snapshot2 = await cachedClient.fetchRates(Currency.usd);
/// ```
class CachedExchangeRateClient {
  final ExchangeRateApiClient _client;
  final Duration _ttl;
  final Map<Currency, _CacheEntry> _cache = {};

  /// Creates a caching wrapper
  ///
  /// - [client]: The underlying API client to wrap
  /// - [ttl]: Time-to-live for cached entries (default: 1 hour)
  CachedExchangeRateClient({
    required ExchangeRateApiClient client,
    Duration ttl = const Duration(hours: 1),
  }) : _client = client,
       _ttl = ttl;

  /// Fetches exchange rates, using cache if available and not expired
  ///
  /// If a cached snapshot exists for the base currency and is not expired,
  /// returns the cached snapshot. Otherwise, fetches fresh data from the API
  /// and updates the cache.
  Future<ExchangeRateSnapshot> fetchRates(Currency baseCurrency) async {
    final cachedEntry = _cache[baseCurrency];

    if (cachedEntry != null && !cachedEntry.isExpired) {
      return cachedEntry.snapshot;
    }

    final snapshot = await _client.fetchRates(baseCurrency);

    _cache[baseCurrency] = _CacheEntry(
      snapshot: snapshot,
      expiresAt: DateTime.now().add(_ttl),
    );

    return snapshot;
  }

  /// Clears all cached entries
  void clearCache() {
    _cache.clear();
  }

  /// Clears the cached entry for a specific currency
  void clearCacheFor(Currency currency) {
    _cache.remove(currency);
  }

  /// Checks if a cached entry exists for a currency and is not expired
  bool isCached(Currency currency) {
    final entry = _cache[currency];
    return entry != null && !entry.isExpired;
  }

  /// Closes the underlying HTTP client and clears the cache
  void close() {
    _client.close();
    _cache.clear();
  }
}

class _CacheEntry {
  final ExchangeRateSnapshot snapshot;
  final DateTime expiresAt;

  _CacheEntry({required this.snapshot, required this.expiresAt});

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
