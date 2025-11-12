part of 'sell_my_car_page.dart';

class _AddCarImagesPage extends StatefulWidget {
  const _AddCarImagesPage();

  @override
  State<_AddCarImagesPage> createState() => _AddCarImagesPageState();
}

class _AddCarImagesPageState extends State<_AddCarImagesPage> {
  late MyCarsBloc _myCarsBloc;

  @override
  void initState() {
    _myCarsBloc = GetIt.I<MyCarsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCarsBloc, MyCarsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: ReactiveForm(
            formGroup: _myCarsBloc.imagesSectionForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: HWEdgeInsetsDirectional.only(start: 20, top: 10),
                  child: AppText(
                    'upload_photos',
                    style: context.textTheme.bodyMedium?.r.s20
                        .withColor(AppColors.grey),
                  ),
                ),
                30.verticalSpace,
                _buildImageGrid(),
                40.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGrid() {
    final controls = _myCarsBloc.imagesSectionForm.controls.entries.toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 2 / 1.6,
      ),
      itemCount:
          controls.length + 1 < 9 ? controls.length + 1 : controls.length,
      itemBuilder: (context, index) {
        if (index == controls.length) {
          return CarAddImageItemEmptyOptional(
            onAddImage: () {
              setState(() {
                _myCarsBloc.add(AddOptionalImageEvent());
              });
            },
          );
        }
        final entry = controls[index];
        return CarAddImageItem(
          text: _getLabelForControl(entry.key),
          formControlName: entry.key,
        );
      },
    );
  }

  String _getLabelForControl(String controlName) {
    switch (controlName) {
      case 'carImageFullRight':
        return 'car_parts.full_right';
      case 'carImageFullLeft':
        return 'car_parts.full_left';
      case 'carImageRear':
        return 'car_parts.full_back';
      case 'carImageFront':
        return 'car_parts.front_seats';
      case 'carImageDashboard':
        return 'car_parts.dashboard';
      default:
        return 'car_parts.optional_image';
    }
  }
}
