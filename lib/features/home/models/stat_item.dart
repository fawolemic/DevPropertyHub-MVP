import 'package:flutter/material.dart';

class StatItem {
  final String label;
  final String value;
  final IconData icon;

  StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  static List<StatItem> getStats() {
    return [
      StatItem(label: "Active Projects", value: "150+", icon: Icons.business),
      StatItem(label: "Happy Buyers", value: "2,500+", icon: Icons.people),
      StatItem(
          label: "Partner Developers", value: "45+", icon: Icons.trending_up),
      StatItem(label: "Cities Covered", value: "12", icon: Icons.location_on),
    ];
  }
}
