import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/shared/widgets/development_card.dart';
import 'package:mockito/mockito.dart';

// Create a mock function for the onTap callback
class MockFunction extends Mock {
  void call();
}

void main() {
  testWidgets('DevelopmentCard displays correctly with all parameters', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DevelopmentCard(
            id: '1',
            name: 'Test Development',
            location: 'Test Location',
            imageUrl: 'https://example.com/image.jpg',
            status: 'active',
            units: 24,
            unitsSold: 10,
            progress: 0.5,
            description: 'A beautiful development property',
            isLowBandwidth: false,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify basic content
    expect(find.text('Test Development'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
    expect(find.text('24 Units'), findsAtLeastNWidgets(1));
    
    // Status should be displayed
    expect(find.text('active'), findsOneWidget);
  });

  testWidgets('DevelopmentCard handles minimal parameters correctly', (WidgetTester tester) async {
    // Build the widget with minimal required parameters
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DevelopmentCard(
            id: '2',
            name: 'Minimal Test',
            location: 'Unknown',
            units: 1,
            unitsSold: 0,
            imageUrl: '',
            description: '',
            isLowBandwidth: true,
            onTap: () {},
          ),
        ),
      ),
    );

    // Verify the name is displayed
    expect(find.text('Minimal Test'), findsOneWidget);
    
    // Verify location is displayed
    expect(find.text('Unknown'), findsOneWidget);
  });

  testWidgets('DevelopmentCard onTap callback works', (WidgetTester tester) async {
    // Track if callback was called
    bool callbackCalled = false;
    
    // Build the widget with a callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DevelopmentCard(
            id: '3',
            name: 'Tappable Card',
            location: 'Test Location',
            units: 10,
            unitsSold: 5,
            imageUrl: 'https://example.com/image.jpg',
            description: 'Test description',
            isLowBandwidth: false,
            onTap: () {
              callbackCalled = true;
            },
          ),
        ),
      ),
    );

    // Initially the callback hasn't been called
    expect(callbackCalled, false);
    
    // Tap on the card
    await tester.tap(find.byType(DevelopmentCard));
    
    // Verify callback was called
    expect(callbackCalled, true);
  });
}
