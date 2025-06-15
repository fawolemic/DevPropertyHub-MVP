import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/widgets/components/selection/location_multi_select.dart';

void main() {
  group('LocationMultiSelect', () {
    final testLocations = [
      'Lagos - Mainland',
      'Lagos - Island',
      'Abuja - Central',
      'Abuja - Suburbs',
      'Port Harcourt'
    ];

    testWidgets('should display all available locations',
        (WidgetTester tester) async {
      List<String> selectedLocations = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationMultiSelect(
            availableLocations: testLocations,
            selectedLocations: selectedLocations,
            onChanged: (locations) {
              selectedLocations = locations;
            },
            label: 'Preferred Locations',
          ),
        ),
      ));

      // Verify component renders correctly
      expect(find.text('Preferred Locations'), findsOneWidget);
      expect(find.text('Available Locations:'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search field

      // Verify all locations are displayed
      for (final location in testLocations) {
        expect(find.text(location), findsOneWidget);
      }
    });

    testWidgets('should filter locations based on search query',
        (WidgetTester tester) async {
      List<String> selectedLocations = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationMultiSelect(
            availableLocations: testLocations,
            selectedLocations: selectedLocations,
            onChanged: (locations) {
              selectedLocations = locations;
            },
            label: 'Preferred Locations',
          ),
        ),
      ));

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Lagos');
      await tester.pump();

      // Verify only Lagos locations are displayed
      expect(find.text('Lagos - Mainland'), findsOneWidget);
      expect(find.text('Lagos - Island'), findsOneWidget);
      expect(find.text('Abuja - Central'), findsNothing);
      expect(find.text('Abuja - Suburbs'), findsNothing);
      expect(find.text('Port Harcourt'), findsNothing);
    });

    testWidgets('should add location to selected list when clicked',
        (WidgetTester tester) async {
      List<String> selectedLocations = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return LocationMultiSelect(
                availableLocations: testLocations,
                selectedLocations: selectedLocations,
                onChanged: (locations) {
                  setState(() {
                    selectedLocations = locations;
                  });
                },
                label: 'Preferred Locations',
              );
            },
          ),
        ),
      ));

      // Select a location
      await tester.tap(find.text('Lagos - Mainland').last);
      await tester.pump();

      // Verify location was selected
      expect(selectedLocations, contains('Lagos - Mainland'));
      expect(find.text('Selected Locations:'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('should remove location from selected list when chip deleted',
        (WidgetTester tester) async {
      List<String> selectedLocations = ['Lagos - Mainland'];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return LocationMultiSelect(
                availableLocations: testLocations,
                selectedLocations: selectedLocations,
                onChanged: (locations) {
                  setState(() {
                    selectedLocations = locations;
                  });
                },
                label: 'Preferred Locations',
              );
            },
          ),
        ),
      ));

      // Verify chip is displayed
      expect(find.byType(Chip), findsOneWidget);

      // Delete the chip
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Verify location was removed
      expect(selectedLocations, isEmpty);
      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('should show no locations found when search has no matches',
        (WidgetTester tester) async {
      List<String> selectedLocations = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LocationMultiSelect(
            availableLocations: testLocations,
            selectedLocations: selectedLocations,
            onChanged: (locations) {
              selectedLocations = locations;
            },
            label: 'Preferred Locations',
          ),
        ),
      ));

      // Enter search query with no matches
      await tester.enterText(find.byType(TextField), 'Enugu');
      await tester.pump();

      // Verify no locations found message
      expect(find.text('No locations found'), findsOneWidget);
    });
  });
}
