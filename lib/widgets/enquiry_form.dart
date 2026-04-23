import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import 'form_fields.dart';
import 'primary_button.dart';

/// Endpoint for form submissions. Replace with your Formspree endpoint
/// (sign up at https://formspree.io — free tier is 50 submissions/month).
/// When empty, the form falls back to opening the visitor's email client
/// with a prefilled message, so it still works before you wire up a backend.
const String kFormspreeEndpoint = 'https://formspree.io/f/xaqaljpo';

const String _contactEmail = 'alex@poseidonapps.net';

enum _FormStatus { idle, submitting, success, error }

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({super.key});

  @override
  State<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _company = TextEditingController();
  final _message = TextEditingController();

  String? _projectType;
  String? _timeline;
  String? _budget;

  _FormStatus _status = _FormStatus.idle;
  bool _usedMailtoFallback = false;
  String? _errorMessage;

  static const _projectTypes = [
    'Website',
    'Mobile app',
    'Workflow automation',
    'A mix of the above',
    'Not sure yet',
  ];
  static const _timelines = [
    'ASAP',
    '1–3 months',
    '3–6 months',
    'Flexible',
  ];
  static const _budgets = [
    'Under £5k',
    '£5k–£15k',
    '£15k–£50k',
    '£50k+',
    'Not sure yet',
  ];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _company.dispose();
    _message.dispose();
    super.dispose();
  }

  String? _required(String? v, {int min = 2}) {
    if (v == null || v.trim().isEmpty) return 'Please fill in this field';
    if (v.trim().length < min) return 'A bit more detail please';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(v.trim())) return "That email doesn't look right";
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _status = _FormStatus.submitting;
      _errorMessage = null;
    });

    final payload = <String, String>{
      'name': _name.text.trim(),
      'email': _email.text.trim(),
      'company': _company.text.trim(),
      'projectType': _projectType ?? '',
      'timeline': _timeline ?? '',
      'budget': _budget ?? '',
      'message': _message.text.trim(),
    };

    if (kFormspreeEndpoint.isEmpty) {
      await _openMailtoFallback(payload);
      if (!mounted) return;
      setState(() {
        _status = _FormStatus.success;
        _usedMailtoFallback = true;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(kFormspreeEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );
      if (!mounted) return;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          _status = _FormStatus.success;
          _usedMailtoFallback = false;
        });
      } else {
        setState(() {
          _status = _FormStatus.error;
          _errorMessage =
              'Something went wrong (status ${response.statusCode}). Please email us at $_contactEmail.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = _FormStatus.error;
        _errorMessage =
            "We couldn't reach the server. Please email us at $_contactEmail instead.";
      });
    }
  }

  Future<void> _openMailtoFallback(Map<String, String> p) async {
    final subject = Uri.encodeComponent(
      'New enquiry from ${p["name"]!.isEmpty ? "website" : p["name"]}',
    );
    final body = Uri.encodeComponent(
      'Name: ${p['name']}\n'
      'Email: ${p['email']}\n'
      'Company: ${p['company']}\n'
      'Project type: ${p['projectType']}\n'
      'Timeline: ${p['timeline']}\n'
      'Budget: ${p['budget']}\n\n'
      'Message:\n${p['message']}\n',
    );
    await launchUrl(
      Uri.parse('mailto:$_contactEmail?subject=$subject&body=$body'),
    );
  }

  void _reset() {
    _name.clear();
    _email.clear();
    _company.clear();
    _message.clear();
    setState(() {
      _projectType = null;
      _timeline = null;
      _budget = null;
      _status = _FormStatus.idle;
      _errorMessage = null;
      _usedMailtoFallback = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_status == _FormStatus.success) {
      return _SuccessCard(
        onReset: _reset,
        viaMailto: _usedMailtoFallback,
      );
    }

    final disabled = _status == _FormStatus.submitting;
    final isWide = MediaQuery.sizeOf(context).width > 640;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(isWide ? 36 : 24),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_status == _FormStatus.error && _errorMessage != null)
                  _ErrorBanner(message: _errorMessage!),
                _row(isWide, [
                  AppTextField(
                    controller: _name,
                    label: 'Name',
                    hint: 'Your name',
                    required: true,
                    enabled: !disabled,
                    autofillHint: AutofillHints.name,
                    validator: (v) => _required(v, min: 2),
                  ),
                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    hint: 'you@company.com',
                    required: true,
                    enabled: !disabled,
                    keyboardType: TextInputType.emailAddress,
                    autofillHint: AutofillHints.email,
                    validator: _validateEmail,
                  ),
                ]),
                const SizedBox(height: 16),
                _row(isWide, [
                  AppTextField(
                    controller: _company,
                    label: 'Company',
                    hint: 'Optional',
                    enabled: !disabled,
                    autofillHint: AutofillHints.organizationName,
                  ),
                  AppDropdownField(
                    label: 'Project type',
                    value: _projectType,
                    options: _projectTypes,
                    hint: 'What are you building?',
                    enabled: !disabled,
                    onChanged: (v) => setState(() => _projectType = v),
                  ),
                ]),
                const SizedBox(height: 16),
                _row(isWide, [
                  AppDropdownField(
                    label: 'Timeline',
                    value: _timeline,
                    options: _timelines,
                    hint: 'When do you want to start?',
                    enabled: !disabled,
                    onChanged: (v) => setState(() => _timeline = v),
                  ),
                  AppDropdownField(
                    label: 'Budget',
                    value: _budget,
                    options: _budgets,
                    hint: 'Ballpark',
                    enabled: !disabled,
                    onChanged: (v) => setState(() => _budget = v),
                  ),
                ]),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _message,
                  label: 'Tell us about your project',
                  hint: 'A few lines on what you want to build, the problems '
                      "you're hoping to solve, and anything else we should know.",
                  required: true,
                  minLines: 5,
                  maxLines: 10,
                  enabled: !disabled,
                  validator: (v) => _required(v, min: 10),
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, c) {
                    final horizontal = c.maxWidth > 460;
                    const note = Text(
                      "We'll reply within one business day.",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.muted,
                      ),
                    );
                    final button = _SubmitButton(
                      onPressed: disabled ? null : _submit,
                      loading: disabled,
                    );
                    if (horizontal) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(child: note),
                          const SizedBox(width: 16),
                          button,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        button,
                        const SizedBox(height: 14),
                        const Center(child: note),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(bool isWide, List<Widget> children) {
    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            children[i],
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  const _SubmitButton({required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA8F2FF), Color(0xFF7EE8FA), Color(0xFFB39CF5)],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.bg),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'Sending…',
              style: TextStyle(
                color: AppColors.bg,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      );
    }
    return AppButton(
      label: 'Send enquiry',
      large: true,
      onPressed: onPressed,
      trailingIcon: Icons.arrow_forward_rounded,
    );
  }
}

class _SuccessCard extends StatelessWidget {
  final VoidCallback onReset;
  final bool viaMailto;
  const _SuccessCard({required this.onReset, this.viaMailto = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFA8F2FF), Color(0xFFB39CF5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.45),
                    blurRadius: 28,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.bg,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              viaMailto
                  ? 'Almost there — check your email.'
                  : 'Thanks — we got your enquiry.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              viaMailto
                  ? 'Your email client should have opened with the enquiry pre-filled. Review it and hit Send — we\'ll reply within one business day.'
                  : "We'll be in touch within one business day. In the meantime, feel free to reply to our confirmation email with anything else.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textDim,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Send another',
              variant: ButtonVariant.secondary,
              onPressed: onReset,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B7A).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFFF6B7A).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF9AA5),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFFFFC6CD),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
