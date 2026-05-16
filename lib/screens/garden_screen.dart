import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClimaColors.bg,
      appBar: AppBar(
        title: const Text('Garden & food'),
        backgroundColor: ClimaColors.bg,
        foregroundColor: ClimaColors.ink,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Grow some of what you eat', style: ClimaText.headline),
          const SizedBox(height: 4),
          const Text(
            'Even a balcony herb garden trims the embedded carbon of store-bought produce.',
            style: ClimaText.muted,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ClimaColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Start small (week 1)', style: ClimaText.title),
                SizedBox(height: 6),
                Text(
                  '• Pick one container or bed.\n• Choose 1-2 plants below.\n• Set a weekly 10-minute check-in.',
                  style: ClimaText.body,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Easy starters', style: ClimaText.title),
          const SizedBox(height: 8),
          for (final p in SampleData.gardenPlants)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ClimaColors.surface),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name, style: ClimaText.title.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Season: ${p.season}', style: ClimaText.muted),
                  Text('Sunlight: ${p.sunlight}', style: ClimaText.muted),
                  Text('Yield: ${p.yieldNote}', style: ClimaText.muted),
                  const SizedBox(height: 6),
                  Text('Tip: ${p.tip}', style: ClimaText.body),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text('Climate impact of home growing', style: ClimaText.title),
          const SizedBox(height: 6),
          const Text(
            'Home-grown produce replaces store produce that carried transport, refrigeration, and packaging carbon. The biggest wins are leafy greens, herbs, and tomatoes - all things that suffer most in long supply chains.',
            style: ClimaText.body,
          ),
        ],
      ),
    );
  }
}
