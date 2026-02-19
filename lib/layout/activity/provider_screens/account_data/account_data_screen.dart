import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../view/nations/nation_user_profile/nation_user_profile_view.dart';

class AccountDataScreen extends StatelessWidget {
  final bool isUser;
  final dynamic user;
  const AccountDataScreen(
      {super.key, required this.isUser, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: tr("edit_account_information")),
      body: UserProfileNationsView(isUser: isUser, user: user),
    );
  }
}
