import 'package:flutter/material.dart';

/// Centralised palette + spacing so every screen feels like the same app.
class ClimaColors {
  static const bg = Color(0xFFF9F9F9);
  static const surface = Color(0xFFE8F2ED);
  static const ink = Color(0xFF0F1914);
  static const inkSoft = Color(0xFF598C6D);
  static const primary = Color(0xFF93E0B2);
  static const accent = Color(0xFF2F8F5F);
  static const warning = Color(0xFFE08A3C);
  static const danger = Color(0xFFB23A48);
}

class ClimaText {
  static const TextStyle headline = TextStyle(
    color: ClimaColors.ink,
    fontSize: 24,
    fontFamily: 'Be Vietnam Pro',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle title = TextStyle(
    color: ClimaColors.ink,
    fontSize: 18,
    fontFamily: 'Be Vietnam Pro',
    fontWeight: FontWeight.w700,
  );
  static const TextStyle body = TextStyle(
    color: ClimaColors.ink,
    fontSize: 14,
    fontFamily: 'Be Vietnam Pro',
  );
  static const TextStyle muted = TextStyle(
    color: ClimaColors.inkSoft,
    fontSize: 13,
    fontFamily: 'Be Vietnam Pro',
  );
}

ButtonStyle climaPrimaryButtonStyle({bool primary = true}) =>
    ElevatedButton.styleFrom(
      backgroundColor: primary ? ClimaColors.primary : ClimaColors.surface,
      foregroundColor: ClimaColors.ink,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
    );

InputDecoration climaInputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ClimaColors.inkSoft),
      filled: true,
      fillColor: ClimaColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    );
