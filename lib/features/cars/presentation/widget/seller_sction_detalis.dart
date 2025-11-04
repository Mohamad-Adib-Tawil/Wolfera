import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/cars/presentation/widget/contect_button.dart';
import 'package:wolfera/features/cars/presentation/widget/user_section_with_location.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/features/app/presentation/widgets/shimmer_loading.dart';

class SellerSctionDetalis extends StatelessWidget {
  final Map<String, dynamic> carData;

  const SellerSctionDetalis({
    super.key,
    required this.carData,
  });

  // استخراج بيانات المالك
  Map<String, dynamic>? get owner => carData['owner'] as Map<String, dynamic>?;

  String? get phoneNumber =>
      owner?['phone_number']?.toString() ??
      owner?['phone']?.toString() ??
      carData['phone_number']?.toString();
  String? get email =>
      owner?['email']?.toString() ?? carData['email']?.toString();
  String get sellerName =>
      owner?['full_name']?.toString() ??
      owner?['display_name']?.toString() ??
      owner?['name']?.toString() ??
      carData['seller_name']?.toString() ??
      'Seller';

  // التحقق من صلاحية رقم الهاتف وعدم كونه رقمًا افتراضيًا
  bool get hasUsablePhone {
    final p = phoneNumber?.trim();
    if (p == null || p.isEmpty) return false;
    final digits = p.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.length < 7) return false; // حد أدنى لطول الرقم
    const banned = {
      '+963900000000',
      '+0000000000',
      '0000000000',
      '000000',
      '123456',
    };
    return !banned.contains(digits);
  }

  // وظيفة الاتصال بالهاتف
  Future<void> _makePhoneCall() async {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      showMessage('Phone number not available', isSuccess: false);
      return;
    }
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      showMessage('Could not launch phone dialer', isSuccess: false);
    }
  }

  // وظيفة فتح واتساب
  Future<void> _openWhatsApp() async {
    if (!hasUsablePhone) {
      showMessage('Phone number not available', isSuccess: false);
      return;
    }
    // إزالة الرموز والمسافات من رقم الهاتف
    final cleanPhone = phoneNumber!.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      showMessage('Could not open WhatsApp', isSuccess: false);
    }
  }

  // وظيفة إرسال رسالة نصية SMS
  Future<void> _sendSms() async {
    if (!hasUsablePhone) {
      showMessage('Phone number not available', isSuccess: false);
      return;
    }
    final cleanPhone = phoneNumber!.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri smsUri = Uri(scheme: 'sms', path: cleanPhone);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    } else {
      showMessage('Could not open SMS app', isSuccess: false);
    }
  }

  // وظيفة فتح الشات الداخلي
  void _openInAppChat(BuildContext context) {
    // Prefer Supabase user_id from carData; then try owner.user_id; then owner.id (if looks like uuid)
    String? sellerId = carData['user_id']?.toString();
    sellerId ??= owner?['user_id']?.toString();
    final rawOwnerId = owner?['id']?.toString();
    if (sellerId == null && rawOwnerId != null && rawOwnerId.contains('-')) {
      sellerId = rawOwnerId; // likely a UUID
    }

    if (sellerId == null || sellerId.isEmpty) {
      showMessage('Cannot start chat: seller information not available',
          isSuccess: false);
      return;
    }
    // استنتاج صورة البائع
    final sellerAvatar = owner == null
        ? null
        : (owner!['avatar_url'] ?? owner!['photo_url'] ?? owner!['picture'])
            ?.toString();

    // تمرير معلومات المالك والسيارة إلى صفحة الشات
    GRouter.router.pushNamed(
      GRouter.config.chatsRoutes.chatPage,
      extra: {
        'seller_id': sellerId,
        'seller_name': sellerName,
        'seller_avatar': sellerAvatar,
        'car_id': carData['id']?.toString(),
        'car_title': carData['title']?.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool loadingOwner = owner == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Seller',
            style: context.textTheme.bodyLarge!.s17.b.withColor(AppColors.grey),
          ),
          14.verticalSpace,
          UserSectionWithLocation(carData: carData),
          29.verticalSpace,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeOutCubic,
            transitionBuilder: (child, animation) {
              final offset = Tween<Offset>(
                begin: const Offset(0.12, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offset, child: child),
              );
            },
            child: loadingOwner
                ? const _ContactButtonsSkeleton(key: ValueKey('skel-contact'))
                : hasUsablePhone
                    ? Row(
                        key: const ValueKey('real-contact'),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _makePhoneCall,
                              child: const ContectButton(
                                  svg: Assets.svgPhone, title: 'Call'),
                            ),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: GestureDetector(
                              onTap: _openWhatsApp,
                              child: const ContectButton(
                                  svg: Assets.svgWhatsapp, title: 'Chat'),
                            ),
                          ),
                          8.horizontalSpace,
                          Expanded(
                            child: GestureDetector(
                              onTap: _sendSms,
                              child: const ContectButton(
                                  svg: Assets.svgMessageSquare, title: 'SMS'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
          ),
          18.verticalSpace,
          GestureDetector(
            onTap: () => _openInAppChat(context),
            child: ContectButton(
              textWidth: 260.w,
              svg: Assets.svgMessageSquare,
              title: 'Send Message to $sellerName',
            ),
          ),
          15.verticalSpace,
          CustomDivider(color: AppColors.grey, thickness: 1.r),
          10.verticalSpace,
        ],
      ),
    );
  }
}

class _ContactButtonsSkeleton extends StatelessWidget {
  const _ContactButtonsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      linearGradient: LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0.08),
          AppColors.primary.withOpacity(0.16),
          AppColors.primary.withOpacity(0.08),
        ],
        stops: const [0.1, 0.3, 0.4],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buttonBar()),
          8.horizontalSpace,
          Expanded(child: _buttonBar()),
          8.horizontalSpace,
          Expanded(child: _buttonBar()),
        ],
      ),
    );
  }

  Widget _buttonBar() {
    return const ShimmerLoading(
      isLoading: true,
      child: _ButtonSkeleton(),
    );
  }
}

class _ButtonSkeleton extends StatelessWidget {
  const _ButtonSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.only(left: 18, top: 10, bottom: 10, right: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 4,
            color: AppColors.black.withValues(alpha: 0.18),
          ),
        ],
      ),
      child: Row(
        children: [
          // دائرة لأيقونة الاتصال
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.greyStroke.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
          ),
          10.horizontalSpace,
          // شريط يمثل النص
          Expanded(
            child: Container(
              height: 14.h,
              decoration: BoxDecoration(
                color: AppColors.greyStroke.withOpacity(0.35),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
