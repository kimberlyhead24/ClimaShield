import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_auth_service.dart';
import '../theme.dart';
import 'calculator_screen.dart';
import 'garden_screen.dart';
import 'petitions_screen.dart';
import 'solar_screen.dart';
import 'welcome_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      user = null;
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('More', style: ClimaText.headline),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ClimaColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: [
            const CircleAvatar(
              backgroundColor: ClimaColors.primary,
              child: Icon(Icons.person, color: ClimaColors.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.email ?? 'Signed out (local mode)',
                      style: ClimaText.title.copyWith(fontSize: 14)),
                  Text(user == null
                      ? 'Sign in to sync your progress to the cloud.'
                      : 'Synced with Firebase',
                      style: ClimaText.muted),
                ],
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),
        _tile(context, Icons.calculate_outlined, 'Carbon calculator',
            const CalculatorScreen()),
        _tile(context, Icons.solar_power_outlined, 'Solar planner',
            const SolarScreen()),
        _tile(context, Icons.local_florist_outlined, 'Garden & food independence',
            const GardenScreen()),
        _tile(context, Icons.campaign_outlined, 'Local petitions',
            const PetitionsScreen()),
        const SizedBox(height: 16),
        const Text('About', style: ClimaText.title),
        const SizedBox(height: 6),
        const Text(
          "ClimaShield is an MVP of a climate-surplus platform: a community hub, climate diet tracker, carbon calculator, DIY action library, off-grid solar planner, gardening guidance, and local advocacy in one app.",
          style: ClimaText.body,
        ),
        const SizedBox(height: 24),
        if (user != null)
          OutlinedButton.icon(
            onPressed: () async {
              await FirebaseAuthService().signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign out'),
          ),
      ],
    );
  }

  Widget _tile(BuildContext ctx, IconData icon, String label, Widget page) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: ClimaColors.surface),
      ),
      child: ListTile(
        leading: Icon(icon, color: ClimaColors.accent),
        title: Text(label, style: ClimaText.body),
        trailing: const Icon(Icons.chevron_right, color: ClimaColors.inkSoft),
        onTap: () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }
}
