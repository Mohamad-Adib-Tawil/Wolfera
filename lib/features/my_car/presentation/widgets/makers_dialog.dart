import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_dialog_search_bar.dart';
import 'package:wolfera/features/my_car/presentation/widgets/car_logo_sliver_grid.dart';
import 'package:wolfera/features/my_car/presentation/widgets/makers_list_tile_list_view.dart';
import 'package:wolfera/services/car_maker_filter_service.dart';

class CarsMakersDialog extends StatefulWidget {
  final bool isMultiSelect;
  final List<CarMaker> selectedCarMakers;
  final Function(dynamic) onSelectionConfirmed;

  const CarsMakersDialog({
    Key? key,
    this.isMultiSelect = false,
    required this.onSelectionConfirmed,
    this.selectedCarMakers = const [],
  }) : super(key: key);

  @override
  State<CarsMakersDialog> createState() => _CarsMakersDialogState();
}

class _CarsMakersDialogState extends State<CarsMakersDialog> {
  final TextEditingController _searchController = TextEditingController();
  final CarMakerFilterService _filterService = CarMakerFilterService();
  List<CarMaker> _filteredCarMakers = List.from(CarMaker.values);
  List<CarMaker> _selectedCarMakers = [];
  @override
  void initState() {
    super.initState();
    _filteredCarMakers = _filterService.filterCarMakers("", _filteredCarMakers);
    setState(() {
      _selectedCarMakers = widget.selectedCarMakers;
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredCarMakers = _filterService.filterCarMakers(
          _searchController.text, CarMaker.values);
    });
  }

  void _onMakerSelected(CarMaker maker) {
    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedCarMakers.contains(maker)) {
          _selectedCarMakers.remove(maker);
        } else {
          _selectedCarMakers.add(maker);
        }
      } else {
        _selectedCarMakers = [maker];
      }
    });
  }

  void _onConfirmSelection() {
    if (widget.isMultiSelect) {
      widget.onSelectionConfirmed(_selectedCarMakers);
    } else {
      widget.onSelectionConfirmed(
          _selectedCarMakers.isNotEmpty ? _selectedCarMakers.first : null);
    }
    Navigator.of(context).pop();
  }

  void _onReset() {
    if (widget.isMultiSelect) {
      widget.onSelectionConfirmed(null);
    } else {
      widget.onSelectionConfirmed(null);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          _buildHeader(context),
          20.verticalSpace,
          CustomDialogSearchBar(
            searchController: _searchController,
            hintText: 'Search for Makers',
          ),
          _buildCarMakersContent(),
          20.verticalSpace,
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildCarMakersContent() {
    return Expanded(
        child: CustomScrollView(
      slivers: [
        if (_searchController.text.isEmpty)
          CarLogoSliverGrid(
            selectedCarMakers: _selectedCarMakers,
            onMakerSelected: _onMakerSelected,
            isMultiSelect: widget.isMultiSelect,
          ),
        SliverToBoxAdapter(
          child: 10.verticalSpace,
        ),
        MakersSliverListTileListView(
          carMakers: _filteredCarMakers,
          onMakerSelected: _onMakerSelected,
          selectedMakers: _selectedCarMakers,
        ),
      ],
    ));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Makers',
          style: context.textTheme.bodyMedium.s20.b,
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _onConfirmSelection,
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
              minimumSize: WidgetStatePropertyAll(
                Size(35.w, 45.h),
              )),
          child: AppText(
            widget.isMultiSelect ? 'Confirm Selection' : 'Select',
            style: context.textTheme.bodyMedium.b,
          ),
        ),
        ElevatedButton(
          onPressed: _onReset,
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.grey),
              minimumSize: WidgetStatePropertyAll(
                Size(35.w, 45.h),
              )),
          child: AppText(
            'Reset',
            style: context.textTheme.bodyMedium.b,
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: AppColors.blackLight,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          color: AppColors.primary,
        )
      ],
    );
  }
}
