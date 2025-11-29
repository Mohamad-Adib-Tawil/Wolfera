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
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
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
      setState(() => _startAt = DateTime(picked.year, picked.month, picked.day));
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
      setState(() => _endAt = DateTime(picked.year, picked.month, picked.day, 23, 59, 59));
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
      await AdsService.createAd(file: _selectedFile!, startAt: _startAt!, endAt: _endAt!);
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
    DateTime start = DateTime.tryParse(ad['start_at']?.toString() ?? '') ?? DateTime.now();
    DateTime end = DateTime.tryParse(ad['end_at']?.toString() ?? '') ?? start.add(const Duration(days: 7));

    final newStart = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (newStart == null) return;
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
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('cancel'.tr())),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('delete'.tr())),
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

  Widget _buildCreateCard() {
    return Card(
      color: AppColors.blackLight.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('manage_ads'.tr(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined),
                    label: Text('upload_banner'.tr()),
                  ),
                ),
              ],
            ),
            if (_selectedFile != null) ...[
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.file(_selectedFile!, height: 140.h, width: double.infinity, fit: BoxFit.cover),
              ),
            ],
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickStartDate,
                    child: Text(_startAt == null
                        ? 'start_date'.tr()
                        : DateFormat.yMMMd().format(_startAt!)),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _pickEndDate,
                    child: Text(_endAt == null
                        ? 'end_date'.tr()
                        : DateFormat.yMMMd().format(_endAt!)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _creating ? null : _createAd,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: _creating
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
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
      return const Center(child: CircularProgressIndicator());
    }
    if (_ads.isEmpty) {
      return Center(
        child: Text('no_ads'.tr(), style: const TextStyle(color: Colors.white70)),
      );
    }
    return ListView.separated(
      itemCount: _ads.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final ad = _ads[index];
        final url = ad['image_url']?.toString() ?? '';
        final start = DateTime.tryParse(ad['start_at']?.toString() ?? '');
        final end = DateTime.tryParse(ad['end_at']?.toString() ?? '');
        return Container(
          decoration: BoxDecoration(
            color: AppColors.blackLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: AppCachedNetworkImageView(
                    url: url,
                    width: 100.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'start_date'.tr()}: ${start == null ? '-' : DateFormat.yMMMd().format(start)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${'end_date'.tr()}: ${end == null ? '-' : DateFormat.yMMMd().format(end)}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => _editDuration(ad),
                            child: Text('edit_duration'.tr()),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => _deleteAd(ad['id'].toString()),
                            child: Text('delete'.tr(), style: const TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    ],
                  ),
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
      backgroundColor: AppColors.blackLight,
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
              child: content,
            )
          : content,
    );
  }
}
