import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../app/presentation/widgets/app_loader_widget/app_loader.dart';

class CustomPagedListView<T, B> extends StatelessWidget {
  const CustomPagedListView({
    super.key,
    required this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.isSliver = false,
    required this.noItemsFoundIndicatorWidget,
    required this.pagingController,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.scrollController,
    this.shrinkWrap = false,
    this.isGrid = false,
    this.mainAxisExtent,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
  }) : _separatorBuilder = null;

  final PagingController<T, B> pagingController;
  final IndexedWidgetBuilder? _separatorBuilder;
  final Widget? noItemsFoundIndicatorWidget;
  final Widget? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;

  final ItemWidgetBuilder<B> itemBuilder;
  final bool isSliver;
  final bool isGrid;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final int? crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

  const CustomPagedListView.separated({
    this.isSliver = false,
    this.isGrid = false,
    this.firstPageErrorIndicatorBuilder,
    this.firstPageProgressIndicatorBuilder,
    this.noItemsFoundIndicatorWidget,
    required this.pagingController,
    required this.itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    this.padding,
    this.physics,
    this.scrollController,
    this.mainAxisExtent,
    this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.childAspectRatio,
    this.shrinkWrap = false,
    super.key,
  }) : _separatorBuilder = separatorBuilder;

  @override
  Widget build(BuildContext context) {
    return isSliver
        ? (isGrid ? buildPagedGridSliverList : buildPagedSliverList)
        : (isGrid ? buildPagedGridView : buildPagedListView);
  }

  PagedListView<T, B> get buildPagedListView {
    return _separatorBuilder != null
        ? PagedListView<T, B>.separated(
            separatorBuilder: _separatorBuilder!,
            pagingController: pagingController,
            padding: padding,
            physics: physics,
            scrollController: scrollController,
            shrinkWrap: shrinkWrap,
            builderDelegate: PagedChildBuilderDelegate<B>(
              firstPageProgressIndicatorBuilder:
                  firstPageProgressIndicatorBuilder != null
                      ? firstPageProgressIndicatorBuilder!
                      : (context) => const AppLoader(),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: AppLoader.spinKitThreeBounce()),
              noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
                  ? (context) => noItemsFoundIndicatorWidget!
                  : null,
              firstPageErrorIndicatorBuilder:
                  firstPageErrorIndicatorBuilder != null
                      ? (context) => firstPageErrorIndicatorBuilder!
                      : null,
              itemBuilder: itemBuilder,
            ),
          )
        : PagedListView<T, B>(
            pagingController: pagingController,
            padding: padding,
            physics: physics,
            scrollController: scrollController,
            shrinkWrap: shrinkWrap,
            builderDelegate: PagedChildBuilderDelegate<B>(
              firstPageProgressIndicatorBuilder:
                  firstPageProgressIndicatorBuilder != null
                      ? firstPageProgressIndicatorBuilder!
                      : (context) => const AppLoader(),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: AppLoader.spinKitThreeBounce()),
              noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
                  ? (context) => noItemsFoundIndicatorWidget!
                  : null,
              firstPageErrorIndicatorBuilder:
                  firstPageErrorIndicatorBuilder != null
                      ? (context) => firstPageErrorIndicatorBuilder!
                      : null,
              itemBuilder: itemBuilder,
            ),
          );
  }

  PagedSliverList<dynamic, dynamic> get buildPagedSliverList {
    return _separatorBuilder != null
        ? PagedSliverList<T, B>.separated(
            separatorBuilder: _separatorBuilder!,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<B>(
              itemBuilder: itemBuilder,
              firstPageProgressIndicatorBuilder:
                  firstPageProgressIndicatorBuilder != null
                      ? firstPageProgressIndicatorBuilder!
                      : (context) => const AppLoader(),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: AppLoader.spinKitThreeBounce()),
              noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
                  ? (context) => noItemsFoundIndicatorWidget!
                  : null,
              firstPageErrorIndicatorBuilder:
                  firstPageErrorIndicatorBuilder != null
                      ? (context) => firstPageErrorIndicatorBuilder!
                      : null,
            ),
          )
        : PagedSliverList<T, B>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<B>(
              itemBuilder: itemBuilder,
              firstPageProgressIndicatorBuilder: (context) => const AppLoader(),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: AppLoader.spinKitThreeBounce()),
              noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
                  ? (context) => noItemsFoundIndicatorWidget!
                  : null,
              firstPageErrorIndicatorBuilder:
                  firstPageErrorIndicatorBuilder != null
                      ? (context) => firstPageErrorIndicatorBuilder!
                      : null,
            ),
          );
  }

  PagedSliverGrid<dynamic, dynamic> get buildPagedGridSliverList {
    return PagedSliverGrid<T, B>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<B>(
        itemBuilder: itemBuilder,
        firstPageProgressIndicatorBuilder:
            firstPageProgressIndicatorBuilder != null
                ? firstPageProgressIndicatorBuilder!
                : (context) => const AppLoader(),
        newPageProgressIndicatorBuilder: (context) =>
            const Center(child: AppLoader.spinKitThreeBounce()),
        noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
            ? (context) => noItemsFoundIndicatorWidget!
            : null,
        firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder != null
            ? (context) => firstPageErrorIndicatorBuilder!
            : null,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 24.0.w,
        crossAxisSpacing: 32.0.h,
        childAspectRatio: childAspectRatio ?? 1,
        mainAxisExtent: mainAxisExtent,
      ),
    );
  }

  PagedGridView<T, B> get buildPagedGridView {
    return PagedGridView<T, B>(
      pagingController: pagingController,
      padding: padding,
      physics: physics,
      scrollController: scrollController,
      shrinkWrap: shrinkWrap,
      builderDelegate: PagedChildBuilderDelegate<B>(
        firstPageProgressIndicatorBuilder:
            firstPageProgressIndicatorBuilder != null
                ? firstPageProgressIndicatorBuilder!
                : (context) => const AppLoader(),
        newPageProgressIndicatorBuilder: (context) =>
            const Center(child: AppLoader.spinKitThreeBounce()),
        noItemsFoundIndicatorBuilder: noItemsFoundIndicatorWidget != null
            ? (context) => noItemsFoundIndicatorWidget!
            : null,
        firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder != null
            ? (context) => firstPageErrorIndicatorBuilder!
            : null,
        itemBuilder: itemBuilder,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? 4,
        mainAxisSpacing: mainAxisSpacing ?? 24.0.w,
        crossAxisSpacing: crossAxisSpacing ?? 32.0.h,
        mainAxisExtent: mainAxisExtent,
        childAspectRatio: childAspectRatio ?? 1,
      ),
    );
  }
}
