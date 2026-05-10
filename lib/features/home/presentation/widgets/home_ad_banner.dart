import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wolfera/features/app/presentation/widgets/app_cached_network_image.dart';
import 'package:wolfera/services/ads_service.dart';

class HomeAdBanner extends StatefulWidget {
  const HomeAdBanner({
    super.key,
    this.refreshToken = 0,
    this.onRegisterReload,
    this.onPresenceChanged,
  });

  final int refreshToken;
  final void Function(Future<void> Function())? onRegisterReload;
  final void Function(bool hasAds)? onPresenceChanged;

  @override
  State<HomeAdBanner> createState() => _HomeAdBannerState();
}

class _HomeAdBannerState extends State<HomeAdBanner> {
  int _activeIndex = 0;
  List<Map<String, dynamic>> _ads = const [];

  @override
  void initState() {
    super.initState();
    // Expose a reload handle to parent once mounted
    widget.onRegisterReload?.call(_reload);
    _load();
  }

  @override
  void didUpdateWidget(covariant HomeAdBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshToken != widget.refreshToken) {
      setState(() {
        _activeIndex = 0;
      });
      _load();
    }
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() {
      _activeIndex = 0;
    });
    await _load();
  }

  Future<void> _load() async {
    try {
      final res = await AdsService.fetchActiveAds();
      if (!mounted) return;
      setState(() {
        _ads = res;
      });
      // notify parent if ads presence changed
      widget.onPresenceChanged?.call(_ads.isNotEmpty);
    } catch (_) {
      if (!mounted) return;
      // Keep previous UI; do not alter layout when load fails
    }
  }

  Future<void> _openAdLink(String? value) async {
    final link = value?.trim() ?? '';
    if (link.isEmpty) return;

    final uri = _parseExternalUri(link);
    if (uri == null) return;

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((_) => false);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('open_ad_link_failed'.tr())),
      );
    }
  }

  Uri? _parseExternalUri(String link) {
    final parsed = Uri.tryParse(link);
    if (parsed == null) return null;
    if (parsed.hasScheme) return parsed;

    return Uri.tryParse('https://$link');
  }

  @override
  Widget build(BuildContext context) {
    // If there are no ads yet (initial load or empty), occupy zero height
    if (_ads.isEmpty) return const SizedBox.shrink();
    // While reloading with existing ads, keep showing current content (no layout jump)

    return Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 14.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 160.h,
              width: double.infinity,
              child: Swiper(
                itemCount: _ads.length,
                autoplay: _ads.length > 1,
                loop: _ads.length > 1,
                autoplayDelay: 5000,
                viewportFraction: 1.0,
                onIndexChanged: (index) => setState(() => _activeIndex = index),
                itemBuilder: (context, index) {
                  final ad = _ads[index];
                  final url = ad['image_url']?.toString() ?? '';
                  final linkUrl = ad['link_url']?.toString();
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _openAdLink(linkUrl),
                    child: AppCachedNetworkImageView(
                      url: url,
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 8.h,
              child: AnimatedSmoothIndicator(
                activeIndex: _activeIndex,
                count: _ads.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.white.withValues(alpha: 0.45),
                  activeDotColor: Colors.white,
                  dotHeight: 6.h,
                  dotWidth: 6.w,
                  expansionFactor: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
