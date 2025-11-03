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
    final ownerId = owner?['id']?.toString() ?? carData['user_id']?.toString();
    if (ownerId == null || ownerId.isEmpty) {
      showMessage('Cannot start chat: seller information not available',
          isSuccess: false);
      return;
    }
    // TODO: تمرير معلومات المالك والسيارة إلى صفحة الشات
    GRouter.router.pushNamed(
      GRouter.config.chatsRoutes.chatPage,
      extra: {
        'seller_id': ownerId,
        'seller_name': sellerName,
        'car_title': carData['title'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (hasUsablePhone)
            Row(
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
