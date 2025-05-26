import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/widgets/components/file_upload/document_uploader.dart';

void main() {
  group('DocumentUploader', () {
    testWidgets('should render upload button initially', (WidgetTester tester) async {
      String? selectedFile;
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DocumentUploader(
            label: 'CAC Certificate',
            acceptedFileTypes: 'pdf, jpg, png',
            onFileSelected: (file) {
              selectedFile = file;
            },
          ),
        ),
      ));
      
      // Verify the component renders
      expect(find.text('CAC Certificate'), findsOneWidget);
      expect(find.text('Upload CAC Certificate'), findsOneWidget);
      expect(find.byIcon(Icons.upload_file), findsOneWidget);
      
      // Verify helper text is shown
      expect(find.text('Accepted file types: pdf, jpg, png. Max size: 5MB'), findsOneWidget);
      
      // No file selected yet
      expect(selectedFile, isNull);
    });
    
    testWidgets('should show progress indicator during upload', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DocumentUploader(
            label: 'CAC Certificate',
            acceptedFileTypes: 'pdf',
            onFileSelected: (_) {},
          ),
        ),
      ));
      
      // Tap upload button to start upload
      await tester.tap(find.text('Upload CAC Certificate'));
      await tester.pump();
      
      // Progress indicator should be visible
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.textContaining('Uploading...'), findsOneWidget);
    });
    
    testWidgets('should display file preview after upload completes', (WidgetTester tester) async {
      String? selectedFile;
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DocumentUploader(
            label: 'CAC Certificate',
            acceptedFileTypes: 'pdf',
            onFileSelected: (file) {
              selectedFile = file;
            },
          ),
        ),
      ));
      
      // Tap upload button to start upload
      await tester.tap(find.text('Upload CAC Certificate'));
      await tester.pump();
      
      // Wait for upload to complete (simulated)
      await tester.pump(const Duration(seconds: 3));
      
      // File preview should be visible
      expect(find.text('CAC_Certificate.pdf'), findsOneWidget);
      expect(find.text('File uploaded successfully'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      
      // onFileSelected should have been called with the file path
      expect(selectedFile, isNotNull);
    });
    
    testWidgets('should allow removing the file', (WidgetTester tester) async {
      String? selectedFile;
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DocumentUploader(
            label: 'CAC Certificate',
            acceptedFileTypes: 'pdf',
            onFileSelected: (file) {
              selectedFile = file;
            },
          ),
        ),
      ));
      
      // Tap upload button to start upload
      await tester.tap(find.text('Upload CAC Certificate'));
      await tester.pump();
      
      // Wait for upload to complete (simulated)
      await tester.pump(const Duration(seconds: 3));
      
      // File should be selected
      expect(selectedFile, isNotNull);
      
      // Tap remove button
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();
      
      // Upload button should be visible again
      expect(find.text('Upload CAC Certificate'), findsOneWidget);
      expect(selectedFile, isNull);
    });
  });
}
