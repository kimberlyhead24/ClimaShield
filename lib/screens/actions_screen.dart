import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/climate_action.dart';
import '../theme.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {
  ActionCategory? _filter;
  Set<String> _completedIds = {};

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final list = await ClimaRepository.instance.completedActions();
    if (!mounted) return;
    setState(() => _completedIds = list.map((c) => c.actionId).toSet());
  }

  @override
  Widget build(BuildContext context) {
    final all = ClimaRepository.instance.allActions();
    final filtered =
        _filter == null ? all : all.where((a) => a.category == _filter).toList();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Climate-positive actions', style: ClimaText.headline),
        const SizedBox(height: 4),
        const Text(
          'Pick one and bank the savings toward your surplus.',
          style: ClimaText.muted,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _Chip(label: 'All', selected: _filter == null, onTap: () => setState(() => _filter = null)),
              for (final c in ActionCategory.values)
                _Chip(
                  label: c.label,
                  selected: _filter == c,
                  onTap: () => setState(() => _filter = c),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final a in filtered)
          _ActionCard(
            action: a,
            done: _completedIds.contains(a.id),
            onTap: () => _openDetail(a),
          ),
      ],
    );
  }

  void _openDetail(ClimateAction a) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActionDetailScreen(action: a),
      ),
    ).then((_) => _loadCompleted());
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: ClimaColors.surface,
        selectedColor: ClimaColors.primary,
        labelStyle: ClimaText.body,
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final ClimateAction action;
  final bool done;
  final VoidCallback onTap;
  const _ActionCard({required this.action, required this.done, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ClimaColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        title: Text(action.title, style: ClimaText.title.copyWith(fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${action.category.label} • ~${action.co2eKgPerYear.toStringAsFixed(0)} kg CO₂e/yr • difficulty ${action.difficulty}/5',
            style: ClimaText.muted,
          ),
        ),
        trailing: done
            ? const Icon(Icons.check_circle, color: ClimaColors.accent)
            : const Icon(Icons.chevron_right, color: ClimaColors.inkSoft),
      ),
    );
  }
}

class ActionDetailScreen extends StatefulWidget {
  final ClimateAction action;
  const ActionDetailScreen({super.key, required this.action});

  @override
  State<ActionDetailScreen> createState() => _ActionDetailScreenState();
}

class _ActionDetailScreenState extends State<ActionDetailScreen> {
  bool _saving = false;

  Future<void> _markDone() async {
    setState(() => _saving = true);
    await ClimaRepository.instance.markActionComplete(widget.action);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged: ${widget.action.title}')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.action;
    return Scaffold(
      backgroundColor: ClimaColors.bg,
      appBar: AppBar(
        title: Text(a.category.label),
        backgroundColor: ClimaColors.bg,
        foregroundColor: ClimaColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(a.title, style: ClimaText.headline),
          const SizedBox(height: 8),
          Text(
            'Estimated savings: ~${a.co2eKgPerYear.toStringAsFixed(0)} kg CO₂e per year',
            style: ClimaText.muted,
          ),
          const SizedBox(height: 16),
          Text(a.summary, style: ClimaText.body),
          if (a.steps.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('How to do it', style: ClimaText.title),
            const SizedBox(height: 8),
            for (var i = 0; i < a.steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: ClimaColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: ClimaColors.ink, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(a.steps[i], style: ClimaText.body)),
                  ],
                ),
              ),
          ],
          if (a.requiresProfessional || (a.safetyNote?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ClimaColors.warning.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ClimaColors.warning.withOpacity(0.45)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.shield_outlined, color: ClimaColors.warning),
                    SizedBox(width: 8),
                    Text('Safety first', style: ClimaText.title),
                  ]),
                  const SizedBox(height: 8),
                  Text(
                    a.safetyNote ??
                        'This action involves systems that require a licensed professional and permits. Use ClimaShield to plan, not to wire.',
                    style: ClimaText.body,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _saving ? null : _markDone,
            style: climaPrimaryButtonStyle(),
            child: Text(_saving ? 'Saving...' : 'I did this'),
          ),
        ],
      ),
    );
  }
}
