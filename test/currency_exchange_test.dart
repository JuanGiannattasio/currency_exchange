import 'package:currency_exchange/currency_exchange.dart';
import 'package:test/test.dart';

void main() {
  group('Currency', () {
    test('fromCode creates correct currency', () {
      expect(Currency.fromCode('USD'), equals(Currency.usd));
      expect(Currency.fromCode('usd'), equals(Currency.usd));
      expect(Currency.fromCode('EUR'), equals(Currency.eur));
    });

    test('fromCode handles TRY special case', () {
      expect(Currency.fromCode('TRY'), equals(Currency.try_));
      expect(Currency.fromCode('try'), equals(Currency.try_));
    });

    test('fromCode throws on invalid currency', () {
      expect(
        () => Currency.fromCode('INVALID'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('code returns uppercase currency code', () {
      expect(Currency.usd.code, equals('USD'));
      expect(Currency.eur.code, equals('EUR'));
      expect(Currency.try_.code, equals('TRY'));
    });
  });

  group('ExchangeRateSnapshot', () {
    test('fromJson parses API response correctly', () {
      final json = {
        'time_last_update_unix': 1609459200,
        'rates': {
          'USD': 1.0,
          'EUR': 0.85,
          'GBP': 0.75,
        },
      };

      final snapshot = ExchangeRateSnapshot.fromJson(json, Currency.usd);

      expect(snapshot.baseCurrency, equals(Currency.usd));
      expect(snapshot.rates[Currency.usd], equals(1.0));
      expect(snapshot.rates[Currency.eur], equals(0.85));
      expect(snapshot.rates[Currency.gbp], equals(0.75));
    });

    test('rateFor returns correct rate', () {
      final snapshot = ExchangeRateSnapshot(
        baseCurrency: Currency.usd,
        timestamp: DateTime.now(),
        rates: {
          Currency.eur: 0.85,
          Currency.gbp: 0.75,
        },
      );

      expect(snapshot.rateFor(Currency.eur), equals(0.85));
      expect(snapshot.rateFor(Currency.gbp), equals(0.75));
      expect(snapshot.rateFor(Currency.jpy), isNull);
    });
  });

  group('CurrencyConverter', () {
    late ExchangeRateSnapshot snapshot;

    setUp(() {
      snapshot = ExchangeRateSnapshot(
        baseCurrency: Currency.usd,
        timestamp: DateTime.now(),
        rates: {
          Currency.usd: 1.0,
          Currency.eur: 0.85,
          Currency.gbp: 0.75,
        },
      );
    });

    test('getRates returns all rates', () {
      final rates = CurrencyConverter.getRates(snapshot);
      expect(rates[Currency.usd], equals(1.0));
      expect(rates[Currency.eur], equals(0.85));
      expect(rates[Currency.gbp], equals(0.75));
    });

    test('getRate returns single rate', () {
      final rate = CurrencyConverter.getRate(snapshot, Currency.eur);
      expect(rate, equals(0.85));
    });

    test('convertToAll converts to all currencies', () {
      final result = CurrencyConverter.convertToAll(snapshot, 100.0);
      expect(result.amount, equals(100.0));
      expect(result.from, equals(Currency.usd));
      expect(result.conversions[Currency.usd], equals(100.0));
      expect(result.conversions[Currency.eur], equals(85.0));
      expect(result.conversions[Currency.gbp], equals(75.0));
    });

    test('convert converts to specific currency', () {
      final result = CurrencyConverter.convert(snapshot, 100.0, Currency.eur);
      expect(result, isNotNull);
      expect(result!.amount, equals(100.0));
      expect(result.from, equals(Currency.usd));
      expect(result.to, equals(Currency.eur));
      expect(result.convertedAmount, equals(85.0));
      expect(result.rate, equals(0.85));
    });

    test('convert returns null for unavailable currency', () {
      final result = CurrencyConverter.convert(snapshot, 100.0, Currency.jpy);
      expect(result, isNull);
    });
  });
}
