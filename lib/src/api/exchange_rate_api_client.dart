import 'dart:convert';
import 'package:http/http.dart' as http;

import '../exceptions/currency_exchange_exception.dart';
import '../models/currency.dart';
import '../models/exchange_rate_snapshot.dart';

/// Client for fetching exchange rates from the open.er-api.com API
class ExchangeRateApiClient {
  static const String _baseUrl = 'https://open.er-api.com/v6/latest';

  final http.Client _httpClient;

  /// Creates an API client
  ///
  /// Optionally accepts a custom [httpClient] for testing purposes.
  ExchangeRateApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Fetches the latest exchange rates for the given base currency
  ///
  /// Returns an [ExchangeRateSnapshot] containing all available rates.
  ///
  /// Throws:
  /// - [UnsupportedCurrencyException] if the base currency is not supported
  /// - [NetworkException] if the network request fails
  /// - [InvalidResponseException] if the API response cannot be parsed
  Future<ExchangeRateSnapshot> fetchRates(Currency baseCurrency) async {
    final url = Uri.parse('$_baseUrl/${baseCurrency.code}');

    final http.Response response;

    try {
      response = await _httpClient.get(url);
    } catch (error) {
      throw NetworkException('Failed to fetch exchange rates', error);
    }

    if (response.statusCode == 404) {
      throw UnsupportedCurrencyException(baseCurrency.code);
    }

    if (response.statusCode != 200) {
      throw NetworkException('API returned status code ${response.statusCode}');
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;

      if (json['result'] != 'success') {
        throw InvalidResponseException(
          'API returned error result: ${json['result']}',
        );
      }

      return ExchangeRateSnapshot.fromJson(json, baseCurrency);
    } catch (error) {
      if (error is CurrencyExchangeException) {
        rethrow;
      }
      throw InvalidResponseException('Failed to parse API response', error);
    }
  }

  /// Closes the HTTP client and frees resources
  void close() {
    _httpClient.close();
  }
}
