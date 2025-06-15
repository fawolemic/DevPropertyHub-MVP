import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

/// TermsAndConditionsCheckbox
///
/// Reusable checkbox component for terms and conditions acceptance.
/// Includes link to full terms document and validation.
///
/// SEARCH TAGS: #auth #terms #checkbox #validation #registration
class TermsAndConditionsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? errorText;
  final String termsUrl;
  final String privacyUrl;

  const TermsAndConditionsCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.termsUrl = 'https://devpropertyhub.com/terms',
    this.privacyUrl = 'https://devpropertyhub.com/privacy',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchUrl(termsUrl);
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchUrl(privacyUrl);
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
