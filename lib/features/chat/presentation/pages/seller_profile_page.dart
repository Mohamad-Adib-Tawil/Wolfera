import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({
    super.key,
    required this.sellerId,
    this.sellerName,
    this.sellerAvatar,
  });

  final String sellerId;
  final String? sellerName;
  final String? sellerAvatar;

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final _client = Supabase.instance.client;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _cars = const [];

  @override
  void initState() {
    super.initState();
    // ابدأ الجلب بعد الإطار الأول لتحسين الانطباع البصري
    Future.microtask(() => _fetchCars());
  }

  Future<void> _fetchCars() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _client
          .from('cars')
          .select('*')
          .eq('user_id', widget.sellerId)
          .order('created_at', ascending: false);
      setState(() {
        _cars = List<Map<String, dynamic>>.from(data);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'failed_to_load_seller_cars'.tr();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppbar(
        otherUserName: widget.sellerName ?? 'Seller',
        carTitle: null,
        otherUserAvatar: widget.sellerAvatar,
      ),
      body: _loading
          ? const Center(child: AppLoader())
          : _error != null
              ? Center(
                  child: AppText(
                    _error!,
                    style: context.textTheme.bodyLarge!.s15
                        .withColor(AppColors.grey),
                    translation: false,
                  ),
                )
              : _cars.isEmpty
                  ? Center(
                      child: AppText(
                        'no_cars_for_sale'.tr(),
                        style: context.textTheme.bodyLarge!.s15
                            .withColor(AppColors.grey),
                        translation: false,
                      ),
                    )
                  : CarsListViewBuilder(
                      scrollDirection: Axis.vertical,
                      padding: HWEdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      cars: _cars,
                    ),
    );
  }
}

