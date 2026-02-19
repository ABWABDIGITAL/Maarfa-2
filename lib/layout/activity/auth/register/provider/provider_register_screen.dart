import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../view/nations/nations_provider/provider_nation_view.dart';

class ProviderRegisterScreen extends StatelessWidget {
  const ProviderRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthProviderCubit(AuthProviderRepository()),
        child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar:
                      DefaultAppBar(title: tr("register"), centerTitle: false),
                  body: const ProviderNationsView());
            }));
  }
}
