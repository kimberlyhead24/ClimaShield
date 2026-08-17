import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/repository.dart';
import '../models/climate_action.dart';
import '../utils/template_resolver.dart';

class ActionDetailScreen extends StatefulWidget {
  final ClimateAction action;
  const ActionDetailScreen({super.key, required this.action});

  @override
  State<ActionDetailScreen> createState() => _ActionDetailScreenState();
}

class _ActionDetailScreenState extends State<ActionDetailScreen> {
  bool _saving = false;
  bool _alreadyDone = false;
  String _resolvedScientificBasis = '';

  @override
  void initState() {
    super.initState();
    _checkDone();
    _resolveTemplates();
  }

  Future<void> _resolveTemplates() async {
    const userState = 'IL';
    final resolved = await TemplateResolver.resolve(
      widget.action.scientificBasis,
      userState,
    );
    if (!mounted) return;
    setState(() => _resolvedScientificBasis = resolved);
  }

  Future<void> _checkDone() async {
    final list = await ClimaRepository.instance.completedActions();
    if (!mounted) return;
    setState(() {
      _alreadyDone = list.any((c) => c.actionId == widget.action.id);
    });
  }

  Future<void> _markDone() async {
    if (_alreadyDone) return;
    setState(() => _saving = true);
    await ClimaRepository.instance.markActionComplete(widget.action);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _alreadyDone = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${widget.action.name} added to your actions'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _showScienceModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ScienceModal(
        scientificBasis: _resolvedScientificBasis.isNotEmpty
            ? _resolvedScientificBasis
            : widget.action.scientificBasis,
        sourceLink: widget.action.sourceLink,
        environmentalImpactAreas: widget.action.environmentalImpactAreas,
        actionName: widget.action.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.action;

    return Scaffold(
      backgroundColor: const Color(0xFF111611),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0xFF111611),
                  foregroundColor: Colors.white,
                  pinned: false,
                  floating: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const SizedBox.shrink(),
                ),

                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroImage(action: a),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Wrap(
                          spacing: 8,
                          children: a.categories
                              .map((c) => _CategoryChip(label: c.label))
                              .toList(),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          a.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            height: 1.27,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatTile(
                                label: 'Impact',
                                value: _impactLabel(
                                  a.impactScore.co2eReductionPerYearKg,
                                ),
                                icon: Icons.bolt_rounded,
                                iconColor: const Color(0xFF8CD177),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatTile(
                                label: 'Difficulty',
                                value: a.difficulty,
                                icon: Icons.trending_up_rounded,
                                iconColor: _difficultyColor(a.difficulty),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatTile(
                                label: 'Cost',
                                value: a.costEstimate,
                                icon: Icons.attach_money_rounded,
                                iconColor: const Color(0xFFFFC857),
                              ),
                            ),
                          ],
                        ),
                      ),

                      _ImpactMetricsRow(score: a.impactScore),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Text(
                          a.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            height: 1.60,
                          ),
                        ),
                      ),

                      if (a.environmentalImpactAreas.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Environmental Impact Areas',
                                style: TextStyle(
                                  color: Color(0xFFA3AAB2),
                                  fontSize: 12,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: a.environmentalImpactAreas
                                    .map((area) => _ImpactAreaChip(label: area))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: GestureDetector(
                          onTap: _showScienceModal,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1F2D),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF1A4A6B),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A4A6B),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.science_outlined,
                                    color: Color(0xFF5BB8FF),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'The Science Behind This',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Manrope',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Peer-reviewed sources & data',
                                        style: TextStyle(
                                          color: Color(0xFF5BB8FF),
                                          fontFamily: 'Manrope',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xFF5BB8FF),
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (a.requiresProfessional ||
                          (a.safetyNote?.isNotEmpty ?? false))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    a.safetyNote ??
                                        'This action involves systems that require a licensed professional.',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontFamily: 'Manrope',
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (a.stepByStepGuide.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 28, 16, 12),
                          child: Text(
                            'Step-by-Step Guide',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              height: 1.27,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              for (int i = 0; i < a.stepByStepGuide.length; i++)
                                _StepRow(
                                  number: i + 1,
                                  text: a.stepByStepGuide[i],
                                ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            color: const Color(0xFF111611),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: (_saving || _alreadyDone) ? null : _markDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _alreadyDone
                        ? const Color(0xFF2B3035)
                        : const Color(0xFF8CD177),
                    foregroundColor: _alreadyDone
                        ? const Color(0xFFA3AAB2)
                        : const Color(0xFF111611),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _saving
                        ? 'Saving...'
                        : _alreadyDone
                        ? '✓ Added to My Actions'
                        : 'Add to My Actions',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      color: _alreadyDone
                          ? const Color(0xFFA3AAB2)
                          : const Color(0xFF111611),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _impactLabel(double kg) {
    if (kg >= 500) return 'Very High';
    if (kg >= 200) return 'High';
    if (kg >= 100) return 'Medium';
    return 'Low';
  }

  Color _difficultyColor(String d) {
    switch (d.toLowerCase()) {
      case 'easy':
        return const Color(0xFF8CD177);
      case 'medium':
        return const Color(0xFFFFC857);
      case 'hard':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.white;
    }
  }
}

// ── Hero image ────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final ClimateAction action;
  const _HeroImage({required this.action});

  @override
  Widget build(BuildContext context) {
    final heroHeight = (MediaQuery.of(context).size.height * 0.28).clamp(
      200.0,
      320.0,
    );

    Widget imageWidget;

    if (action.imageUrl != null && action.imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        action.imageUrl!,
        width: double.infinity,
        height: heroHeight,
        fit: BoxFit.cover,
        // ✅ Fixed: use distinct parameter names instead of repeated _
        errorBuilder: (context, error, stackTrace) =>
            _assetImage(action, heroHeight),
      );
    } else {
      imageWidget = _assetImage(action, heroHeight);
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: imageWidget,
    );
  }

  Widget _assetImage(ClimateAction a, double height) => Image.asset(
    a.primaryCategory.imageAsset,
    width: double.infinity,
    height: height,
    fit: BoxFit.cover,
    // ✅ Fixed: use distinct parameter names instead of repeated _
    errorBuilder: (context, error, stackTrace) => Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFF1A2320),
      child: const Center(
        child: Icon(Icons.eco, color: Color(0xFF4CAF50), size: 56),
      ),
    ),
  );
}

// ── Category chip ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8CD177),
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Impact area chip ──────────────────────────────────────────────────────────

class _ImpactAreaChip extends StatelessWidget {
  final String label;
  const _ImpactAreaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2320),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF424F3F)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFA3AAB2),
          fontFamily: 'Manrope',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// ── Stat tile ─────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF424F3F)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA3AAB2),
              fontSize: 12,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Impact metrics row ────────────────────────────────────────────────────────

class _ImpactMetricsRow extends StatelessWidget {
  final ActionImpactScore score;
  const _ImpactMetricsRow({required this.score});

  @override
  Widget build(BuildContext context) {
    final metrics = <_Metric>[];

    if (score.co2eReductionPerYearKg > 0) {
      metrics.add(
        _Metric(
          icon: Icons.cloud_outlined,
          color: const Color(0xFF8CD177),
          value: '${score.co2eReductionPerYearKg.toStringAsFixed(0)} kg',
          label: 'CO₂e/yr saved',
        ),
      );
    }
    if (score.waterSavedGallons > 0) {
      metrics.add(
        _Metric(
          icon: Icons.water_drop_outlined,
          color: const Color(0xFF5BB8FF),
          value: '${score.waterSavedGallons.toStringAsFixed(0)} gal',
          label: 'Water saved/yr',
        ),
      );
    }
    if (score.wasteDivertedKg > 0) {
      metrics.add(
        _Metric(
          icon: Icons.delete_outline_rounded,
          color: const Color(0xFFFFC857),
          value: '${score.wasteDivertedKg.toStringAsFixed(0)} kg',
          label: 'Waste diverted/yr',
        ),
      );
    }
    if (score.pollinatorHabitatSqFt > 0) {
      metrics.add(
        _Metric(
          icon: Icons.local_florist_outlined,
          color: const Color(0xFFFF9ECD),
          value: '${score.pollinatorHabitatSqFt.toStringAsFixed(0)} ft²',
          label: 'Pollinator habitat',
        ),
      );
    }

    if (metrics.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2320),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: metrics
              .map((m) => Expanded(child: _MetricCell(metric: m)))
              .toList(),
        ),
      ),
    );
  }
}

class _Metric {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _Metric({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });
}

class _MetricCell extends StatelessWidget {
  final _Metric metric;
  const _MetricCell({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(metric.icon, color: metric.color, size: 20),
        const SizedBox(height: 6),
        Text(
          metric.value,
          style: TextStyle(
            color: metric.color,
            fontFamily: 'Manrope',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          metric.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFA3AAB2),
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── Step row ──────────────────────────────────────────────────────────────────

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Color(0xFF8CD177),
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Science modal ─────────────────────────────────────────────────────────────

class _ScienceModal extends StatelessWidget {
  final String scientificBasis;
  final String sourceLink;
  final List<String> environmentalImpactAreas;
  final String actionName;

  const _ScienceModal({
    required this.scientificBasis,
    required this.sourceLink,
    required this.environmentalImpactAreas,
    required this.actionName,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0D1F2D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2B4A6B),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A4A6B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.science_outlined,
                          color: Color(0xFF5BB8FF),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'The Science',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Manrope',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Peer-reviewed research & data',
                              style: TextStyle(
                                color: Color(0xFF5BB8FF),
                                fontFamily: 'Manrope',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (scientificBasis.isNotEmpty) ...[
                    const Text(
                      'SCIENTIFIC BASIS',
                      style: TextStyle(
                        color: Color(0xFF5BB8FF),
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111D2B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1A4A6B)),
                      ),
                      child: Text(
                        scientificBasis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (environmentalImpactAreas.isNotEmpty) ...[
                    const Text(
                      'IMPACT AREAS',
                      style: TextStyle(
                        color: Color(0xFF5BB8FF),
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: environmentalImpactAreas
                          .map(
                            (area) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF111D2B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF1A4A6B),
                                ),
                              ),
                              child: Text(
                                area,
                                style: const TextStyle(
                                  color: Color(0xFF5BB8FF),
                                  fontFamily: 'Manrope',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  if (sourceLink.isNotEmpty) ...[
                    const Text(
                      'PRIMARY SOURCE',
                      style: TextStyle(
                        color: Color(0xFF5BB8FF),
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.tryParse(sourceLink);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111D2B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF1A4A6B)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              color: Color(0xFF5BB8FF),
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                sourceLink,
                                style: const TextStyle(
                                  color: Color(0xFF5BB8FF),
                                  fontFamily: 'Manrope',
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF5BB8FF),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.open_in_new_rounded,
                              color: Color(0xFF5BB8FF),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
