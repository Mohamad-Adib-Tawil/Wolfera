import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_cached_network_image.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/services/ads_service.dart';
import 'package:wolfera/services/supabase_service.dart';

class ManageAdsPage extends StatefulWidget {
  const ManageAdsPage({super.key});

  @override
  State<ManageAdsPage> createState() => _ManageAdsPageState();
}

class _ManageAdsPageState extends State<ManageAdsPage> {
  final _picker = ImagePicker();
  File? _selectedFile;
  DateTime? _startAt;
  DateTime? _endAt;

  bool _loadingList = true;
  bool _creating = false;
  List<Map<String, dynamic>> _ads = const [];

  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    _loadAll();
  }

  Future<void> _loadAll() async {
    try {
      final isSuper = await SupabaseService.isCurrentUserSuperAdmin();
      if (!mounted) return;
      if (!isSuper) {
        setState(() {
          _loadingList = false;
          _ads = const [];
        });
        return;
      }
      final items = await AdsService.fetchAllAds();
      if (!mounted) return;
      setState(() {
        _ads = items;
        _loadingList = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingList = false);
    }
  }

  Future<void> _pickImage() async {
    final x =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (x == null) return;
    setState(() => _selectedFile = File(x.path));
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startAt ?? now,
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(
          () => _startAt = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickEndDate() async {
    final base = _startAt ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endAt ?? base.add(const Duration(days: 7)),
      firstDate: base,
      lastDate: base.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      setState(() =>
          _endAt = DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
    }
  }

  Future<void> _createAd() async {
    if (_selectedFile == null || _startAt == null || _endAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('required'.tr())),
      );
      return;
    }
    if (_endAt!.isBefore(_startAt!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.tr(args: ['end < start']))),
      );
      return;
    }
    setState(() => _creating = true);
    try {
      await AdsService.createAd(
          file: _selectedFile!, startAt: _startAt!, endAt: _endAt!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ad_created'.tr())),
      );
      setState(() {
        _selectedFile = null;
        _startAt = null;
        _endAt = null;
      });
      await _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.tr(args: [e.toString()]))),
      );
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _editDuration(Map<String, dynamic> ad) async {
    DateTime start =
        DateTime.tryParse(ad['start_at']?.toString() ?? '') ?? DateTime.now();
    DateTime end = DateTime.tryParse(ad['end_at']?.toString() ?? '') ??
        start.add(const Duration(days: 7));

    final newStart = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (newStart == null) return;
    if (!mounted) return;
    final newEnd = await showDatePicker(
      context: context,
      initialDate: end,
      firstDate: newStart,
      lastDate: newStart.add(const Duration(days: 365 * 3)),
    );
    if (newEnd == null) return;

    try {
      await AdsService.updateAdDuration(
        adId: ad['id'].toString(),
        startAt: DateTime(newStart.year, newStart.month, newStart.day),
        endAt: DateTime(newEnd.year, newEnd.month, newEnd.day, 23, 59, 59),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ad_updated'.tr())),
      );
      await _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.tr(args: [e.toString()]))),
      );
    }
  }

  Future<void> _deleteAd(String id) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('are_you_sure_delete_ad'.tr()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('cancel'.tr())),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text('delete'.tr())),
            ],
          ),
        ) ??
        false;
    if (!confirm) return;

    try {
      await AdsService.deleteAd(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ad_deleted'.tr())),
      );
      await _loadAll();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error'.tr(args: [e.toString()]))),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat.yMMMd().format(date);
  }

  bool _isActive(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;
    final now = DateTime.now();
    return !now.isBefore(start) && !now.isAfter(end);
  }

  int _daysLeft(DateTime? end) {
    if (end == null) return 0;
    final now = DateTime.now();
    return end.difference(now).inDays;
  }

  Widget _buildMetaChip({
    required IconData icon,
    required String text,
    Color background = const Color(0x22FFFFFF),
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A3843), Color(0xFF2C2B34)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.campaign_rounded,
                      size: 18.sp, color: Colors.white),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'manage_ads'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined, color: Colors.white),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.40)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    label: Text('upload_banner'.tr()),
                  ),
                ),
              ],
            ),
            if (_selectedFile != null) ...[
              SizedBox(height: 12.h),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      _selectedFile!,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: InkWell(
                      onTap: () => setState(() => _selectedFile = null),
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartDate,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.40)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                    ),
                    child: Text(
                      _startAt == null
                          ? 'start_date'.tr()
                          : _formatDate(_startAt),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndDate,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.40)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                    ),
                    child: Text(
                      _endAt == null ? 'end_date'.tr() : _formatDate(_endAt),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _creating ? null : _createAd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: _creating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('create_ad'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdsList() {
    if (_loadingList) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_ads.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Text(
            'no_ads'.tr(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return ListView.separated(
      itemCount: _ads.length,
      padding: EdgeInsets.only(bottom: 8.h),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final ad = _ads[index];
        final url = ad['image_url']?.toString() ?? '';
        final start = DateTime.tryParse(ad['start_at']?.toString() ?? '');
        final end = DateTime.tryParse(ad['end_at']?.toString() ?? '');
        final isActive = _isActive(start, end);
        final daysLeft = _daysLeft(end);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF393743), Color(0xFF292831)],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AppCachedNetworkImageView(
                    url: url,
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildMetaChip(
                      icon: Icons.calendar_month_rounded,
                      text: '${'start_date'.tr()}: ${_formatDate(start)}',
                    ),
                    _buildMetaChip(
                      icon: Icons.event_available_rounded,
                      text: '${'end_date'.tr()}: ${_formatDate(end)}',
                    ),
                    _buildMetaChip(
                      icon: isActive
                          ? Icons.bolt_rounded
                          : Icons.pause_circle_filled_rounded,
                      text: isActive ? 'Active' : 'Expired',
                      background: isActive
                          ? const Color(0x3333CC88)
                          : const Color(0x33FF6B6B),
                    ),
                    _buildMetaChip(
                      icon: Icons.timelapse_rounded,
                      text:
                          daysLeft > 0 ? '$daysLeft days left' : '0 days left',
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _editDuration(ad),
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.white),
                      icon: const Icon(Icons.edit_calendar_outlined, size: 18),
                      label: Text('edit_duration'.tr()),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _deleteAd(ad['id'].toString()),
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: Text('delete'.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.all(14.w),
      child: Column(
        children: [
          _buildCreateCard(),
          SizedBox(height: 12.h),
          Expanded(child: _buildAdsList()),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF222129),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? const DelayedFadeSlide(
                delay: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 1000),
                beginOffset: Offset(0, -0.24),
                child: CustomAppbar(
                  text: 'manage_ads',
                  automaticallyImplyLeading: true,
                ),
              )
            : const CustomAppbar(
                text: 'manage_ads',
                automaticallyImplyLeading: true,
              ),
      ),
      body: _shouldAnimateEntrance
          ? DelayedFadeSlide(
              delay: const Duration(milliseconds: 260),
              duration: const Duration(milliseconds: 1000),
              beginOffset: const Offset(-0.24, 0),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2F2D38), Color(0xFF1F1E25)],
                      ),
                    ),
                  ),
                  content,
                ],
              ),
            )
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2F2D38), Color(0xFF1F1E25)],
                    ),
                  ),
                ),
                content,
              ],
            ),
    );
  }
}
