import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/presentation/widgets/refresh_list_widget.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/home/presentation/widgets/home_app_bar.dart';
import 'package:wolfera/features/home/presentation/widgets/home_body.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  // Ensure entrance animation runs only once per app session
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  late HomeCubit _homeCubit;
  int _adRefresh = 0;
  @override
  void initState() {
    _homeCubit = GetIt.I<HomeCubit>()..getHomeData();
    _shouldAnimateEntrance = !_didAnimateOnce;
    // Mark as animated for subsequent visits
    _didAnimateOnce = true;
    // Ensure initial search results are loaded for the vertical list under filters
    GetIt.I<SearchCubit>().searchCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _homeCubit,
      child: SafeArea(
        child: Scaffold(
          body: RefreshListWidget(
            onRefresh: () async {
              // Refresh Recommended (featured) and Combined Search lists
              _homeCubit.getHomeData(); // returns void
              await GetIt.I<SearchCubit>().searchCars();
              // Trigger banner refresh
              setState(() => _adRefresh++);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // App Bar
                HomeAppBar(animate: _shouldAnimateEntrance),
                // Home Body
                HomeBody(
                  animate: _shouldAnimateEntrance,
                  refreshToken: _adRefresh,
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
