import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../data/sample_data.dart';
import '../models/diet_entry.dart';
import '../theme.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  List<DietLogEntry> _today = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ClimaRepository.instance.dietLog(days: 1);
    if (!mounted) return;
    setState(() {
      _today = list;
      _loading = false;
    });
  }

  Future<void> _log(MealPreset m) async {
    await ClimaRepository.instance.logMeal(m);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged ${m.name} (${m.co2eKgPerServing} kg CO₂e)')),
    );
  }

  Color _tierColor(String tier) {
    switch (tier) {
      case 'best':
        return ClimaColors.accent;
      case 'good':
        return ClimaColors.primary;
      case 'fair':
        return ClimaColors.warning;
      case 'high':
        return ClimaColors.danger;
      default:
        return ClimaColors.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyKg = _today.fold<double>(0, (a, e) => a + e.co2eKg);
    final byTier = <String, List<MealPreset>>{};
    for (final m in SampleData.meals) {
      byTier.putIfAbsent(m.tier, () => []).add(m);
    }
    const tierOrder = ['best', 'good', 'fair', 'high'];

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Climate diet', style: ClimaText.headline),
          const SizedBox(height: 4),
          const Text('Plant-forward meals make the biggest dent.',
              style: ClimaText.muted),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ClimaColors.primary.withOpacity(0.45),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Today's food footprint", style: ClimaText.title),
                const SizedBox(height: 6),
                if (_loading)
                  const LinearProgressIndicator(minHeight: 3)
                else
                  Text('${dailyKg.toStringAsFixed(1)} kg CO₂e',
                      style: ClimaText.headline),
                const SizedBox(height: 4),
                Text(
                  _today.isEmpty
                      ? 'No meals logged yet today.'
                      : '${_today.length} meals logged',
                  style: ClimaText.muted,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Log a meal', style: ClimaText.title),
          const SizedBox(height: 8),
          for (final tier in tierOrder) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _tierColor(tier),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(_tierLabel(tier), style: ClimaText.title.copyWith(fontSize: 14)),
              ]),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in byTier[tier] ?? const <MealPreset>[])
                  ActionChip(
                    avatar: Text(m.emoji),
                    label: Text('${m.name} • ${m.co2eKgPerServing} kg'),
                    backgroundColor: ClimaColors.surface,
                    onPressed: () => _log(m),
                  ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          const SizedBox(height: 24),
          if (_today.isNotEmpty) ...[
            const Text("Today's log", style: ClimaText.title),
            const SizedBox(height: 8),
            for (final e in _today)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restaurant, color: ClimaColors.accent),
                title: Text(e.name),
                trailing: Text('${e.co2eKg.toStringAsFixed(1)} kg'),
              ),
          ],
        ],
      ),
    );
  }

  String _tierLabel(String t) {
    switch (t) {
      case 'best':
        return 'Best (plant-based)';
      case 'good':
        return 'Good';
      case 'fair':
        return 'Fair (some animal protein)';
      case 'high':
        return 'High impact (red meat)';
      default:
        return t;
    }
  }
}
