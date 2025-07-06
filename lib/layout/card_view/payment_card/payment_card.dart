import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../bloc/pay/pay_cubit.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PayCubit(),
        child: BlocConsumer<PayCubit, PayState>(
          listener: (context, state) {},
          builder: (context, state) {
            final bloc = PayCubit.get(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("payment_method"),
                  style: TextStyles.appBarStyle.copyWith(color: black),
                ),
                const Space(
                  boxHeight: 10,
                ),
                SizedBox(
                  width: screenWidth,
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: 2,
                            groupValue: bloc.value,
                            onChanged: (v) {
                              bloc.setPayment(v);
                            },
                          ),
                          Opacity(
                              opacity: bloc.value == 2 ? 1 : 0.3,
                              child: Image.asset(paidImage)),
                          Text(
                            tr("pay_online"),
                            style: bloc.value == 2
                                ? TextStyles.textView16Bold
                                    .copyWith(color: mainColor)
                                : TextStyles.subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w700, color: grey),
                          ),
                        ],
                      ),
                      // colorFilter: ColorFilter.mode(Colors.white.withValues(alpha:0.8), BlendMode.modulate,)
                      Row(
                        children: [
                          Radio(
                            value: 1,
                            groupValue: bloc.value,
                            onChanged: (v) {
                              bloc.setPayment(v);
                            },
                          ),
                          Opacity(
                              opacity: bloc.value == 1 ? 1 : 0.3,
                              child: Image.asset(wallet)),
                          Text(
                            tr("wallet"),
                            style: bloc.value == 1
                                ? TextStyles.textView16Bold
                                    .copyWith(color: mainColor)
                                : TextStyles.subTitleStyle.copyWith(
                                    fontWeight: FontWeight.w700, color: grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}
