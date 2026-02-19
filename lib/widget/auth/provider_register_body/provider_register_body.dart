import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../../res/drawable/icon/icons.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';
import '../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../layout/activity/auth/login/login_screen.dart';
import '../../../layout/activity/static/terms_conditions/terms_conditions_screen.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../buttons/master_load/master_load_button.dart';
import '../../dropdown/dropdown/dropdown.dart';

class ProviderRegisterBody extends StatelessWidget {
  final List<NationalityModel> nations;
  const ProviderRegisterBody({super.key, required this.nations});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthProviderCubit(AuthProviderRepository()),
        child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AuthProviderCubit.get(context);
              return ListView(
                children: [
                  SidePadding(
                      sidePadding: 80,
                      child: Text(tr("provider"),
                          style: TextStyles.appBarStyle.copyWith(
                            color: darkGrey,
                          ))),
                  const Space(
                    boxHeight: 25,
                  ),
                  const SidePadding(
                    sidePadding: 15,
                    child: StepProgressIndicator(
                      totalSteps: 5,
                      currentStep: 1,
                      selectedColor: mainColor,
                      unselectedColor: textfieldColor,
                    ),
                  ),
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
                    errorText: bloc.validators[6],
                    onChanged: (val) => bloc.validate(val, 6, false),
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
                                Expanded(
                                  child: Text("${value.name}",
                                      overflow: TextOverflow.clip,
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
                                height: 25.h, fit: BoxFit.contain),
                            Space(
                              boxWidth: 5.w,
                            ),
                            Text(
                              tr("gender"),
                              style: TextStyles.textView14SemiBold
                                  .copyWith(color: mainColor),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 25.w,
                              child: Radio(
                                  value: 1,
                                  groupValue: bloc.genderValue,
                                  onChanged: (t) => bloc.chooseGender(true)),
                            ),
                            Text(tr("male"),
                                style: TextStyles.subTitleStyle
                                    .copyWith(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            SizedBox(
                              width: 25.w,
                              child: Radio(
                                  value: 2,
                                  groupValue: bloc.genderValue,
                                  onChanged: (t) => bloc.chooseGender(false)),
                            ),
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
                    sidePadding: 15,
                    hintText: tr("email"),
                    prefixIcon: email,
                    errorText: bloc.validators[3],
                    onChanged: (val) => bloc.validate(val, 3, false),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.password,
                    sidePadding: 15,
                    isPassword: bloc.isPassword,
                    suffixColor: textfieldColor,
                    suffixIcon: "eye",
                    hintText: tr("password"),
                    prefixIcon: password,
                    errorText: bloc.validators[4],
                    onChanged: (val) => bloc.validate(val, 4, true),
                    suffixTap: () => bloc.securePassword(),
                  ),
                  const Space(
                    boxHeight: 10,
                  ),
                  MasterTextField(
                    controller: bloc.confirm,
                    sidePadding: 15,
                    isPassword: bloc.isConfirm,
                    suffixColor: textfieldColor,
                    suffixIcon: "eye",
                    hintText: tr("confirm_password"),
                    prefixIcon: password,
                    errorText: bloc.validators[5],
                    onChanged: (val) => bloc.validate(val, 5, true),
                    suffixTap: () => bloc.secureConfirm(),
                  ),
                  const Space(
                    boxHeight: 15,
                  ),
                  SidePadding(
                    sidePadding: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            activeColor: mainColor,
                            value: bloc.agree,
                            onChanged: (t) => bloc.agreeTerms(t)),
                        Text(tr("agree"), style: TextStyles.unselectedStyle),
                        InkWell(
                          onTap: () =>
                              Get.to(() => const TermsScreen(isUser: false)),
                          child: Text(tr("terms"),
                              style: TextStyles.textView14SemiBold
                                  .copyWith(color: mainColor)),
                        ),
                      ],
                    ),
                  ),
                  const Space(
                    boxHeight: 25,
                  ),
                  MasterLoadButton(
                      buttonController: bloc.authController,
                      onPressed: () => bloc.validateEmail(),
                      sidePadding: 15,
                      buttonText: tr("next")),
                  const Space(
                    boxHeight: 20,
                  ),
                  InkWell(
                    onTap: () => Get.to(() => const LoginScreen(
                          isUser: false,
                        )),
                    child: Text(tr("login"),
                        textAlign: TextAlign.center,
                        style:
                            TextStyles.appBarStyle.copyWith(color: mainColor)),
                  ),
                  const Space(
                    boxHeight: 100,
                  ),
                ],
              );
            }));
  }
}
