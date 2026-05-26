import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/footprint.dart';
import 'actions_screen.dart';
import 'calculator_screen.dart';
import 'diet_screen.dart';
import 'petitions_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CarbonFootprint? _footprint;
  double _saved = 0;
  // CHANGE: added category savings map
  Map<String, double> _savedByCategory = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // CHANGE: now also loads co2eSavedByCategory
  Future<void> _load() async {
    final results = await Future.wait([
      ClimaRepository.instance.loadFootprint(),
      ClimaRepository.instance.totalCo2eSavedKg(),
      ClimaRepository.instance.co2eSavedByCategory(),
    ]);
    if (!mounted) return;
    setState(() {
      _footprint = results[0] as CarbonFootprint?;
      _saved = results[1] as double;
      _savedByCategory = results[2] as Map<String, double>;
      _loading = false;
    });
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) => _load());
  }

  // CHANGE: helper that builds a human-readable subtitle from real category kg
  String _impactSubtitle(String categoryKey, String fallback) {
    final kg = _savedByCategory[categoryKey] ?? 0;
    if (kg == 0) return fallback;
    return '${kg.toStringAsFixed(0)} kg CO₂e saved through your actions';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111614),
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────────
            const SliverAppBar(
              backgroundColor: Color(0xFF111614),
              pinned: true,
              centerTitle: true,
              title: Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [],
            ),

            // ── Content ──────────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // Hero image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/earth_hero.png',
                      width: double.infinity,
                      height: 201,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        height: 201,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2D27),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.public,
                              size: 64, color: Color(0xFF4CAF50)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Surplus status card ──────────────────────────────────
                  _SurplusCard(
                    footprint: _footprint,
                    savedKg: _saved,
                    loading: _loading,
                  ),

                  const SizedBox(height: 24),

                  // ── Impact Areas ─────────────────────────────────────────
                  const Text(
                    'Impact Areas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // CHANGE: subtitles now show real kg from completed actions,
                  // falling back to a helpful prompt if the user hasn't done any yet.
                  _ImpactCard(
                    title: 'Water Savings',
                    subtitle: _impactSubtitle(
                      'water',
                      'Start water-saving actions to see your impact',
                    ),
                    imageUrl: 'assets/images/water_savings.png',
                    savedKg: _savedByCategory['water'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),
                  _ImpactCard(
                    title: 'Biodiversity Impact',
                    subtitle: _impactSubtitle(
                      'biodiversity',
                      'Take actions that protect local ecosystems',
                    ),
                    imageUrl: 'assets/images/biodiversity.png',
                    savedKg: _savedByCategory['biodiversity'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),
                  _ImpactCard(
                    title: 'Waste Reduction',
                    subtitle: _impactSubtitle(
                      'waste',
                      'Cut landfill waste with smarter choices',
                    ),
                    imageUrl: 'assets/images/waste_reduction.png',
                    savedKg: _savedByCategory['waste'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),
                  _ImpactCard(
                    title: 'Energy Savings',
                    subtitle: _impactSubtitle(
                      'energy',
                      'Reduce home energy use with simple swaps',
                    ),
                    imageUrl: 'assets/images/energy.png',
                    savedKg: _savedByCategory['energy'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),
                  _ImpactCard(
                    title: 'Transport',
                    subtitle: _impactSubtitle(
                      'transport',
                      'Drive less, fly less, save more CO₂e',
                    ),
                    imageUrl: 'assets/images/transport.png',
                    savedKg: _savedByCategory['transport'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),
                  _ImpactCard(
                    title: 'Diet Impact',
                    subtitle: _impactSubtitle(
                      'diet',
                      'Plant-based choices make a real difference',
                    ),
                    imageUrl: 'assets/images/diet.png',
                    savedKg: _savedByCategory['diet'] ?? 0,
                    onTap: () => _open(const ActionsScreen()),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick actions grid ────────────────────────────────────
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _QuickGrid(items: [
                    _Quick(
                      icon: Icons.calculate_outlined,
                      title: 'Carbon calculator',
                      subtitle: 'Estimate your annual footprint',
                      onTap: () => _open(const CalculatorScreen()),
                    ),
                    _Quick(
                      icon: Icons.eco_outlined,
                      title: 'Take an action',
                      subtitle: 'High-impact, low-friction',
                      onTap: () => _open(const ActionsScreen()),
                    ),
                    _Quick(
                      icon: Icons.restaurant_outlined,
                      title: 'Log a meal',
                      subtitle: 'Climate-friendly diet',
                      onTap: () => _open(const DietScreen()),
                    ),
                    _Quick(
                      icon: Icons.campaign_outlined,
                      title: 'Sign a petition',
                      subtitle: 'Local advocacy',
                      onTap: () => _open(const PetitionsScreen()),
                    ),
                  ]),

                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Surplus Card (unchanged) ─────────────────────────────────────────────────

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
    final isSurplus = net <= 0 && fpKg > 0;
    final isNeutral = net == 0 && fpKg > 0;
    final double progress =
        fpKg > 0 ? (savedKg / fpKg).clamp(0.0, 1.0) : 0.0;

    String headline;
    String message;
    if (loading) {
      headline = 'Loading...';
      message = '';
    } else if (fpKg == 0) {
      headline = 'What\'s your footprint?';
      message =
          'Run the carbon calculator to see your starting footprint and track your journey to climate surplus.';
    } else if (isSurplus) {
      headline = 'Climate Surplus 🌿';
      message =
          'Your actions have created a surplus of ${net.abs().toStringAsFixed(0)} kg CO₂e. Keep up the great work!';
    } else if (isNeutral) {
      headline = '🎉 Carbon Neutral!';
      message =
          'You are no longer contributing to climate change. Now push into surplus and help offset others!';
    } else {
      headline = 'Your Climate Balance';
      message =
          'You\'ve reduced your emissions by ${savedKg.toStringAsFixed(0)} kg CO₂e so far. '
          '${net.toStringAsFixed(0)} kg to go until you\'re carbon neutral.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          message,
          style: const TextStyle(
            color: Color(0xFFA3B2AA),
            fontSize: 15,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
          ),
        ),
        if (fpKg > 0) ...[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSurplus ? 'Current Surplus' : 'Progress to Neutral',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                isSurplus
                    ? '${net.abs().toStringAsFixed(0)} kg CO₂e surplus'
                    : '${savedKg.toStringAsFixed(0)} / ${fpKg.toStringAsFixed(0)} kg saved',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF3F4F49),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Start: ${fpKg.toStringAsFixed(0)} kg CO₂e',
                style: const TextStyle(
                  color: Color(0xFFA3B2AA),
                  fontSize: 13,
                  fontFamily: 'Manrope',
                ),
              ),
              const Text(
                'Goal: 0 kg (neutral)',
                style: TextStyle(
                  color: Color(0xFFA3B2AA),
                  fontSize: 13,
                  fontFamily: 'Manrope',
                ),
              ),
            ],
          ),
        ],
        if (loading)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(minHeight: 3),
          ),
      ],
    );
  }
}

// ── Impact Card ──────────────────────────────────────────────────────────────

// CHANGE: added savedKg parameter to show a green badge when > 0
class _ImpactCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double savedKg;
  final VoidCallback onTap;

  const _ImpactCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.savedKg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = imageUrl.startsWith('http');
    final imageWidget = isNetwork
        ? Image.network(
            imageUrl,
            width: 110,
            height: 66,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _imagePlaceholder(),
          )
        : Image.asset(
            imageUrl,
            width: 110,
            height: 66,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _imagePlaceholder(),
          );

    // CHANGE: card gets a green left border when user has saved kg in this category
    final bool hasActivity = savedKg > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(12),
            // CHANGE: green left accent border when this category has activity
            border: hasActivity
                ? Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CHANGE: show green kg badge if user has activity in this category
                    if (hasActivity)
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${savedKg.toStringAsFixed(0)} kg CO₂e saved',
                          style: const TextStyle(
                            color: Color(0xFF4CAF50),
                            fontSize: 11,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFA3B2AA),
                        fontSize: 13,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 110,
      height: 66,
      decoration: BoxDecoration(
        color: const Color(0xFF2B3D35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image_outlined,
          color: Color(0xFF4CAF50), size: 28),
    );
  }
}

// ── Quick Grid (unchanged) ───────────────────────────────────────────────────

class _QuickGrid extends StatelessWidget {
  final List<_Quick> items;
  const _QuickGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, c) {
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
    });
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF4CAF50), size: 28),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFA3B2AA),
                  fontSize: 12,
                  fontFamily: 'Manrope',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}