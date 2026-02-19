import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/profile/provider/provider_profile_body.dart';
import '../../../../widget/profile/user/user_profile_body.dart';

class UserProfileNationsView extends StatelessWidget {
  final dynamic user;
  final bool isUser;
  const UserProfileNationsView(
      {super.key, required this.user, required this.isUser});
  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<NationsCubit, NationsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocBuilder<NationsCubit, NationsState>(
            builder: (context, state) {
          if (state is AuthNationLoadedState) {
            final data = (state).data;
            return profileView(context, data);
          } else if (state is NationsLoadErrorState) {
            return const ErrorPage();
          } else {
            return const Loading();
          }
        });
      },
    );
  }

  profileView(context, data) {
    return isUser
        ? UserProfileBody(
            nations: data,
            user: user,
          )
        : ProviderProfileBody(
            nations: data,
            user: user,
          );
  }
}
