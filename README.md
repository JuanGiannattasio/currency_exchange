# currency_exchange

A Dart library for currency exchange and conversion using real-time exchange rates. Supports 150+ fiat currencies with a clean, stateless API.

## Features

- 🌍 Fetch live exchange rates for 150+ fiat currencies (ISO-4217)
- 💱 Convert amounts between currencies
- 📸 Store exchange rate snapshots with timestamps
- 🔄 Optional in-memory caching with TTL
- 🚀 Stateless by default
- 🎯 Type-safe currency enum
- ⚡ Simple, predictable API

## What it does NOT do

- ❌ Does NOT support cryptocurrencies
- ❌ Does NOT persist data (stateless by default)
- ❌ Does NOT auto-refresh rates
- ❌ Does NOT provide historical data

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  currency_exchange: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### 1. Get all conversion rates from a base currency

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();

  try {
    // Fetch rates for USD
    final snapshot = await client.fetchRates(Currency.usd);

    // Get all rates
    final rates = CurrencyConverter.getRates(snapshot);

    print('1 USD = ${rates[Currency.eur]} EUR');
    print('1 USD = ${rates[Currency.gbp]} GBP');
    print('1 USD = ${rates[Currency.jpy]} JPY');
  } catch (e) {
    print('Error: $e');
  } finally {
    client.close();
  }
}
```

### 2. Get a single conversion rate

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();

  try {
    final snapshot = await client.fetchRates(Currency.usd);

    // Get single rate (USD to EUR)
    final rate = CurrencyConverter.getRate(snapshot, Currency.eur);

    if (rate != null) {
      print('1 USD = $rate EUR');
    } else {
      print('EUR not available');
    }
  } finally {
    client.close();
  }
}
```

### 3. Convert an amount to all currencies

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();

  try {
    final snapshot = await client.fetchRates(Currency.usd);

    // Convert 100 USD to all currencies
    final result = CurrencyConverter.convertToAll(snapshot, 100.0);

    print('100 USD equals:');
    print('  ${result.conversions[Currency.eur]} EUR');
    print('  ${result.conversions[Currency.gbp]} GBP');
    print('  ${result.conversions[Currency.jpy]} JPY');
    print('Fetched at: ${result.timestamp}');
  } finally {
    client.close();
  }
}
```

### 4. Convert an amount to a specific currency

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();

  try {
    final snapshot = await client.fetchRates(Currency.usd);

    // Convert 100 USD to EUR
    final result = CurrencyConverter.convert(
      snapshot,
      100.0,
      Currency.eur,
    );

    if (result != null) {
      print('${result.amount} ${result.from.code} = '
            '${result.convertedAmount} ${result.to.code}');
      print('Rate: ${result.rate}');
      print('Timestamp: ${result.timestamp}');
    } else {
      print('Conversion not available');
    }
  } finally {
    client.close();
  }
}
```

### Optional: Using cache

For applications that need to reduce API calls, use the optional caching wrapper:

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();
  final cachedClient = CachedExchangeRateClient(
    client: client,
    ttl: Duration(minutes: 30),
  );

  try {
    // First call fetches from API
    final snapshot1 = await cachedClient.fetchRates(Currency.usd);
    print('Fetched from API');

    // Second call within TTL returns cached result
    final snapshot2 = await cachedClient.fetchRates(Currency.usd);
    print('Fetched from cache');

    // Check if cached
    print('Is cached: ${cachedClient.isCached(Currency.usd)}');

    // Clear cache if needed
    cachedClient.clearCache();
  } finally {
    cachedClient.close();
  }
}
```

## Error Handling

The library provides clear exception types:

```dart
import 'package:currency_exchange/currency_exchange.dart';

void main() async {
  final client = ExchangeRateApiClient();

  try {
    final snapshot = await client.fetchRates(Currency.usd);
    // Use snapshot...
  } on UnsupportedCurrencyException catch (e) {
    print('Currency not supported: ${e.currencyCode}');
  } on NetworkException catch (e) {
    print('Network error: ${e.message}');
  } on InvalidResponseException catch (e) {
    print('Invalid API response: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  } finally {
    client.close();
  }
}
```

## Supported Currencies

The library supports all major fiat currencies including:

- USD, EUR, GBP, JPY, CNY
- AUD, CAD, CHF, HKD, NZD
- And 140+ more ISO-4217 currencies

See [Currency enum](lib/src/models/currency.dart) for the complete list.

## API Source

Exchange rates are provided by [open.er-api.com](https://open.er-api.com/), a free public API for currency exchange rates.

## License

This package is open source. See the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
