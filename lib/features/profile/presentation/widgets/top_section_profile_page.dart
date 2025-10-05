import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';

class TopSectionProfilePage extends StatelessWidget {
  const TopSectionProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppManagerCubit, AppManagerState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            20.verticalSpace,
            CirclueUserImageWidget(
              width: 90,
              height: 90,
              userImage: state.user?.photoURL,
            ),
            20.verticalSpace,
            AppText(
              state.user?.displayName ?? 'User',
              style: context.textTheme.bodyLarge!.s25.xb
                  .withColor(AppColors.white),
            ),
            10.verticalSpace,
            AppText(
              state.user?.email ?? 'Email',
              style:
                  context.textTheme.bodyLarge!.s18.withColor(AppColors.white),
            ),
            10.verticalSpace,
            CustomDivider(
              thickness: 0.5.r,
              endIndent: 0,
              indent: 0,
            ),
          ],
        );
      },
    );
  }
}
