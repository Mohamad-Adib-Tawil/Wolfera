import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/constants/car_models_data.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_dialog_search_bar.dart';

class CarModelsDialog extends StatefulWidget {
  final bool isMultiSelect;
  final CarMaker? maker; // If provided, models will be from this maker
  final List<CarMaker>? makers; // Or a list of makers to aggregate models
  final List<String> selectedModels;
  final Function(dynamic) onSelectionConfirmed;

  const CarModelsDialog({
    super.key,
    this.isMultiSelect = false,
    required this.onSelectionConfirmed,
    this.maker,
    this.makers,
    this.selectedModels = const [],
  });

  @override
  State<CarModelsDialog> createState() => _CarModelsDialogState();
}

class _CarModelsDialogState extends State<CarModelsDialog> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _allModels;
  late List<String> _filteredModels;
  late List<String> _selectedModels;

  @override
  void initState() {
    super.initState();
    _selectedModels = List<String>.from(widget.selectedModels);
    _allModels = _computeModels();
    _filteredModels = _filter("");
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<String> _computeModels() {
    final makers = <CarMaker>[];
    if (widget.maker != null) makers.add(widget.maker!);
    if (widget.makers != null) makers.addAll(widget.makers!);

    if (makers.isEmpty) return const <String>[];

    final models = CarModelsData.forMakers(makers);
    return models;
  }

  List<String> _filter(String q) {
    q = q.toLowerCase();
    final list = _allModels
        .where((m) => m.toLowerCase().contains(q))
        .toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  void _onSearchChanged() {
    setState(() {
      _filteredModels = _filter(_searchController.text);
    });
  }

  void _onModelTapped(String model) {
    setState(() {
      if (widget.isMultiSelect) {
        if (_selectedModels.contains(model)) {
          _selectedModels.remove(model);
        } else {
          _selectedModels.add(model);
        }
      } else {
        _selectedModels = [model];
      }
    });
  }

  void _confirm() {
    if (widget.isMultiSelect) {
      widget.onSelectionConfirmed(_selectedModels);
    } else {
      widget.onSelectionConfirmed(_selectedModels.isNotEmpty ? _selectedModels.first : null);
    }
    Navigator.of(context).pop();
  }

  void _reset() {
    widget.onSelectionConfirmed(widget.isMultiSelect ? <String>[] : null);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final noMakersProvided = (_allModels.isEmpty);

    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.blackLight,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: AppColors.primary,
          )
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          20.verticalSpace,
          if (!noMakersProvided) ...[
            CustomDialogSearchBar(
              searchController: _searchController,
              hintText: 'Search for Models',
            ),
            10.verticalSpace,
            Expanded(
              child: _filteredModels.isEmpty
                  ? Center(
                      child: AppText(
                        'noItemsFound',
                        style: context.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredModels.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.whiteLess),
                      itemBuilder: (context, index) {
                        final model = _filteredModels[index];
                        final isSelected = _selectedModels.contains(model);
                        return ListTile(
                          dense: true,
                          contentPadding: HWEdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          title: Text(model, style: context.textTheme.bodyMedium),
                          trailing: widget.isMultiSelect
                              ? Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? AppColors.primary : AppColors.grey,
                                )
                              : (isSelected
                                  ? const Icon(Icons.check, color: AppColors.primary)
                                  : null),
                          onTap: () => _onModelTapped(model),
                        );
                      },
                    ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: AppText(
                  'Please select maker first',
                  translation: false,
                  style: context.textTheme.bodyMedium?.withColor(AppColors.grey),
                ),
              ),
            ),
          ],
          20.verticalSpace,
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Models',
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
          onPressed: _confirm,
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
            minimumSize: WidgetStatePropertyAll(Size(35.w, 45.h)),
          ),
          child: AppText(
            widget.isMultiSelect ? 'Confirm Selection' : 'Select',
            translation: false,
            style: context.textTheme.bodyMedium.b,
          ),
        ),
        ElevatedButton(
          onPressed: _reset,
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(AppColors.grey),
            minimumSize: WidgetStatePropertyAll(Size(35.w, 45.h)),
          ),
          child: AppText(
            'Reset',
            translation: false,
            style: context.textTheme.bodyMedium.b,
          ),
        ),
      ],
    );
  }
}
