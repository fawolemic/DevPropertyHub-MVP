class FeaturedProperty {
  final int id;
  final String title;
  final String developer;
  final String location;
  final String price;
  final int units;
  final String image;
  final String status;
  final String completion;
  final double rating;

  FeaturedProperty({
    required this.id,
    required this.title,
    required this.developer,
    required this.location,
    required this.price,
    required this.units,
    required this.image,
    required this.status,
    required this.completion,
    required this.rating,
  });

  static List<FeaturedProperty> getSampleData() {
    return [
      FeaturedProperty(
        id: 1,
        title: "Modern Residential Complex",
        developer: "Elite Developments",
        location: "Downtown District",
        price: "\$2.5M - \$4.2M",
        units: 45,
        image:
            "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400&h=300&fit=crop",
        status: "Under Construction",
        completion: "Q4 2025",
        rating: 4.8,
      ),
      FeaturedProperty(
        id: 2,
        title: "Luxury Waterfront Towers",
        developer: "Coastal Properties",
        location: "Marina Bay",
        price: "\$1.8M - \$3.5M",
        units: 78,
        image:
            "https://images.unsplash.com/photo-1582268611958-ebfd161ef9cf?w=400&h=300&fit=crop",
        status: "Ready to Move",
        completion: "Completed",
        rating: 4.9,
      ),
      FeaturedProperty(
        id: 3,
        title: "Green Valley Estates",
        developer: "EcoHomes Ltd",
        location: "Suburban Hills",
        price: "\$850K - \$1.2M",
        units: 32,
        image:
            "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&h=300&fit=crop",
        status: "Pre-Launch",
        completion: "Q2 2026",
        rating: 4.7,
      ),
    ];
  }
}
