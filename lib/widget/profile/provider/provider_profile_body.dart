import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/profile/provider/provider_cubit.dart';
import '../../../layout/activity/auth/forget/change_password.dart';
import '../../../layout/activity/user_screens/profile/edit_email/edit_email_screen.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../model/provider/provider/provider_model.dart';
import '../../../repository/user/edit_profile/user_repository.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../buttons/master/master_button.dart';
import '../../buttons/master_load/master_load_button.dart';
import '../../dropdown/dropdown/dropdown.dart';
import '../../profile_avatar.dart';
import '../../side_padding/side_padding.dart';
import '../../space/space.dart';
import '../../textfield/master/master_textfield.dart';

class ProviderProfileBody extends StatelessWidget {
  final List<NationalityModel> nations;
  final Provider user;
  const ProviderProfileBody(
      {super.key, required this.nations, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ProviderCubit(UserRepository())..getInitData(user, nations),
        child: BlocConsumer<ProviderCubit, ProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = ProviderCubit.get(context);
              return ListView(
                children: [
                  const Space(
                    boxHeight: 15,
                  ),
                  Center(
                      child: ProfileAvatar(
                    img: user.imagePath,
                    image: bloc.profileImage,
                    picked: bloc.picked,
                    isEdited: true,
                    onTap: () => bloc.pickProfile(),
                  )),
                  const Space(
                    boxHeight: 20,
                  ),
                  MasterTextField(
                    controller: bloc.scientificName,
                    sidePadding: 15,
                    hintText: tr("scientific_title"),
                    prefixIcon: title,
                    errorText: bloc.validators[0],
                    onChanged: (val) => bloc.validate(val, 0, false),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.firstName,
                    sidePadding: 15,
                    hintText: tr("first_name"),
                    prefixIcon: firstName,
                    errorText: bloc.validators[1],
                    onChanged: (val) => bloc.validate(val, 1, false),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.lastName,
                    sidePadding: 15,
                    hintText: tr("last_name"),
                    prefixIcon: lastName,
                    errorText: bloc.validators[2],
                    onChanged: (val) => bloc.validate(val, 2, false),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.degree,
                    sidePadding: 15,
                    hintText: tr("degree"),
                    prefixIcon: title,
                    errorText: bloc.validators[4],
                    onChanged: (val) => bloc.validate(val, 4, false),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  SidePadding(
                    sidePadding: 15,
                    child: BuildDropDown(
                      isExpanded: true,
                      value: bloc.nation,
                      onChange: (val) => bloc.chooseNation(val),
                      items: nations
                          .map<DropdownMenuItem<dynamic>>((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Row(
                              children: [
                                Space(
                                  boxWidth: 10.w,
                                ),
                                Image.asset(nationality,
                                    height: 20.h, fit: BoxFit.contain),
                                Space(
                                  boxWidth: 5.w,
                                ),
                                FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text("${value.name}",
                                      softWrap: true,
                                      style: TextStyles.textView14SemiBold
                                          .copyWith(color: mainColor)),
                                ),
                              ],
                            ));
                      }).toList(),
                      hint: tr("nationality"),
                      image: nationality,
                    ),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  SidePadding(
                    sidePadding: 15,
                    child: Container(
                      height: 70.h,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: SidePadding(
                        sidePadding: 15,
                        child: Row(
                          children: [
                            Image.asset(gender,
                                height: 20.h, fit: BoxFit.contain),
                            Space(
                              boxWidth: 5.w,
                            ),
                            Text(
                              tr("gender"),
                              style: TextStyles.textView14SemiBold
                                  .copyWith(color: mainColor),
                            ),
                            const Spacer(),
                            Radio(
                                value: 1,
                                groupValue: bloc.genderValue,
                                onChanged: (t) => bloc.chooseGender(true)),
                            Text(tr("male"),
                                style: TextStyles.subTitleStyle
                                    .copyWith(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            Radio(
                                value: 2,
                                groupValue: bloc.genderValue,
                                onChanged: (t) => bloc.chooseGender(false)),
                            Text(tr("female"),
                                style: TextStyles.subTitleStyle
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.email,
                    readOnly: true,
                    sidePadding: 15,
                    hintText: tr("email"),
                    prefixIcon: email,
                    errorText: bloc.validators[3],
                    onChanged: (val) => bloc.validate(val, 3, false),
                    isChange: true,
                    onTap: () =>
                        Get.to(() => const ChangeEmailScreen(isUser: false)),
                  ),
                  const Space(
                    boxHeight: 25,
                  ),
                  MasterButton(
                      buttonColor: profileColor,
                      borderColor: profileColor,
                      onPressed: () => Get.to(() => const ChangePassword()),
                      sidePadding: 15,
                      buttonText: tr("change_password"),
                      buttonStyle:
                          TextStyles.appBarStyle.copyWith(color: mainColor)),
                  const Space(
                    boxHeight: 15,
                  ),
                  MasterLoadButton(
                      buttonController: bloc.controller,
                      onPressed: () => bloc.editProfile(),
                      sidePadding: 15,
                      buttonText: tr("updating_data")),
                  const Space(
                    boxHeight: 100,
                  ),
                ],
              );
            }));
  }
}
