import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/solar.dart';
import '../theme.dart';

/// Progressive off-grid solar planner. Designed for households with about
/// \$300/month of climate budget. The screen sequences component purchases
/// and reinforces the licensed-electrician boundary on every page.
class SolarScreen extends StatefulWidget {
  const SolarScreen({super.key});

  @override
  State<SolarScreen> createState() => _SolarScreenState();
}

class _SolarScreenState extends State<SolarScreen> {
  double _monthlyBudget = 300;
  final Set<String> _owned = {};

  @override
  Widget build(BuildContext context) {
    final components = [...SampleData.solarComponents]
      ..sort((a, b) => a.phaseOrder.compareTo(b.phaseOrder));
    final remaining = components.where((c) => !_owned.contains(c.id)).toList();
    final totalRemaining = remaining.fold<double>(0, (a, c) => a + c.estimatedCostUsd);
    final monthsToComplete =
        _monthlyBudget <= 0 ? null : (totalRemaining / _monthlyBudget).ceil();

    return Scaffold(
      backgroundColor: ClimaColors.bg,
      appBar: AppBar(
        title: const Text('Solar planner'),
        backgroundColor: ClimaColors.bg,
        foregroundColor: ClimaColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SafetyBanner(),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ClimaColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your monthly budget', style: ClimaText.title),
                const SizedBox(height: 4),
                Text('\$${_monthlyBudget.toStringAsFixed(0)} / month toward an off-grid system',
                    style: ClimaText.muted),
                Slider(
                  value: _monthlyBudget,
                  min: 50,
                  max: 800,
                  divisions: 15,
                  activeColor: ClimaColors.accent,
                  label: '\$${_monthlyBudget.toStringAsFixed(0)}',
                  onChanged: (v) => setState(() => _monthlyBudget = v),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Remaining cost', style: ClimaText.body),
                    Text('\$${totalRemaining.toStringAsFixed(0)}',
                        style: ClimaText.title.copyWith(fontSize: 16)),
                  ],
                ),
                if (monthsToComplete != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Est. months to complete', style: ClimaText.body),
                      Text('$monthsToComplete months',
                          style: ClimaText.title.copyWith(fontSize: 16)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Purchase order', style: ClimaText.title),
          const SizedBox(height: 8),
          for (final c in components)
            _ComponentTile(
              component: c,
              owned: _owned.contains(c.id),
              onToggle: () => setState(() {
                if (_owned.contains(c.id)) {
                  _owned.remove(c.id);
                } else {
                  _owned.add(c.id);
                }
              }),
            ),
          const SizedBox(height: 24),
          const Text('When to bring in a pro', style: ClimaText.title),
          const SizedBox(height: 8),
          const _ProList(items: [
            'Any connection to the main electrical panel.',
            'Grid-tie / net-metering systems and permits.',
            'Roof penetrations for permanent mounting.',
            '240V circuits (heat pumps, EV chargers, well pumps).',
            'Anything you are unsure about — ask before you energize.',
          ]),
        ],
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ClimaColors.warning.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClimaColors.warning.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(children: [
            Icon(Icons.shield_outlined, color: ClimaColors.warning),
            SizedBox(width: 8),
            Text('Safety first', style: ClimaText.title),
          ]),
          SizedBox(height: 8),
          Text(
            "ClimaShield helps you plan an off-grid (low-voltage DC + standalone inverter) system you can build progressively. We don't provide instructions for grid-tie or main-panel wiring — that work must be done by a licensed electrician with local permits.",
            style: ClimaText.body,
          ),
        ],
      ),
    );
  }
}

class _ComponentTile extends StatelessWidget {
  final SolarComponent component;
  final bool owned;
  final VoidCallback onToggle;
  const _ComponentTile({required this.component, required this.owned, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: owned ? ClimaColors.primary.withOpacity(0.45) : ClimaColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('${component.phaseOrder}',
                  style: const TextStyle(color: ClimaColors.ink, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(component.name, style: ClimaText.title.copyWith(fontSize: 15)),
                  Text('\$${component.estimatedCostUsd.toStringAsFixed(0)}',
                      style: ClimaText.muted),
                ],
              ),
            ),
            IconButton(
              icon: Icon(owned ? Icons.check_circle : Icons.add_circle_outline,
                  color: ClimaColors.accent),
              onPressed: onToggle,
            ),
          ]),
          const SizedBox(height: 8),
          Text(component.purpose, style: ClimaText.body),
          if (component.safetyNotes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('⚠ ${component.safetyNotes}',
                style: ClimaText.muted.copyWith(color: ClimaColors.warning)),
          ],
        ],
      ),
    );
  }
}

class _ProList extends StatelessWidget {
  final List<String> items;
  const _ProList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ClimaColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final i in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.engineering, size: 16, color: ClimaColors.accent),
                const SizedBox(width: 8),
                Expanded(child: Text(i, style: ClimaText.body)),
              ]),
            ),
        ],
      ),
    );
  }
}
