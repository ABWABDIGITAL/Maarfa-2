import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/bottom_bar/bottom_bar_cubit.dart';
import '../../../../bloc/show_provider_details/provider_info_cubit.dart';
import '../../../../widget/bottom_bar/main/bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  goToProvider() {
    BlocProvider.of<ProviderInfoCubit>(context).goToProvider();
  }

  @override
  void initState() {
    // Future.microtask(() => goToProvider());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BottomBarCubit>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        if (bloc.selectedIndex == 0) {
          return true;
        } else {
          bloc.changeBottomBar(0);
          return false;
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
    // }));
  }
}
