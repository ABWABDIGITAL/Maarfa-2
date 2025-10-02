import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/bloc/bottom_bar/bottom_bar_cubit.dart';
import 'package:my_academy/widget/bottom_bar/main_provider/bottom_bar_provider.dart';
import '../../../../bloc/show_provider_details/provider_info_cubit.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
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
        if (bloc.selectedProvider == 0) {
          return true;
        } else {
          bloc.changeProviderBar(0);
          return false;
        }
      },
      child: Scaffold(
        extendBody: true,
        body: bloc.providerList[bloc.selectedProvider],
        bottomNavigationBar: const SafeArea(
          bottom: true,
          child: ProviderBottomBar(),
        ),
      ),
    );
  }
}
