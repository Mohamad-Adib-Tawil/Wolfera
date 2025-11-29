import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_dialog_search_bar.dart';

class EngineVariantsDialog extends StatefulWidget {
  final String? selected;
  final Function(String?) onSelectionConfirmed;

  const EngineVariantsDialog({
    super.key,
    required this.onSelectionConfirmed,
    this.selected,
  });

  @override
  State<EngineVariantsDialog> createState() => _EngineVariantsDialogState();
}

class _EngineVariantsDialogState extends State<EngineVariantsDialog> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _allVariants;
  late List<String> _filtered;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    _allVariants = _variants;
    _filtered = _filter('');
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filtered = _filter(_searchController.text);
    });
  }

  List<String> _filter(String q) {
    q = q.toLowerCase();
    final list = _allVariants.where((v) => v.toLowerCase().contains(q)).toList();
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  void _confirm() {
    widget.onSelectionConfirmed(_selected);
    Navigator.of(context).pop();
  }

  void _reset() {
    widget.onSelectionConfirmed(null);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
          CustomDialogSearchBar(
            searchController: _searchController,
            hintText: 'Search engine variants',
          ),
          10.verticalSpace,
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: AppText(
                      'noItemsFound',
                      style: context.textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.whiteLess),
                    itemBuilder: (context, index) {
                      final v = _filtered[index];
                      final isSelected = _selected == v;
                      return ListTile(
                        dense: true,
                        contentPadding: HWEdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        title: Text(v, style: context.textTheme.bodyMedium),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () => setState(() => _selected = v),
                      );
                    },
                  ),
          ),
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
          'Engine Variants',
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
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary),
          ),
          child: AppText(
            'Select',
            translation: false,
            style: context.textTheme.bodyMedium.b,
          ),
        ),
        ElevatedButton(
          onPressed: _reset,
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.grey),
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

  static const List<String> _variants = [
    // Common displacements
    '1.0L I3', '1.2L I4', '1.3L I4', '1.4L I4', '1.5L I4', '1.6L I4', '1.8L I4', '2.0L I4', '2.5L I4',
    '3.0L V6', '3.5L V6', '4.0L V6', '4.0L V8', '5.0L V8',
    // Turbo / Supercharged
    '1.0L Turbo', '1.2L Turbo', '1.4L Turbo', '1.5L Turbo', '1.6L Turbo', '2.0L Turbo', '3.0L Turbo',
    // Diesel
    '1.6L Diesel', '2.0L Diesel', '3.0L Diesel',
    // Marketing names per brands
    '1.0 TSI', '1.2 TSI', '1.4 TSI', '1.5 TSI', '2.0 TSI', '2.0 TFSI', '3.0 TDI', '2.0 CRDi', '1.6 CRDi', 'EcoBoost 2.0',
    // Hybrid / Electric
    'Hybrid 1.8L', 'Hybrid 2.5L', 'Plug-in Hybrid', 'Electric (Standard)', 'Electric (Long Range)'
  ];
}
