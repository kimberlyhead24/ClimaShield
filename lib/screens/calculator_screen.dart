import 'package:flutter/material.dart';

import '../data/carbon_math.dart';
import '../data/repository.dart';
import '../models/footprint.dart';
import '../theme.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _miles = TextEditingController(text: '120');
  final _mpg = TextEditingController(text: '28');
  final _shortFlights = TextEditingController(text: '1');
  final _longFlights = TextEditingController(text: '0');
  final _kwh = TextEditingController(text: '600');
  final _therms = TextEditingController(text: '20');
  final _household = TextEditingController(text: '2');
  final _shopping = TextEditingController(text: '300');
  String _dietType = 'average';

  CarbonFootprint? _result;

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    final saved = await ClimaRepository.instance.loadInputs();
    if (saved == null || !mounted) return;
    setState(() {
      _miles.text = saved.carMilesPerWeek.toStringAsFixed(0);
      _mpg.text = saved.carMpg.toStringAsFixed(0);
      _shortFlights.text = saved.flightsShortHaulPerYear.toStringAsFixed(0);
      _longFlights.text = saved.flightsLongHaulPerYear.toStringAsFixed(0);
      _kwh.text = saved.electricityKwhPerMonth.toStringAsFixed(0);
      _therms.text = saved.naturalGasThermsPerMonth.toStringAsFixed(0);
      _household.text = saved.householdSize.toString();
      _shopping.text = saved.monthlyShoppingUsd.toStringAsFixed(0);
      _dietType = saved.dietType;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _miles,
      _mpg,
      _shortFlights,
      _longFlights,
      _kwh,
      _therms,
      _household,
      _shopping
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c, {double fallback = 0}) =>
      double.tryParse(c.text.trim()) ?? fallback;

  Future<void> _calculate() async {
    final inputs = CarbonCalculatorInputs(
      carMilesPerWeek: _num(_miles),
      carMpg: _num(_mpg, fallback: 28),
      flightsShortHaulPerYear: _num(_shortFlights),
      flightsLongHaulPerYear: _num(_longFlights),
      electricityKwhPerMonth: _num(_kwh),
      naturalGasThermsPerMonth: _num(_therms),
      dietType: _dietType,
      householdSize: int.tryParse(_household.text.trim()) ?? 1,
      monthlyShoppingUsd: _num(_shopping),
    );
    final fp = computeFootprint(inputs);
    setState(() => _result = fp);
    await ClimaRepository.instance.saveCalculation(inputs, fp);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved your footprint.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClimaColors.bg,
      appBar: AppBar(
        title: const Text('Carbon calculator'),
        backgroundColor: ClimaColors.bg,
        foregroundColor: ClimaColors.ink,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Transport', style: ClimaText.title),
            const SizedBox(height: 8),
            _numField(_miles, 'Car miles per week'),
            const SizedBox(height: 8),
            _numField(_mpg, 'Car MPG'),
            const SizedBox(height: 8),
            _numField(_shortFlights, 'Short-haul flights / year'),
            const SizedBox(height: 8),
            _numField(_longFlights, 'Long-haul flights / year'),
            const SizedBox(height: 20),
            const Text('Home energy', style: ClimaText.title),
            const SizedBox(height: 8),
            _numField(_kwh, 'Electricity kWh / month'),
            const SizedBox(height: 8),
            _numField(_therms, 'Natural gas therms / month'),
            const SizedBox(height: 8),
            _numField(_household, 'Household size'),
            const SizedBox(height: 20),
            const Text('Diet', style: ClimaText.title),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _dietType,
              decoration: climaInputDecoration('Diet pattern'),
              items: const [
                DropdownMenuItem(value: 'meat_heavy', child: Text('Meat-heavy')),
                DropdownMenuItem(value: 'average', child: Text('Average')),
                DropdownMenuItem(value: 'low_meat', child: Text('Low meat')),
                DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
              ],
              onChanged: (v) => setState(() => _dietType = v ?? 'average'),
            ),
            const SizedBox(height: 20),
            const Text('Goods', style: ClimaText.title),
            const SizedBox(height: 8),
            _numField(_shopping, 'Monthly non-food shopping (\$)'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _calculate,
              style: climaPrimaryButtonStyle(),
              child: const Text('Calculate footprint'),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              _ResultCard(footprint: _result!),
            ],
            const SizedBox(height: 32),
            const Text(
              'Estimates use coarse EPA/IPCC averages. Useful for direction, not formal reporting.',
              style: ClimaText.muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _numField(TextEditingController c, String label) => TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: climaInputDecoration(label),
      );
}

class _ResultCard extends StatelessWidget {
  final CarbonFootprint footprint;
  const _ResultCard({required this.footprint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ClimaColors.primary.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${footprint.totalTonnes.toStringAsFixed(1)} t CO₂e / year',
              style: ClimaText.headline),
          const SizedBox(height: 8),
          _bar('Transport', footprint.transportKg, footprint.totalKg),
          _bar('Home energy', footprint.homeEnergyKg, footprint.totalKg),
          _bar('Diet', footprint.dietKg, footprint.totalKg),
          _bar('Goods', footprint.goodsKg, footprint.totalKg),
        ],
      ),
    );
  }

  Widget _bar(String label, double kg, double total) {
    final pct = total == 0 ? 0.0 : (kg / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(label, style: ClimaText.body),
            Text('${kg.toStringAsFixed(0)} kg', style: ClimaText.muted),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.4),
              valueColor: const AlwaysStoppedAnimation(ClimaColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
