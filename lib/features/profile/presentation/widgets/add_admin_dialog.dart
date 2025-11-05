import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/services/supabase_service.dart';

class AddAdminDialog extends StatefulWidget {
  const AddAdminDialog({super.key});

  @override
  State<AddAdminDialog> createState() => _AddAdminDialogState();
}

class _AddAdminDialogState extends State<AddAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    if (!emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final email = _controller.text.trim();
      await SupabaseService.promoteUserToAdminByEmail(email);
      if (mounted) {
        showMessage('Admin added successfully', isSuccess: true);
        Navigator.of(context).pop();
      }
    } catch (e) {
      showMessage(e.toString(), isSuccess: false);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.92, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) {
          return Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: t,
              child: child,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.blackLight,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.18), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 24.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                height: 64.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.orange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                  ),
                ),
                child: Row(
                  children: [
                    16.horizontalSpace,
                    Container(
                      height: 36.r,
                      width: 36.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white),
                    ),
                    12.horizontalSpace,
                    const Expanded(
                      child: AppText(
                        'Add Admin',
                        translation: false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: HWEdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppText(
                      'Grant admin access to a user by email',
                      translation: false,
                    ),
                    12.verticalSpace,

                    // Form
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _controller,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'User Email',
                          prefixIcon: const Icon(Icons.email_rounded, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.06),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          contentPadding: HWEdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                        validator: _validateEmail,
                      ),
                    ),

                    16.verticalSpace,
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: HWEdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: _submitting ? null : () {
                          FocusScope.of(context).unfocus();
                          _submit();
                        },
                        child: _submitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const AppText(
                                'Promote to Admin',
                                translation: false,
                              ),
                      ),
                    ),

                    10.verticalSpace,
                    Opacity(
                      opacity: 0.8,
                      child: const AppText(
                        'Note: The user must already exist in the system. Only super admins can perform this action.',
                        translation: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
