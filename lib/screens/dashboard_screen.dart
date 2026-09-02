import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../data/recipe_repository.dart';

import '../models/footprint.dart';
import '../models/climate_action.dart';
import '../models/community.dart';
import '../models/recipe_model.dart';

import 'community_screen.dart';
import 'recipe_detail_screen.dart';
import 'actions_screen.dart';

import 'diet_onboarding_gate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CarbonFootprint? _footprint;
  double _saved = 0;
  double _dietSavings = 0;
  double _appliedDietSavings = 0;
  // CHANGE: added category savings map
  Map<String, double> _savedByCategory = {};
  bool _loading = true;

  List<CommunityPost> _communityPosts = const [];
  List<Recipe> _recipeIdeas = const [];
  ClimateAction? _recommendedAction;

  @override
  void initState() {
    super.initState();
    _load();
    ClimaRepository.instance.loadActions();
  }

  // CHANGE: now also loads co2eSavedByCategory
  Future<void> _load() async {
    final results = await Future.wait([
      ClimaRepository.instance.loadFootprint(),
      ClimaRepository.instance.totalNonDietActionSavingsKg(),
      ClimaRepository.instance.co2eSavedByCategory(),
      ClimaRepository.instance.totalDietSavingsKg(),
      ClimaRepository.instance.communityPosts(),
      RecipeRepository.instance.loadAllRecipes(),
    ]);
    if (!mounted) return;

    final footprint = results[0] as CarbonFootprint?;
    final nonDietActionSavings = results[1] as double;
    final savedByCategory = results[2] as Map<String, double>;
    final loggedDietSavings = results[3] as double;
    final communityPosts = {
      results[4] as List,
    }.whereType<CommunityPost>().take(2).toList();

    final recipeIdeas = (results[5] as List)
        .whereType<Recipe>()
        .take(2)
        .toList();

    //A user cannot avoid more diet emissions than exist in the originial
    // 12-month diet baseline projection
    final dietBaselineKg = footprint?.dietKg ?? 0;
    final appliedDietSavings = loggedDietSavings
        .clamp(0.0, dietBaselineKg)
        .toDouble();

    setState(() {
      _footprint = footprint;
      _dietSavings = loggedDietSavings;
      _appliedDietSavings = appliedDietSavings;
      _saved = nonDietActionSavings + appliedDietSavings;
      _savedByCategory = savedByCategory;
      _loading = false;
      _communityPosts = communityPosts;
      _recipeIdeas = recipeIdeas;
    });
  }

  void _open(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => _load());
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
                          child: Icon(
                            Icons.public,
                            size: 64,
                            color: Color(0xFF4CAF50),
                          ),
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
                    subtitle: _dietSavings == 0
                        ? 'Log recipes and smart outside meals to reduce your 12-month projection'
                        : '${_appliedDietSavings.toStringAsFixed(1)} kg CO₂e '
                              'estimated from logged meal swaps',
                    imageUrl: 'assets/images/diet.png',
                    savedKg: _appliedDietSavings,
                    onTap: () => _open(const DietOnboardingGate()),
                  ),
                  const SizedBox(height: 24),
                  // ── Today for you ─────────────────────────────────────────
                  const Text(
                    'Today for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _DashboardFeatureCard(
                    icon: Icons.restaurant_outlined,
                    title: 'Find meals that fit your lifestyle',
                    subtitle:
                        'Explore climate-friendly recipes, take the diet quiz, and track meal-swap savings.',
                    buttonLabel: 'Explore recipes',
                    onTap: () => _open(const DietOnboardingGate()),
                  ),

                  const SizedBox(height: 24),

                  // ── Today's Meal ──────────────────────────────────────────
                  _SectionHeader(
                    title: 'Today\'s meal plan',
                    actionLabel: 'See all',
                    onActionTap: () => _open(const DietOnboardingGate()),
                  ),
                  const SizedBox(height: 12),

                  if (_recipeIdeas.isEmpty)
                    _EmptyPreviewCard(
                      icon: Icons.menu_book_outlined,
                      message:
                          'Recipe ideas will appear here once they are available.',
                      onTap: () => _open(const DietOnboardingGate()),
                    )
                  else
                    ..._recipeIdeas.map(
                      (recipe) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RecipePreviewCard(
                          recipe: recipe,
                          onTap: () =>
                              _open(RecipeDetailScreen(recipe: recipe)),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ── Recommended action ────────────────────────────────────
                  _SectionHeader(
                    title: 'Recommended action',
                    actionLabel: 'Browse actions',
                    onActionTap: () => _open(const ActionsScreen()),
                  ),
                  const SizedBox(height: 12),

                  if (_recommendedAction == null)
                    _EmptyPreviewCard(
                      icon: Icons.eco_outlined,
                      message: 'Recommended actions will appear here once available.',
                      onTap: () => _open(const ActionsScreen()),
                    )
                  else
                    _RecommendedActionCard(
                      action: _recommendedAction!,
                      onTap: () => _open(const ActionsScreen()),
                    ),

                  const SizedBox(height: 24),

                  // ── Community snapshot ────────────────────────────────────
                  _SectionHeader(
                    title: 'Community',
                    actionLabel: 'View feed',
                    onActionTap: () => _open(const CommunityScreen()),
                  ),
                  const SizedBox(height: 12),

                  if (_communityPosts.isEmpty)
                    _EmptyPreviewCard(
                      icon: Icons.people_outline,
                      message: 'Community posts will appear here soon.',
                      onTap: () => _open(const CommunityScreen()),
                    )
                  else
                    ..._communityPosts.map(
                      (post) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CommunityPreviewCard(
                          post: post,
                          onTap: () => _open(const CommunityScreen()),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ── Future content API area ───────────────────────────────
                  const Text(
                    'Climate updates',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _ClimateUpdatesPlaceholder(),

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
    final isSurplus = net < 0 && fpKg > 0;
    final isNeutral = net == 0 && fpKg > 0;
    final double progress = fpKg > 0 ? (savedKg / fpKg).clamp(0.0, 1.0) : 0.0;

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
      headline = 'Your 12-month climate balance';
      message =
          'You have reduced your 12-month projected emissions by ${savedKg.toStringAsFixed(0)} kg CO₂e so far. '
          '${net.toStringAsFixed(0)} kg remains in your projection.';
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
                isSurplus ? 'Current Surplus' : 'Projection progress',
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
                'Goal: 0 kg projected net emissions',
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
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF4CAF50,
                          ).withValues(alpha: 0.15),
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
      child: const Icon(
        Icons.image_outlined,
        color: Color(0xFF4CAF50),
        size: 28,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(onPressed: onActionTap, child: Text(actionLabel)),
      ],
    );
  }
}

class _DashboardFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  const _DashboardFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2320),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF4CAF50).withValues(alpha: 0.18),
            child: Icon(icon, color: const Color(0xFF4CAF50)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFA3B2AA),
                    fontFamily: 'Manrope',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(onPressed: onTap, child: Text(buttonLabel)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipePreviewCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipePreviewCard({required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = recipe.mealTypes.isNotEmpty
        ? recipe.mealTypes.first
        : 'Recipe idea';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2B3D35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipe.prepTimeMinutes > 0
                          ? '$label • ${recipe.prepTimeMinutes} min prep'
                          : label,
                      style: const TextStyle(
                        color: Color(0xFFA3B2AA),
                        fontFamily: 'Manrope',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFA3B2AA)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecommendedActionCard extends StatelessWidget {
  final ClimateAction action;
  final VoidCallback onTap;

  const _RecommendedActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF2B3D35),
                child: Icon(Icons.eco_outlined, color: Color(0xFF4CAF50)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA3B2AA),
                        fontFamily: 'Manrope',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFA3B2AA)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityPreviewCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback onTap;

  const _CommunityPreviewCard({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = post.authorName.isEmpty
        ? '?'
        : post.authorName.substring(0, 1).toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF2B3D35),
                child: Text(
                  initial,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA3B2AA),
                        fontFamily: 'Manrope',
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${post.likes} likes',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontFamily: 'Manrope',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPreviewCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onTap;

  const _EmptyPreviewCard({
    required this.icon,
    required this.message,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2320),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF4CAF50)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFA3B2AA),
                    fontFamily: 'Manrope',
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFA3B2AA)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClimateUpdatesPlaceholder extends StatelessWidget {
  const _ClimateUpdatesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2320),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2B3D35)),
      ),
      child: const Row(
        children: [
          Icon(Icons.newspaper_outlined, color: Color(0xFF64B5F6)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Climate news, technology updates, and learning resources '
              'will appear here from curated sources.',
              style: TextStyle(
                color: Color(0xFFA3B2AA),
                fontFamily: 'Manrope',
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
