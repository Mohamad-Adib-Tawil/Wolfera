import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/my_car/presentation/manager/my_cars_bloc.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';

import '../features/app/presentation/bloc/app_manager_cubit.dart';

class ServiceProvider extends StatelessWidget {
  const ServiceProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<AppManagerCubit>()..checkUser()),
        BlocProvider(create: (_) => GetIt.I<SearchCubit>()),
        BlocProvider(create: (_) => GetIt.I<MyCarsBloc>()),
      ],
      child: child,
    );
  }

  final Widget child;
}
