import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../bloc/auth/user/auth_cubit.dart';
import '../../../repository/user/auth_user/auth_user_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../side_padding/side_padding.dart';

class TimerWidget extends StatelessWidget {
  final RoundedLoadingButtonController buttonController;
  final String email;
  final bool? isCode, isEdit, isUser;
  final Map<String, dynamic>? data;
  final File? cv;
  const TimerWidget(
      {super.key,
      required this.email,
      required this.buttonController,
      this.isEdit,
      this.cv,
      this.isUser = false,
      this.isCode = false,
      this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthUserCubit(AuthUserRepository())..startTimer(),
        child: BlocConsumer<AuthUserCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AuthUserCubit.get(context);
              // bloc.startTimer();
              return SidePadding(
                sidePadding: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    state is LoadingState
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: bloc.start > 0 ||
                                    state is LoadingState ||
                                    buttonController.currentState ==
                                        ButtonState.loading
                                ? () {}
                                : () {
                                    isUser == true && isEdit == false
                                        ? bloc.resendCodeUser(data!, email)
                                        : isUser == false && isEdit == true
                                            ? bloc.resendEditEmail(
                                                isUser!, email)
                                            : bloc.sendCode(email, isCode,
                                                isEdit, data, cv);
                                  },
                            child: Text(
                              tr("resend"),
                              style: TextStyles.hintStyle.copyWith(
                                  color: bloc.start > 0
                                      ? secColor.withValues(alpha: 0.1)
                                      : secColor),
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 30),
                      decoration: BoxDecoration(
                        color: timerColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        bloc.start > 9
                            ? "${bloc.start}:00"
                            : "0${bloc.start}:00",
                        style: TextStyles.hintStyle.copyWith(
                            color: mainColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
