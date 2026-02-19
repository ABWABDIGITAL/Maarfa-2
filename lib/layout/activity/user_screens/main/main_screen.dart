import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/bottom_bar/bottom_bar_cubit.dart';
import '../../../../widget/bottom_bar/main/bottom_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BottomBarCubit>(context, listen: true);

    return PopScope(
      canPop: bloc.selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && bloc.selectedIndex != 0) {
          bloc.changeBottomBar(0);
        }
      },
      child: SafeArea(
        top: true,
        child: Scaffold(
          body: bloc.pageList[bloc.selectedIndex],
          bottomNavigationBar: const MasterBottomBar(),
        ),
      ),
    );
  }
}
