import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/email_verification_api.dart';

/// EmailVerificationScreen
/// 
/// Screen for verifying user email address after registration.
/// Includes code input, resend functionality, and verification status.
/// 
/// SEARCH TAGS: #email #verification #registration #security
class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerificationComplete;

  const EmailVerificationScreen({
    Key? key, 
    required this.email,
    required this.onVerificationComplete,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6, 
    (_) => TextEditingController()
  );
  final List<FocusNode> _focusNodes = List.generate(
    6, 
    (_) => FocusNode()
  );
  
  bool _isVerifying = false;
  String? _errorMessage;
  bool _isResendingCode = false;
  int _resendCountdown = 0;
  Timer? _resendTimer;
  
  @override
  void initState() {
    super.initState();
    
    // Add listeners to focus nodes for auto-advancing
    for (int i = 0; i < 5; i++) {
      _codeControllers[i].addListener(() {
        if (_codeControllers[i].text.length == 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
    
    // Auto focus first field
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNodes[0].requestFocus();
    });
  }
  
  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }
  
  String get _completeCode {
    return _codeControllers.map((controller) => controller.text).join();
  }
  
  void _startResendCountdown() {
    _resendCountdown = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }
  
  Future<void> _verifyCode() async {
  if (_completeCode.length != 6) {
    setState(() {
      _errorMessage = 'Please enter the complete 6-digit code';
    });
    return;
  }

  setState(() {
    _isVerifying = true;
    _errorMessage = null;
  });

  try {
    final api = EmailVerificationApi();
    final bool isValid = await api.verifyCode(email: widget.email, code: _completeCode);

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        widget.onVerificationComplete();
      });
    } else {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'Invalid verification code. Please try again.';
      });
    }
  } catch (e) {
    setState(() {
      _isVerifying = false;
      _errorMessage = 'Verification failed. Please try again.';
    });
  }
}
  
  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;
    
    setState(() {
      _isResendingCode = true;
      _errorMessage = null;
    });
    
    try {
      // In a real implementation, this would call an API to resend the code
      // For now, we'll simulate a network delay
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isResendingCode = false;
      });
      
      _startResendCountdown();
      
      // Clear existing code fields
      for (var controller in _codeControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code sent to ${widget.email}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      setState(() {
        _isResendingCode = false;
        _errorMessage = 'Failed to resend code. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Icon(
                    Icons.mark_email_unread,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Verify Your Email',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    'We\'ve sent a verification code to:',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Email address
                  Text(
                    widget.email,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  
                  // Code entry fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 48,
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: _codeControllers[index],
                          focusNode: _focusNodes[index],
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                            
                            // If last digit is entered, automatically verify
                            if (index == 5 && value.isNotEmpty) {
                              _verifyCode();
                            }
                          },
                          style: theme.textTheme.headlineSmall,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  
                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Verify button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isVerifying ? null : _verifyCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isVerifying
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Verify Email'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Resend code button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive the code?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 8),
                      _resendCountdown > 0
                          ? Text(
                              'Resend in ${_resendCountdown}s',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : _isResendingCode
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : TextButton(
                                  onPressed: _resendCode,
                                  child: const Text('Resend Code'),
                                ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Helper text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'For testing, use code: 123456',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'In a real application, this would be sent to your email address. For demo purposes, please use the code above.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
