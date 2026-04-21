import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final bool required;
  const FieldLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDim,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          if (required) ...[
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

InputDecoration _fieldDecoration({String? hint}) {
  OutlineInputBorder border(Color c, {double w = 1}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: w),
      );

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: 15,
      color: AppColors.muted.withValues(alpha: 0.55),
    ),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.04),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: border(AppColors.line),
    enabledBorder: border(AppColors.line),
    focusedBorder: border(AppColors.accent, w: 1.5),
    errorBorder: border(const Color(0xFFFF6B7A)),
    focusedErrorBorder: border(const Color(0xFFFF6B7A), w: 1.5),
    disabledBorder: border(AppColors.line),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: Color(0xFFFF9AA5),
      height: 1.3,
    ),
  );
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final String? autofillHint;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.validator,
    this.autofillHint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, required: required),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: minLines,
          enabled: enabled,
          validator: validator,
          autofillHints: autofillHint != null ? [autofillHint!] : null,
          cursorColor: AppColors.accent,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.text,
            height: 1.5,
          ),
          decoration: _fieldDecoration(hint: hint),
        ),
      ],
    );
  }
}

class AppDropdownField extends StatelessWidget {
  final String? value;
  final String label;
  final String? hint;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool required;
  final bool enabled;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.label,
    required this.options,
    required this.onChanged,
    this.hint,
    this.required = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label: label, required: required),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: hint != null
                  ? Text(
                      hint!,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.muted.withValues(alpha: 0.55),
                      ),
                    )
                  : null,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(fontSize: 15, color: AppColors.text),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.muted,
                size: 22,
              ),
              onChanged: enabled ? onChanged : null,
              items: options
                  .map(
                    (o) => DropdownMenuItem<String>(
                      value: o,
                      child: Text(o),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
