import 'package:flutter/material.dart';

enum ColorSelection {
  graphite('Graphite', Color(0xFF1F2937)),
  midnight('Midnight', Color(0xFF0F172A)),
  electricBlue('Electric Blue', Color(0xFF0F62FE)),
  glacier('Glacier', Color(0xFF0EA5E9)),
  forest('Forest', Color(0xFF166534)),
  ember('Ember', Color(0xFFB45309));

  const ColorSelection(this.label, this.color);
  final String label;
  final Color color;
}

enum EchelonTab {
  discover(0),
  trips(1),
  account(2);

  const EchelonTab(this.value);
  final int value;
}
