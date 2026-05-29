import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/climate_action.dart';
import 'action_detail_screen.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  ActionCategory? _categoryFilter;
  _StatusFilter _statusFilter = _StatusFilter.all;
  Set<String> _completedIds = {};
  String _search = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCompleted() async {
    final list = await ClimaRepository.instance.completedActions();
    if (!mounted) return;
    setState(() => _completedIds = list.map((c) => c.actionId).toSet());
  }

  List<ClimateAction> get _filtered {
    var result = ClimaRepository.instance.allActions();

    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.categories.any((c) => c.label.toLowerCase().contains(q)))
          .toList();
    }

    if (_categoryFilter != null) {
      result = result
          .where((a) => a.categories.contains(_categoryFilter))
          .toList();
    }

    result = switch (_statusFilter) {
      _StatusFilter.all => result,
      _StatusFilter.todo =>
        result.where((a) => !_completedIds.contains(a.id)).toList(),
      _StatusFilter.done =>
        result.where((a) => _completedIds.contains(a.id)).toList(),
    };

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    // On wider screens (tablet/desktop) use more columns
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 900
        ? 4
        : screenWidth >= 600
            ? 3
            : 2;

    // Cap the image portion to a reasonable size on desktop
    final cardImageSize = (screenWidth / crossAxisCount - 24).clamp(120.0, 220.0);

    return Scaffold(
      backgroundColor: const Color(0xFF111416),
      body: RefreshIndicator(
        onRefresh: _loadCompleted,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color(0xFF111416),
              pinned: true,
              centerTitle: true,
              title: const Text(
                'Find Your Next Action',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  height: 1.28,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Search bar ──────────────────────────────────────────
                    Container(
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF2B3035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search,
                              color: Color(0xFFA3AAB2), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Manrope',
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search actions',
                                hintStyle: TextStyle(
                                  color: Color(0xFFA3AAB2),
                                  fontSize: 16,
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (v) =>
                                  setState(() => _search = v.trim()),
                            ),
                          ),
                          if (_search.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _search = '');
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.close,
                                    color: Color(0xFFA3AAB2), size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _StatusToggle(
                      current: _statusFilter,
                      onChange: (v) => setState(() => _statusFilter = v),
                    ),

                    const SizedBox(height: 12),

                    // ── Category chips ──────────────────────────────────────
                    SizedBox(
                      height: 32,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            label: 'All',
                            selected: _categoryFilter == null,
                            onTap: () =>
                                setState(() => _categoryFilter = null),
                          ),
                          for (final c in ActionCategory.values)
                            _FilterChip(
                              label: c.label,
                              selected: _categoryFilter == c,
                              onTap: () =>
                                  setState(() => _categoryFilter = c),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        height: 1.28,
                      ),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            filtered.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        _statusFilter == _StatusFilter.done
                            ? 'No completed actions yet.\nStart taking action!'
                            : 'No actions match this filter.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFA3AAB2),
                          fontSize: 15,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverGrid(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: cardImageSize / (cardImageSize + 99),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final a = filtered[index];
                          return _ActionGridCard(
                            action: a,
                            done: _completedIds.contains(a.id),
                            imageSize: cardImageSize,
                            onTap: () => _openDetail(a),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _openDetail(ClimateAction a) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ActionDetailScreen(action: a)),
    ).then((_) => _loadCompleted());
  }
}

// ── Status filter enum ────────────────────────────────────────────────────────

enum _StatusFilter { all, todo, done }

// ── Status toggle ─────────────────────────────────────────────────────────────

class _StatusToggle extends StatelessWidget {
  final _StatusFilter current;
  final ValueChanged<_StatusFilter> onChange;
  const _StatusToggle({required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF2B3035),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _option('All', _StatusFilter.all),
          _option('To Do', _StatusFilter.todo),
          _option('Done', _StatusFilter.done),
        ],
      ),
    );
  }

  Widget _option(String label, _StatusFilter value) {
    final selected = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF4CAF50) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFFA3AAB2),
              fontFamily: 'Manrope',
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Category filter chip ──────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: selected
                ? const Color(0xFF4CAF50)
                : const Color(0xFF2B3035),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFFA3AAB2),
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Grid card ─────────────────────────────────────────────────────────────────

class _ActionGridCard extends StatelessWidget {
  final ClimateAction action;
  final bool done;
  final double imageSize;
  final VoidCallback onTap;
  const _ActionGridCard({
    required this.action,
    required this.done,
    required this.imageSize,
    required this.onTap,
  });

  String _impactLabel(double kg) {
    if (kg >= 500) return '5';
    if (kg >= 200) return '4';
    if (kg >= 100) return '3';
    if (kg >= 50) return '2';
    return '1';
  }

  @override
  Widget build(BuildContext context) {
    final a = action;
    final categoryLabel = a.categories.map((c) => c.label).join(' · ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed-size square hero image ──────────────────────────────
            SizedBox(
              width: imageSize,
              height: imageSize,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: a.imageUrl != null && a.imageUrl!.isNotEmpty
                        ? Image.network(
                            a.imageUrl!,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _assetImage(a),
                          )
                        : _assetImage(a),
                  ),
                  if (done)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '✓ Done',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Title ─────────────────────────────────────────────────────
            Text(
              a.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),

            // ── Categories ────────────────────────────────────────────────
            Text(
              categoryLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFA3AAB2),
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),

            // ── Impact · Difficulty ───────────────────────────────────────
            Text(
              'Impact: ${_impactLabel(a.co2eKgPerYear)} · ${a.difficulty}',
              style: const TextStyle(
                color: Color(0xFFA3AAB2),
                fontSize: 14,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assetImage(ClimateAction a) => Image.asset(
        a.primaryCategory.imageAsset,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.eco_outlined,
                color: Color(0xFF4CAF50), size: 32),
          ),
        ),
      );
}