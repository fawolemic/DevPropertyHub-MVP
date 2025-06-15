import 'package:flutter/material.dart';

class UserRole {
  final String type;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> features;

  UserRole({
    required this.type,
    required this.icon,
    required this.color,
    required this.description,
    required this.features,
  });

  static List<UserRole> getRoles() {
    return [
      UserRole(
        type: "Developer",
        icon: Icons.business,
        color: Colors.blue.shade500,
        description: "List your projects, manage properties, track sales",
        features: [
          "Project Management",
          "Lead Generation",
          "Analytics Dashboard",
          "Marketing Tools"
        ],
      ),
      UserRole(
        type: "Buyer",
        icon: Icons.shopping_cart,
        color: Colors.orange.shade500,
        description: "Find your dream property, compare options, secure deals",
        features: [
          "Property Search",
          "Virtual Tours",
          "Price Comparison",
          "Financing Options"
        ],
      ),
      UserRole(
        type: "Viewer",
        icon: Icons.visibility,
        color: Colors.green.shade500,
        description:
            "Explore market trends, research properties, stay informed",
        features: [
          "Market Analysis",
          "Property Details",
          "Neighborhood Info",
          "Investment Insights"
        ],
      ),
    ];
  }
}
