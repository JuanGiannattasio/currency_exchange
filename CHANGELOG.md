## 0.1.0

- Initial release
- Support for 150+ fiat currencies (ISO-4217)
- Fetch live exchange rates from open.er-api.com
- Type-safe Currency enum
- ExchangeRateSnapshot model with timestamp
- CurrencyConverter utilities:
  - Get all rates from base currency
  - Get single rate for target currency
  - Convert amount to all currencies
  - Convert amount to specific currency
- Optional in-memory caching with TTL
- Comprehensive error handling:
  - UnsupportedCurrencyException
  - NetworkException
  - InvalidResponseException
- Full DartDoc documentation
