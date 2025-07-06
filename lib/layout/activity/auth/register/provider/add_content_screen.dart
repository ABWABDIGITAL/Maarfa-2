import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_academy/res/drawable/icon/icons.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/buttons/master/master_button.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../../widget/textfield/master/master2_textfiled.dart';

class AddContentScreen extends StatelessWidget {
  const AddContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: tr("add_content")),
      body: SidePadding(
        sidePadding: 15,
        child: ListView(
          children: [
            Text(
              tr("advice"),
              style: TextStyles.contentStyle,
            ),
            Master2TextField(
              hintText: tr("Counseling_field"),
              suffixIcon: angleRight,
            ),
            const Space(
              boxHeight: 20,
            ),
            Master2TextField(
              hintText: tr("description"),
              maxLines: 5,
              minLines: 5,
              fieldHeight: 130,
            ),
            const Space(
              boxHeight: 20,
            ),
            Master2TextField(
              hintText: tr("hourly_price"),
            ),
            const Space(
              boxHeight: 20,
            ),
            MasterButton(
              onPressed: () {},
              buttonText: tr("add_table"),
              buttonColor: mainColor.withValues(alpha: 0.1),
              borderColor: mainColor.withValues(alpha: 0.1),
              // buttonStyle: TextStyles.appBarStyle.copyWith(color: mainColor),
            ),
            const Space(
              boxHeight: 200,
            ),
            MasterButton(
              onPressed: () {},
              buttonText: tr("add_content"),
            ),
          ],
        ),
      ),
    );
  }
}
