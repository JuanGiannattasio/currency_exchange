import 'package:flutter/material.dart';
import 'package:currency_exchange/currency_exchange.dart';

void main() {
  runApp(const CurrencyExchangeExampleApp());
}

class CurrencyExchangeExampleApp extends StatelessWidget {
  const CurrencyExchangeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _client = ExchangeRateApiClient();
  late final CachedExchangeRateClient _cachedClient;

  Currency _baseCurrency = Currency.usd;
  Currency _targetCurrency = Currency.eur;
  double _amount = 100.0;

  ExchangeRateSnapshot? _snapshot;
  bool _isLoading = false;
  String? _error;
  bool _useCache = false;

  final _amountController = TextEditingController(text: '100.0');

  @override
  void initState() {
    super.initState();
    _cachedClient = CachedExchangeRateClient(
      client: _client,
      ttl: const Duration(minutes: 5),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cachedClient.close();
    super.dispose();
  }

  Future<void> _fetchRates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final snapshot = _useCache
          ? await _cachedClient.fetchRates(_baseCurrency)
          : await _client.fetchRates(_baseCurrency);

      setState(() {
        _snapshot = snapshot;
        _isLoading = false;
      });
    } on UnsupportedCurrencyException catch (e) {
      setState(() {
        _error = 'Unsupported currency: ${e.currencyCode}';
        _isLoading = false;
      });
    } on NetworkException catch (e) {
      setState(() {
        _error = 'Network error: ${e.message}';
        _isLoading = false;
      });
    } on InvalidResponseException catch (e) {
      setState(() {
        _error = 'Invalid response: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Exchange'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConfigSection(),
            const SizedBox(height: 16),
            _buildFetchButton(),
            if (_error != null) ...[
              const SizedBox(height: 16),
              _buildErrorCard(),
            ],
            if (_snapshot != null) ...[
              const SizedBox(height: 24),
              _buildApiTestsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _CurrencyDropdown(
                    label: 'Base Currency',
                    value: _baseCurrency,
                    onChanged: (c) => setState(() => _baseCurrency = c),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _CurrencyDropdown(
                    label: 'Target Currency',
                    value: _targetCurrency,
                    onChanged: (c) => setState(() => _targetCurrency = c),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null) {
                  setState(() => _amount = parsed);
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Use Cache'),
              subtitle: Text(
                _useCache
                    ? 'Cached: ${_cachedClient.isCached(_baseCurrency)}'
                    : 'Direct API calls',
              ),
              value: _useCache,
              onChanged: (v) => setState(() => _useCache = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFetchButton() {
    return FilledButton.icon(
      onPressed: _isLoading ? null : _fetchRates,
      icon: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.download),
      label: Text(_isLoading ? 'Fetching...' : 'Fetch Exchange Rates'),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiTestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'API Tests',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Rates fetched at: ${_snapshot!.timestamp}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        _buildApiTest1(),
        const SizedBox(height: 16),
        _buildApiTest2(),
        const SizedBox(height: 16),
        _buildApiTest3(),
        const SizedBox(height: 16),
        _buildApiTest4(),
      ],
    );
  }

  Widget _buildApiTest1() {
    final rates = CurrencyConverter.getRates(_snapshot!);
    final displayRates = rates.entries.take(10).toList();

    return _ApiTestCard(
      title: '1. Get All Rates',
      description: 'CurrencyConverter.getRates(snapshot)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Base: ${_baseCurrency.code} → ${rates.length} currencies',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...displayRates.map(
            (e) => Text('${e.key.code}: ${e.value.toStringAsFixed(4)}'),
          ),
          if (rates.length > 10)
            Text(
              '... and ${rates.length - 10} more',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }

  Widget _buildApiTest2() {
    final rate = CurrencyConverter.getRate(_snapshot!, _targetCurrency);

    return _ApiTestCard(
      title: '2. Get Single Rate',
      description:
          'CurrencyConverter.getRate(snapshot, ${_targetCurrency.code})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rate != null) ...[
            Text(
              '1 ${_baseCurrency.code} = ${rate.toStringAsFixed(4)} ${_targetCurrency.code}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ] else
            const Text(
              'Rate not available',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildApiTest3() {
    final result = CurrencyConverter.convertToAll(_snapshot!, _amount);
    final displayConversions = result.conversions.entries.take(10).toList();

    return _ApiTestCard(
      title: '3. Convert to All Currencies',
      description: 'CurrencyConverter.convertToAll(snapshot, $_amount)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_amount ${_baseCurrency.code} equals:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...displayConversions.map(
            (e) => Text('${e.key.code}: ${e.value.toStringAsFixed(2)}'),
          ),
          if (result.conversions.length > 10)
            Text(
              '... and ${result.conversions.length - 10} more',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }

  Widget _buildApiTest4() {
    final result = CurrencyConverter.convert(
      _snapshot!,
      _amount,
      _targetCurrency,
    );

    return _ApiTestCard(
      title: '4. Convert to Specific Currency',
      description:
          'CurrencyConverter.convert(snapshot, $_amount, ${_targetCurrency.code})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result != null) ...[
            Text(
              '${result.amount} ${result.from.code} = ${result.convertedAmount.toStringAsFixed(2)} ${result.to.code}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text('Rate: ${result.rate.toStringAsFixed(4)}'),
            Text('Timestamp: ${result.timestamp}'),
          ] else
            const Text(
              'Conversion not available',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String label;
  final Currency value;
  final ValueChanged<Currency> onChanged;

  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final popularCurrencies = [
      Currency.usd,
      Currency.eur,
      Currency.gbp,
      Currency.jpy,
      Currency.cny,
      Currency.aud,
      Currency.cad,
      Currency.chf,
      Currency.hkd,
      Currency.nzd,
      Currency.inr,
      Currency.brl,
      Currency.mxn,
      Currency.krw,
      Currency.sgd,
    ];

    return DropdownButtonFormField<Currency>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: popularCurrencies.map((c) {
        return DropdownMenuItem(
          value: c,
          child: Text(c.code),
        );
      }).toList(),
      onChanged: (c) {
        if (c != null) onChanged(c);
      },
    );
  }
}

class _ApiTestCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const _ApiTestCard({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
