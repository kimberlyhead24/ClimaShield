import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models/community.dart';
import '../theme.dart';

class PetitionsScreen extends StatefulWidget {
  const PetitionsScreen({super.key});

  @override
  State<PetitionsScreen> createState() => _PetitionsScreenState();
}

class _PetitionsScreenState extends State<PetitionsScreen> {
  List<Petition> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ClimaRepository.instance.petitions();
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Future<void> _sign(Petition p) async {
    await ClimaRepository.instance.signPetition(p);
    if (!mounted) return;
    setState(() {
      _items = _items
          .map(
            (q) => q.id == p.id
                ? q.copyWith(signatureCount: q.signatureCount + 1)
                : q,
          )
          .toList();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Signed: ${p.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClimaColors.bg,
      appBar: AppBar(
        title: const Text('Local advocacy'),
        backgroundColor: ClimaColors.bg,
        foregroundColor: ClimaColors.ink,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Petitions & campaigns near you',
              style: ClimaText.title,
            ),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(minHeight: 3),
            for (final p in _items)
              _PetitionCard(
                petition: p,
                onSign: () => _sign(p),
                signed: ClimaRepository.instance.hasSigned(p.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _PetitionCard extends StatelessWidget {
  final Petition petition;
  final VoidCallback onSign;
  final bool signed;
  const _PetitionCard({
    required this.petition,
    required this.onSign,
    required this.signed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ClimaColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(petition.title, style: ClimaText.title),
          const SizedBox(height: 4),
          Text('Target: ${petition.target}', style: ClimaText.muted),
          const SizedBox(height: 10),
          Text(petition.summary, style: ClimaText.body),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: petition.progress,
              minHeight: 8,
              backgroundColor: ClimaColors.surface,
              valueColor: const AlwaysStoppedAnimation(ClimaColors.accent),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${petition.signatureCount} / ${petition.signatureGoal} signatures',
            style: ClimaText.muted,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: signed ? null : onSign,
            icon: Icon(signed ? Icons.check : Icons.draw),
            label: Text(signed ? 'Signed' : 'Sign this petition'),
            style: climaPrimaryButtonStyle(primary: !signed),
          ),
        ],
      ),
    );
  }
}
