import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

part 'notifications_empty.dart';
part 'favorites_empty.dart';
part 'cars_empty.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;

  factory AppEmptyState.notificationsEmpty({Key? key}) {
    return _NotificationsEmpty(key: key);
  }

  factory AppEmptyState.favoritesEmpty({Key? key}) {
    return _FavoritesEmpty(key: key);
  }
  factory AppEmptyState.foodsEmpty({Key? key}) {
    return _CarsEmpty(key: key);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
