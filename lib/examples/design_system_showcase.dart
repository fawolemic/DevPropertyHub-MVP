import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// A showcase screen demonstrating the Design System components
class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Showcase'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        children: [
          // Typography Section
          _buildSectionTitle(context, 'Typography'),
          Text('Display Large',
              style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Display Medium',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Display Small',
              style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Headline Medium',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Headline Small',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppTheme.spaceSM),
          Text('Body Small', style: Theme.of(context).textTheme.bodySmall),

          const SizedBox(height: AppTheme.spaceXL),

          // Colors Section
          _buildSectionTitle(context, 'Brand Colors'),
          _buildColorRow('Primary Navy', AppTheme.primaryNavy),
          _buildColorRow('Primary Navy Light', AppTheme.primaryNavyLight),
          _buildColorRow('Primary Navy Dark', AppTheme.primaryNavyDark),
          _buildColorRow('Secondary Gold', AppTheme.secondaryGold),
          _buildColorRow('Secondary Gold Light', AppTheme.secondaryGoldLight),
          _buildColorRow('Accent Teal', AppTheme.accentTeal),

          const SizedBox(height: AppTheme.spaceLG),
          _buildSectionTitle(context, 'Status Colors'),
          _buildColorRow('Success', AppTheme.success),
          _buildColorRow('Warning', AppTheme.warning),
          _buildColorRow('Error', AppTheme.error),
          _buildColorRow('Info', AppTheme.info),

          const SizedBox(height: AppTheme.spaceXL),

          // Buttons Section
          _buildSectionTitle(context, 'Buttons'),
          Wrap(
            spacing: AppTheme.spaceMD,
            runSpacing: AppTheme.spaceMD,
            children: [
              ElevatedButton(
                  onPressed: () {}, child: const Text('Primary Button')),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
              ElevatedButton(onPressed: null, child: const Text('Disabled')),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              TextButton(onPressed: () {}, child: const Text('Text Button')),
              ElevatedButton(
                  style: AppTheme.secondaryButtonStyle,
                  onPressed: () {},
                  child: const Text('Secondary')),
            ],
          ),

          const SizedBox(height: AppTheme.spaceXL),

          // Cards Section
          _buildSectionTitle(context, 'Cards'),
          Wrap(
            spacing: AppTheme.spaceLG,
            runSpacing: AppTheme.spaceLG,
            children: [
              _buildCard('Elevation 1', AppTheme.cardElevation1),
              _buildCard('Elevation 2', AppTheme.cardElevation2),
              _buildCard('Elevation 3', AppTheme.cardElevation3),
            ],
          ),

          const SizedBox(height: AppTheme.spaceXL),

          // Form Elements
          _buildSectionTitle(context, 'Form Elements'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMD),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Text Input',
                hintText: 'Enter text here',
                helperText: 'This is a helper text',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMD),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                errorText: 'This field is required',
              ),
              obscureText: true,
            ),
          ),

          const SizedBox(height: AppTheme.spaceXL),

          // Status Indicators
          _buildSectionTitle(context, 'Status Indicators'),
          _buildStatusIndicator('Success Status', Icons.check_circle,
              AppTheme.statusSuccess(), AppTheme.successTextStyle),
          const SizedBox(height: AppTheme.spaceMD),
          _buildStatusIndicator('Warning Status', Icons.warning,
              AppTheme.statusWarning(), AppTheme.warningTextStyle),
          const SizedBox(height: AppTheme.spaceMD),
          _buildStatusIndicator('Error Status', Icons.error,
              AppTheme.statusError(), AppTheme.errorTextStyle),
          const SizedBox(height: AppTheme.spaceMD),
          _buildStatusIndicator('Info Status', Icons.info,
              AppTheme.statusInfo(), AppTheme.infoTextStyle),

          const SizedBox(height: AppTheme.spaceXL),

          // Progress Indicators
          _buildSectionTitle(context, 'Progress Indicators'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Construction Progress (78%)'),
              const SizedBox(height: AppTheme.spaceXS),
              AppTheme.progressIndicator(0.78),
              const SizedBox(height: AppTheme.spaceMD),
              const Text('Sales Progress (65%)'),
              const SizedBox(height: AppTheme.spaceXS),
              AppTheme.progressIndicator(0.65, color: AppTheme.secondaryGold),
            ],
          ),

          const SizedBox(height: AppTheme.spaceXXL),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: AppTheme.spaceXS),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.secondaryGold,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
        ],
      ),
    );
  }

  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMD),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, BoxDecoration decoration) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppTheme.spaceSM),
          const Text('This is a card with the specified elevation level.'),
          const SizedBox(height: AppTheme.spaceMD),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Action'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String text, IconData icon,
      BoxDecoration decoration, TextStyle textStyle) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: decoration,
      child: Row(
        children: [
          Icon(icon, color: textStyle.color, size: 20),
          const SizedBox(width: AppTheme.spaceSM),
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
