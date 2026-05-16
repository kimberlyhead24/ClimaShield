import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/footprint.dart';
import '../theme.dart';
import 'actions_screen.dart';
import 'calculator_screen.dart';
import 'diet_screen.dart';
import 'petitions_screen.dart';
import 'solar_screen.dart';

/// Landing screen: surplus state + quick-jump cards.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CarbonFootprint? _footprint;
  double _saved = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final fp = await ClimaRepository.instance.loadFootprint();
    final saved = await ClimaRepository.instance.totalCo2eSavedKg();
    if (!mounted) return;
    setState(() {
      _footprint = fp;
      _saved = saved;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('ClimaShield', style: ClimaText.headline),
          const SizedBox(height: 4),
          const Text('Build your climate surplus.', style: ClimaText.muted),
          const SizedBox(height: 20),
          _SurplusCard(footprint: _footprint, savedKg: _saved, loading: _loading),
          const SizedBox(height: 20),
          const Text('Get started', style: ClimaText.title),
          const SizedBox(height: 12),
          _QuickGrid(items: [
            _Quick(
              icon: Icons.calculate_outlined,
              title: 'Carbon calculator',
              subtitle: 'Estimate your annual footprint',
              onTap: () => _open(context, const CalculatorScreen()),
            ),
            _Quick(
              icon: Icons.eco_outlined,
              title: 'Take an action',
              subtitle: 'High-impact, low-friction',
              onTap: () => _open(context, const ActionsScreen()),
            ),
            _Quick(
              icon: Icons.restaurant_outlined,
              title: 'Log a meal',
              subtitle: 'Climate-friendly diet',
              onTap: () => _open(context, const DietScreen()),
            ),
            _Quick(
              icon: Icons.solar_power_outlined,
              title: 'Solar planner',
              subtitle: 'Off-grid, step by step',
              onTap: () => _open(context, const SolarScreen()),
            ),
            _Quick(
              icon: Icons.campaign_outlined,
              title: 'Sign a petition',
              subtitle: 'Local advocacy',
              onTap: () => _open(context, const PetitionsScreen()),
            ),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) => _load());
  }
}

class _SurplusCard extends StatelessWidget {
  final CarbonFootprint? footprint;
  final double savedKg;
  final bool loading;

  const _SurplusCard({
    required this.footprint,
    required this.savedKg,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final fpKg = footprint?.totalKg ?? 0;
    final net = fpKg - savedKg;
    final isSurplus = net < 0 && fpKg > 0;

    final Color tone = loading
        ? ClimaColors.surface
        : (fpKg == 0
            ? ClimaColors.surface
            : (isSurplus ? ClimaColors.primary : ClimaColors.surface));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tone,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSurplus ? 'You are in climate surplus' : 'Your climate balance',
            style: ClimaText.title,
          ),
          const SizedBox(height: 12),
          if (loading)
            const LinearProgressIndicator(minHeight: 3)
          else if (fpKg == 0)
            const Text(
              "Run the carbon calculator to see your starting footprint.",
              style: ClimaText.body,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Annual footprint', '${fpKg.toStringAsFixed(0)} kg CO₂e'),
                _row('Saved by your actions',
                    '${savedKg.toStringAsFixed(0)} kg CO₂e/yr'),
                const Divider(height: 20),
                _row(
                  isSurplus ? 'Surplus' : 'Remaining to neutral',
                  '${net.abs().toStringAsFixed(0)} kg CO₂e/yr',
                  bold: true,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _row(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l, style: ClimaText.body),
            Text(r,
                style: bold
                    ? ClimaText.title.copyWith(fontSize: 16)
                    : ClimaText.body),
          ],
        ),
      );
}

class _QuickGrid extends StatelessWidget {
  final List<_Quick> items;
  const _QuickGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final cols = c.maxWidth > 540 ? 3 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: cols,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: items,
        );
      },
    );
  }
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _Quick({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ClimaColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ClimaColors.accent, size: 28),
            const Spacer(),
            Text(title, style: ClimaText.title.copyWith(fontSize: 15)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: ClimaText.muted,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
