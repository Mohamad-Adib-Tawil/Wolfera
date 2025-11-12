import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wolfera/features/auth/presentation/widgets/add_phone_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/profile/domain/use_cases/update_profile.dart';

class AddPhoneNumberPage extends StatefulWidget {
  final User user;
  
  const AddPhoneNumberPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AddPhoneNumberPage> createState() => _AddPhoneNumberPageState();
}

class _AddPhoneNumberPageState extends State<AddPhoneNumberPage> {
  final _form = FormGroup({
    'country_code': FormControl<String>(value: '+971'),
    'phone': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.maxLength(15),
      ],
    ),
  });

  bool _isLoading = false;
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ReactiveForm(
        formGroup: _form,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _shouldAnimateEntrance
                ? DelayedFadeSlide(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 1000),
                    beginOffset: const Offset(0, -0.24),
                    child: CustomAppbar(
                      text: 'add_phone_number',
                      automaticallyImplyLeading: true,
                    ),
                  )
                : CustomAppbar(
                    text: 'add_phone_number',
                    automaticallyImplyLeading: true,
                  ),
          ),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomButtons(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final stack = Stack(
      children: [
        Positioned.fill(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: HWEdgeInsets.symmetric(horizontal: 33),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      30.verticalSpace,
                      AppText(
                        'add_phone_description',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      50.verticalSpace,
                      AddPhoneTextField(
                        controlName: 'phone',
                        onCountrySelect: (country) {
                          _form.control('country_code').value = '+${country.phoneCode}';
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return _shouldAnimateEntrance
        ? DelayedFadeSlide(
            delay: const Duration(milliseconds: 240),
            duration: const Duration(milliseconds: 1000),
            beginOffset: const Offset(-0.24, 0),
            child: stack,
          )
        : stack;
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 33, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppElevatedButton(
            text: 'save',
            isLoading: _isLoading,
            onPressed: _savePhoneNumber,
            textStyle: context.textTheme.labelMedium?.s18?.b
                ?.withColor(AppColors.blackLight),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              minimumSize: Size(MediaQuery.of(context).size.width, 56.h),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10).r,
              ),
            ),
          ),
          16.verticalSpace,
          TextButton(
            onPressed: _skipPhoneNumber,
            child: Text(
              'skip'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePhoneNumber() async {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Build phone like profile screen: +<countryCode><number> and drop leading 0
      final rawCode = (_form.control('country_code').value as String?)?.trim() ?? '';
      final numericCode = rawCode.replaceAll('+', '').trim();
      var phoneLocal = (_form.control('phone').value as String).trim();
      if (phoneLocal.startsWith('0')) {
        phoneLocal = phoneLocal.substring(1);
      }
      final fullPhoneNumber = '+$numericCode$phoneLocal';

      // Use same flow as profile screen via UpdateProfileUsecase
      final updateProfileUsecase = GetIt.I<UpdateProfileUsecase>();
      final res = await updateProfileUsecase(
        UpdateProfileParams(phoneNumber: fullPhoneNumber),
      );

      await res.fold(
        (exception, message) async {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? 'error_saving_phone'.tr())),
            );
          }
        },
        (user) async {
          // Update phone in local storage (prefs) through AuthBloc
          final authBloc = context.read<AuthBloc>();
          authBloc.add(UpdateUserPhoneEvent(phoneNumber: fullPhoneNumber));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('phone_saved_successfully'.tr())),
            );
            context.go('/');
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error_saving_phone'.tr())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _skipPhoneNumber() {
    // Just navigate to home page
    context.go('/');
  }
}
