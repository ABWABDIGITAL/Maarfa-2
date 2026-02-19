import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../widget/auth/user_register_body/user_register_body.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';

class UserNationsView extends StatelessWidget {
  const UserNationsView({super.key});
  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<NationsCubit, NationsState>(builder: (context, state) {
      if (state is AuthNationLoadedState) {
        final data = (state).data;
        return authView(context, data);
      } else if (state is NationsLoadErrorState) {
        return const ErrorPage();
      } else {
        return const Loading();
      }
    });
  }

  authView(context, data) {
    return UserRegisterBody(
      nations: data,
    );
  }
}
