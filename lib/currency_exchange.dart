/// A Dart library for currency exchange and conversion using real-time rates.
///
/// This library provides utilities to:
/// - Fetch live exchange rates for 150+ fiat currencies (ISO-4217)
/// - Convert amounts between currencies
/// - Store exchange rate snapshots with timestamps
///
/// ## What it does:
/// - Fetches exchange rates from a public API (open.er-api.com)
/// - Supports all major fiat currencies
/// - Provides stateless conversion utilities
/// - Optional in-memory caching with TTL
///
/// ## What it does NOT do:
/// - Does NOT support cryptocurrencies
/// - Does NOT persist data (stateless by default)
/// - Does NOT auto-refresh rates
/// - Does NOT provide historical data
///
/// ## Usage
///
/// Basic usage (stateless):
/// ```dart
/// import 'package:currency_exchange/currency_exchange.dart';
///
/// final client = ExchangeRateApiClient();
///
/// // Fetch rates
/// final snapshot = await client.fetchRates(Currency.usd);
///
/// // Get all rates
/// final rates = CurrencyConverter.getRates(snapshot);
///
/// // Get single rate
/// final eurRate = CurrencyConverter.getRate(snapshot, Currency.eur);
///
/// // Convert amount to all currencies
/// final allConversions = CurrencyConverter.convertToAll(snapshot, 100.0);
///
/// // Convert amount to specific currency
/// final conversion = CurrencyConverter.convert(snapshot, 100.0, Currency.eur);
///
/// client.close();
/// ```
///
/// With optional caching:
/// ```dart
/// final client = ExchangeRateApiClient();
/// final cachedClient = CachedExchangeRateClient(
///   client: client,
///   ttl: Duration(minutes: 30),
/// );
///
/// final snapshot = await cachedClient.fetchRates(Currency.usd);
///
/// cachedClient.close();
/// ```
library;

// Models
export 'src/models/currency.dart';
export 'src/models/exchange_rate_snapshot.dart';

// API Client
export 'src/api/exchange_rate_api_client.dart';

// Services
export 'src/services/currency_converter.dart';
export 'src/services/cached_exchange_rate_client.dart';

// Exceptions
export 'src/exceptions/currency_exchange_exception.dart';
