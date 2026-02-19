import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../bloc/splash/splash_cubit.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';

class SplashNationsView extends StatefulWidget {
  const SplashNationsView({super.key});

  @override
  State<SplashNationsView> createState() => _SplashNationsViewState();
}

class _SplashNationsViewState extends State<SplashNationsView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().startApp();
    context.read<NationsCubit>().getNationsInSplash();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<NationsCubit, NationsState>(builder: (context, state) {
      if (state is AuthNationLoadedState) {
        return const SizedBox();
      } else if (state is NationsLoadErrorState) {
        return const ErrorPage();
      } else {
        return const Loading();
      }
    });
  }
}
