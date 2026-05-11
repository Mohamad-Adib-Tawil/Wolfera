import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/presentation/widgets/refresh_list_widget.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/home/presentation/widgets/home_app_bar.dart';
import 'package:wolfera/features/home/presentation/widgets/home_body.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/services/search_and_filters_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final ValueNotifier<int> refreshTick = ValueNotifier<int>(0);

  static void requestRefresh() {
    refreshTick.value++;
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // Ensure entrance animation runs only once per app session
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  late HomeCubit _homeCubit;
  late SearchCubit _homeSearchCubit;
  final int _adRefresh = 0;
  Future<void> Function()? _bannerReload;
  bool _hasBanner = false;
  @override
  void initState() {
    _homeCubit = GetIt.I<HomeCubit>()..getHomeData();
    _homeSearchCubit = SearchCubit(GetIt.I<SearchFilterService>());
    _shouldAnimateEntrance = !_didAnimateOnce;
    // Mark as animated for subsequent visits
    _didAnimateOnce = true;
    HomePage.refreshTick.addListener(_handleExternalRefresh);
    super.initState();
  }

  @override
  void dispose() {
    HomePage.refreshTick.removeListener(_handleExternalRefresh);
    _homeSearchCubit.close();
    super.dispose();
  }

  void _handleExternalRefresh() {
    _homeCubit.getHomeData();
    _homeSearchCubit.searchCars();
    _bannerReload?.call();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _homeCubit,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          body: RefreshListWidget(
            onRefresh: () async {
              // Refresh Recommended (featured) and Combined Search lists
              _homeCubit.getHomeData(); // returns void
              await _homeSearchCubit.searchCars();
              // Refresh banners without rebuilding the whole sliver list
              await _bannerReload?.call();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // App Bar
                HomeAppBar(
                  animate: _shouldAnimateEntrance,
                  searchCubit: _homeSearchCubit,
                ),
                // Home Body
                HomeBody(
                  animate: _shouldAnimateEntrance,
                  searchCubit: _homeSearchCubit,
                  refreshToken: _adRefresh,
                  onRegisterBannerReload: (fn) => _bannerReload = fn,
                  hasBanner: _hasBanner,
                  onBannerPresenceChanged: (has) {
                    if (_hasBanner != has && mounted) {
                      setState(() => _hasBanner = has);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
