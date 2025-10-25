import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/my_color_scheme.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';

class SelectCountyPage extends StatefulWidget {
  final String? country;
  const SelectCountyPage({super.key, this.country});

  @override
  State<SelectCountyPage> createState() => _SelectCountyPageState();
}

class _SelectCountyPageState extends State<SelectCountyPage> {
  String? selectedOption;

  void onSelectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  onFilter(String value) {
    onSelectOption(value);
    // return _carsCubit.onChangeSelectedCity(value);
  }

  @override
  void initState() {
    initSelectedOption();
    super.initState();
  }

  initSelectedOption() async {
    setState(() {
      selectedOption = widget.country ?? "Germany";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppbar(
          automaticallyImplyLeading: widget.country != null ? true : false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                HWEdgeInsets.only(top: 85, right: 40, left: 40, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SimpleShadow(
                    color: AppColors.black,
                    opacity: 0.15,
                    offset: const Offset(0, 4),
                    sigma: 4,
                    child: AppText(
                      "Choose Country".tr(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.b.withColor(
                        AppColors.white,
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                AppSvgPicture(
                  Assets.svgLocationPin,
                  width: 120.w,
                  alignment: Alignment.center,
                ),
                100.verticalSpace,
                Padding(
                  padding: HWEdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 50.h,
                    width: 626.w,
                    child: _CountryDropdown(
                      onChanged: (v) => onFilter(v!),
                    ),
                  ),
                ),
                65.verticalSpace,
                TextButton(
                  onPressed: () async {
                    if (selectedOption != null) {
                      await GetIt.I<PrefsRepository>()
                          .setSelectedCity(selectedOption!);
                      GRouter.router.goNamed(GRouter.config.mainRoutes.home);
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(Size(250.w, 55.h)),
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 27)),
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.primary),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.r),
                        ),
                      ),
                    ),
                  ),
                  child: AppText(
                    LocaleKeys.ok,
                    style: context.textTheme.bodyLarge.b
                        .withColor(AppColors.white),
                  ),
                ),
                26.horizontalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({required this.onChanged});

  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 87.h,
      width: 400.w,
      child: dropDown(context),
    );
  }

  Widget dropDown(BuildContext context) {
    return AppDropdownSearch<String?>(
      items: const ["Dubie", "Germany"],
      itemAsString: (item) => item!,
      selectedItem: "Dubie",
      onChanged: onChanged,
      dropdownButtonProps: DropdownButtonProps(
        alignment: Alignment.center,
        icon: InkWell(
          onTap: () {},
          child: Icon(Icons.close_rounded,
              size: 17, color: context.colorScheme.grey),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(15.r),
        ),
        itemBuilder: (context, item, isSelected) {
          return Padding(
            padding: HWEdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(item!, style: context.textTheme.labelLarge.m),
                if (isSelected) const Icon(Icons.done_rounded)
              ],
            ),
          );
        },
        searchFieldProps: TextFieldProps(
          style: context.textTheme.bodyMedium.b.withColor(AppColors.blackLight),
          maxLines: 1,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              filled: true,
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
              fillColor: AppColors.grey.shade50,
              border: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Search By Name",
              hintStyle:
                  context.textTheme.titleSmall.m.withColor(AppColors.grey)),
        ),
      ),
      hintText: "Choose County",
      filled: true,
      fillColor: const Color(0xffeff1f9),
      borderColor: Colors.transparent,
      validator: (value) => value == null ? LocaleKeys.required : null,
    );
  }
}
