import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/auth/presentation/widgets/custom_textfeild.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/features/profile/presentation/manager/profile_bloc.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late AppManagerCubit blocApp;
  late ProfileBloc _profileCubit;

  @override
  void initState() {
    blocApp = GetIt.I<AppManagerCubit>();
    _profileCubit = GetIt.I<ProfileBloc>();
    initProfileFormGroup();
    super.initState();
  }

  void initProfileFormGroup() {
    _profileCubit.profileForm = FormGroup(
      {
        _profileCubit.kFromName:
            FormControl<String>(value: blocApp.state.user?.displayName),
        _profileCubit.kFromEmail: FormControl<String>(
            validators: [Validators.email], value: blocApp.state.user?.email),
        _profileCubit.kFromPhone:
            FormControl<String>(value: blocApp.state.user?.phoneNumber),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _profileCubit,
      child: SafeArea(
        top: false,
        child: ReactiveForm(
          formGroup: _profileCubit.profileForm,
          child: Scaffold(
            appBar: const CustomAppbar(
              text: LocaleKeys.editProfile,
              automaticallyImplyLeading: true,
            ),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    Positioned.fill(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: HWEdgeInsets.only(top: 150),
                            child: SingleChildScrollView(
                              padding: HWEdgeInsets.symmetric(horizontal: 33),
                              child: Column(
                                children: [
                                  65.verticalSpace,
                                  const CustomTextField(
                                    hint: LocaleKeys.ProfileDetials_fullName,
                                    formControlName: 'name',
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: AppSvgPicture(
                                      Assets.svgPerson,
                                    ),
                                  ),
                                  30.verticalSpace,
                                  const CustomTextField(
                                    hint: LocaleKeys.ProfileDetials_email,
                                    formControlName: 'email',
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: AppSvgPicture(
                                      Assets.svgEmail,
                                    ),
                                  ),
                                  30.verticalSpace,
                                  CustomTextField(
                                    hint: LocaleKeys.enterPhoneHint,
                                    formControlName: _profileCubit.kFromPhone,
                                    textInputAction: TextInputAction.done,
                                    prefixIcon: const AppSvgPicture(
                                      Assets.svgPhone,
                                    ),
                                  ),
                                  80.verticalSpace,
                                  AppElevatedButton(
                                    text: LocaleKeys.saveChanges,
                                    isLoading:
                                        state.updateProfileStatus.isLoading(),
                                    onPressed: () {
                                      _profileCubit.add(UpdateProfile());
                                    },
                                    textStyle: context
                                        .textTheme.labelMedium.s18.b
                                        .withColor(AppColors.blackLight),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            53.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10).r)),
                                  ),
                                  30.verticalSpace,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 30.h,
                      width: 1.sw,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 120.h,
                          width: 120.w,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: state.selectedFile != null
                                    ? ClipOval(
                                        child: Image.file(
                                          state.selectedFile!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : CirclueUserImageWidget(
                                        userImage:
                                            blocApp.state.user?.photoURL),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        title: AppText(LocaleKeys.photoOptions,
                                            style: context.textTheme.bodyLarge.b
                                                .withColor(AppColors.white)),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: AppText(
                                              LocaleKeys
                                                  .chooseAnImageFromTheGallery,
                                              style: context
                                                  .textTheme.bodyLarge.b
                                                  .withColor(AppColors.white),
                                            ),
                                            onPressed: () {
                                              pickImage(
                                                  source: ImageSource.gallery);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: AppText(
                                              LocaleKeys
                                                  .takePictureFromTheCamera,
                                              style: context
                                                  .textTheme.bodyLarge.b
                                                  .withColor(AppColors.white),
                                            ),
                                            onPressed: () {
                                              pickImage(
                                                  source: ImageSource.camera);
                                            },
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          isDestructiveAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child:
                                              const AppText(LocaleKeys.cancel),
                                        ),
                                      );
                                    },
                                  ),
                                  child: Container(
                                    margin:
                                        HWEdgeInsets.only(right: 5, bottom: 5),
                                    padding: HWEdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: AppColors.white,
                                    ),
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.blackLight,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  pickImage({
    required ImageSource source,
  }) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file == null) return;

    if (mounted) {
      Navigator.pop(context);
    }

    _profileCubit.add(ChangeProfileImage(file: File(file.path)));
  }
}
