import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/drawable/icon/icons.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';
import '../../../bloc/auth/user/auth_cubit.dart';
import '../../../layout/activity/static/terms_conditions/terms_conditions_screen.dart';
import '../../../model/common/cities/city_model.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../repository/user/auth_user/auth_user_repository.dart';
import '../../buttons/master_load/master_load_button.dart';
import '../../dropdown/dropdown/dropdown.dart';

class UserRegisterBody extends StatefulWidget {
  final List<CityModel> cities;
  final List<NationalityModel> nations;
  const UserRegisterBody(
      {super.key, required this.cities, required this.nations});

  @override
  State<UserRegisterBody> createState() => _UserRegisterBodyState();
}

class _UserRegisterBodyState extends State<UserRegisterBody> {
  bool isLoading = false;
  toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AuthUserCubit(AuthUserRepository()),
        child: BlocConsumer<AuthUserCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AuthUserCubit.get(context);
              return ListView(
                children: [
                  SidePadding(
                      sidePadding: 30,
                      child: Text(tr("user"),
                          style: TextStyles.appBarStyle.copyWith(
                            color: darkGrey,
                          ))),
                  Column(
                    children: [
                      const Space(boxHeight: 10),
                      MasterTextField(
                        controller: bloc.firstName,
                        sidePadding: 15,
                        hintText: tr("first_name"),
                        prefixIcon: firstName,
                        errorText: bloc.validators[0],
                        onChanged: (val) => bloc.validate(val, 0, false),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.lastName,
                        sidePadding: 15,
                        hintText: tr("last_name"),
                        prefixIcon: firstName,
                        errorText: bloc.validators[1],
                        onChanged: (val) => bloc.validate(val, 1, false),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      SidePadding(
                        sidePadding: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => bloc.pickDate(),
                                child: Container(
                                  width: screenWidth,
                                  height: 70.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: textfieldColor,
                                        width: 1.w,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Space(
                                        boxWidth: 10.w,
                                      ),
                                      Image.asset(date,
                                          height: 20.h, fit: BoxFit.contain),
                                      Space(
                                        boxWidth: 5.w,
                                      ),
                                      Text(
                                        bloc.birthdate ?? tr("birthdate"),
                                        style: TextStyles.unselectedStyle
                                            .copyWith(color: mainColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Space(
                              boxWidth: 10,
                            ),
                            Expanded(
                              child: BuildDropDown(
                                isExpanded: true,
                                value: bloc.nation,
                                onChange: (val) => bloc.chooseNation(val),
                                items: widget.nations
                                    .map<DropdownMenuItem<dynamic>>(
                                        (dynamic value) {
                                  return DropdownMenuItem<dynamic>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Space(
                                            boxWidth: 10.w,
                                          ),
                                          Image.asset(nationality,
                                              height: 20.h,
                                              fit: BoxFit.contain),
                                          Space(
                                            boxWidth: 5.w,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: SizedBox(
                                              width: 130.w,
                                              child: Text("${value.name}",
                                                  style: TextStyles.appBarStyle
                                                      .copyWith(
                                                          color: mainColor
                                                              .withValues(
                                                                  alpha: .5))),
                                            ),
                                          ),
                                        ],
                                      ));
                                }).toList(),
                                hint: tr("nationality"),
                                image: nationality,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      // SidePadding(
                      //   sidePadding: 15,
                      //   child: Container(
                      //     height: 73.h,
                      //     width: screenWidth,
                      //     // decoration: BoxDecoration(
                      //     //   border: Border.all(color: textfieldColor),
                      //     //   borderRadius: BorderRadius.circular(10.r),
                      //     // ),
                      //     child: SidePadding(
                      //       sidePadding: 15,
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             children: [
                      //               Image.asset(gender,
                      //                   height: 25.h, fit: BoxFit.contain),
                      //               Space(
                      //                 boxWidth: 5.w,
                      //               ),
                      //               Text(
                      //                 tr("gender"),
                      //                 style: TextStyles.appBarStyle
                      //                     .copyWith(color: mainColor.withValues(alpha:.7)),
                      //               ),
                      //             ],
                      //           ),
                      //           SidePadding(
                      //             sidePadding: 70,
                      //             child: Row(
                      //               children: [
                      //                 //  const Spacer(),
                      //                 SizedBox(
                      //                   width: 25.w,
                      //                   child: Radio(
                      //                       value: 1,
                      //                       groupValue: bloc.genderValue,
                      //                       onChanged: (t) =>
                      //                           bloc.chooseGender(true)),
                      //                 ),
                      //                 Text(tr("male"),
                      //                     style: TextStyles.subTitleStyle
                      //                         .copyWith(fontWeight: FontWeight.w700)),
                      //                 const Spacer(),
                      //                 SizedBox(
                      //                   width: 25.w,
                      //                   child: Radio(
                      //                       value: 2,
                      //                       groupValue: bloc.genderValue,
                      //                       onChanged: (t) =>
                      //                           bloc.chooseGender(false)),
                      //                 ),
                      //                 Text(tr("female"),
                      //                     style: TextStyles.subTitleStyle
                      //                         .copyWith(fontWeight: FontWeight.w700)),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      ///=======================================================
                      SidePadding(
                        sidePadding: 15,
                        child: Container(
                          height: 70.h,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
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
                                  style: TextStyles.unselectedStyle
                                      .copyWith(color: mainColor),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 25.w,
                                  child: Radio(
                                      value: 1,
                                      groupValue: bloc.genderValue,
                                      onChanged: (t) =>
                                          bloc.chooseGender(true)),
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
                                      onChanged: (t) =>
                                          bloc.chooseGender(false)),
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
                        boxHeight: 15,
                      ),
                      SidePadding(
                        sidePadding: 15,
                        child: BuildDropDown(
                          isExpanded: true,
                          value: bloc.city,
                          onChange: (val) => bloc.chooseCity(val),
                          items: widget.cities
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            return DropdownMenuItem<dynamic>(
                                value: value,
                                child: Row(
                                  children: [
                                    Space(
                                      boxWidth: 10.w,
                                    ),
                                    Image.asset(city,
                                        height: 20.h, fit: BoxFit.contain),
                                    Space(
                                      boxWidth: 5.w,
                                    ),
                                    Text("${value.name}",
                                        style: TextStyles.appBarStyle
                                            .copyWith(color: mainColor)),
                                  ],
                                ));
                          }).toList(),
                          hint: tr("city"),
                          image: city,
                        ),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.email,
                        sidePadding: 15,
                        hintText: tr("email"),
                        prefixIcon: email,
                        errorText: bloc.validators[2],
                        onChanged: (val) => bloc.validate(val, 2, false),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.phone,
                        sidePadding: 15,
                        hintText: tr("phone"),
                        prefixIcon: phone,
                        errorText: bloc.validators[3],
                        onChanged: (val) => bloc.validate(val, 3, false),
                        keyboardType: TextInputType.number,
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.password,
                        sidePadding: 15,
                        hintText: tr("password"),
                        suffixTap: () => bloc.securePassword(),
                        prefixIcon: password,
                        isPassword: bloc.isPassword,
                        suffixColor: textfieldColor,
                        suffixIcon: "eye",
                        errorText: bloc.validators[4],
                        onChanged: (val) => bloc.validate(val, 4, true),
                      ),
                      const Space(
                        boxHeight: 15,
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
                            Text(tr("agree"),
                                style: TextStyles.unselectedStyle),
                            InkWell(
                              onTap: () => Get.to(() => const TermsScreen(
                                    isUser: true,
                                  )),
                              child: Text(tr("terms"),
                                  style: TextStyles.unselectedStyle
                                      .copyWith(color: mainColor)),
                            ),
                          ],
                        ),
                      ),
                      const Space(
                        boxHeight: 25,
                      ),
                      MasterLoadButton(
                        onPressed: () => bloc.validateEmail(),
                        sidePadding: 15,
                        buttonText: tr("confirm"),
                        buttonController: bloc.authController,
                      ),
                      const Space(
                        boxHeight: 20,
                      ),
                      // InkWell(
                      //   onTap: () => Get.to(() => const LoginScreen(
                      //         isUser: true,
                      //       )),
                      //   child: Text(tr("login"),
                      //       textAlign: TextAlign.center,
                      //       style: TextStyles.appBarStyle
                      //           .copyWith(color: mainColor)),
                      // ),
                      // const Space(
                      //   boxHeight: 20,
                      // ),
                      // const OrWidget(),
                      // const Space(
                      //   boxHeight: 25,
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     if (Platform.isIOS)
                      //       SocialButton(
                      //         image: apple,
                      //         onTap: () {
                      //           toggleLoading();
                      //           bloc.appleLogin(context);
                      //           toggleLoading();
                      //         },
                      //       ),
                      //     if (Platform.isIOS)
                      //       const Space(
                      //         boxWidth: 10,
                      //       ),
                      //     SocialButton(
                      //       image: google,
                      //       onTap: () {
                      //         toggleLoading();
                      //         bloc.googleLogin();
                      //         toggleLoading();
                      //       },
                      //     ),
                      //   ],
                      // ),

                      // const Space(
                      //   boxHeight: 100,
                      // ),
                    ],
                  ),
                ],
              );
            }));
  }
}
