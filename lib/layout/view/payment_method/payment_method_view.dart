import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/pay/pay_cubit.dart';
import '../../../bloc/wallet/add_to_wallet_cubit.dart';
import '../../../model/payment_method/payment_method_model/payment_method_model.dart';
import '../../../repository/user/wallet/add_to_wallet_repository.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/buttons/master/master_button.dart';
import '../../../widget/buttons/master_load/master_load_button.dart';
import '../../../widget/custom_grid/custom_grid.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../../widget/textfield/master/master_textfield.dart';
import '../course_pay/course_pay_view.dart';
import '../course_pay/lesson_pay_view.dart';

class PaymentMethodView extends StatelessWidget {
  final bool isWallet;
  final bool isCourse;
  final int? id;
  final bool isRequest;

  const PaymentMethodView({
    super.key,
    required this.isWallet,
    required this.isCourse,
    this.id,
    this.isRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PayCubit()..getPaymentMethod(),
        child: BlocConsumer<PayCubit, PayState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<PayCubit, PayState>(builder: (context, state) {
                if (state is PaymentMethodLoadedState) {
                  final data = (state).data;
                  return isWallet
                      ? _walletView(data)
                      : isCourse
                          ? CoursePayView(id: id!, paymentMethod: data)
                          : LessonPayView(
                              id: id!,
                              paymentMethod: data,
                              isRequest: isRequest);
                } else if (state is PayErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              });
            }));
  }

  _walletView(List<PaymentMethodModel>? data) {
    return BlocProvider(
        create: (BuildContext context) => AddToWalletCubit(WalletRepository()),
        child: BlocConsumer<AddToWalletCubit, AddToWalletState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AddToWalletCubit.get(context);
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    // height: 300.h,
                    // width: 400.w,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 50.h, 10.w, 10.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tr("wallet_charging"),
                            style: TextStyles.headerStyle.copyWith(
                                color: black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 20.h),
                            child: MasterTextField(
                              // errorText: bloc.validators[0],
                              controller: bloc.amountController,
                              // onChanged: (val) => bloc.validate(val),
                              keyboardType: TextInputType.number,
                              maxLines: 2,
                              hintText: tr("add_to_wallet"),
                            ),
                          ),
                          const Space(
                            boxHeight: 10,
                          ),
                          CustomGrid(
                            listHeight: 10000000000,
                            count: data!.length,
                            child: (context, index) => Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: bloc.payment,
                                  onChanged: (int? v) => bloc.setPaymentMethod(
                                      v!, data[index].id!),
                                ),
                                Opacity(
                                    opacity: bloc.payment == index ? 1 : 0.3,
                                    child: CachedImage(
                                      imageUrl: data[index].image ?? "",
                                      width: 40.w,
                                      height: 40.h,
                                      fit: BoxFit.contain,
                                    )),
                                // Text(
                                //   Get.locale!.languageCode == "ar"
                                //       ? data[index].nameAr.toString()
                                //       : data[index].nameEn.toString(),
                                //   style: bloc.payment == index
                                //       ? TextStyles.textView16Bold
                                //           .copyWith(color: mainColor)
                                //       : TextStyles.subTitleStyle.copyWith(
                                //           fontWeight: FontWeight.w700,
                                //           color: grey),
                                // ),
                              ],
                            ),
                          ),
                          const Space(
                            boxHeight: 10,
                          ),
                          SidePadding(
                            sidePadding: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: MasterLoadButton(
                                    buttonHeight: 55,
                                    onPressed: () => bloc.addToWallet(
                                        bloc.amountController.text.trim()),
                                    // context: context,
                                    // wallet: true,
                                    // amount: bloc.amount.text.trim()),
                                    buttonText: tr("confirm"),
                                    buttonStyle: TextStyles.textView14SemiBold
                                        .copyWith(color: white),
                                    buttonColor: mainColor,
                                    buttonController: bloc.loadController,
                                  ),
                                ),
                                const Space(
                                  boxWidth: 10,
                                ),
                                Expanded(
                                  child: MasterButton(
                                    buttonHeight: 55,
                                    buttonColor: profileColor,
                                    borderColor: profileColor,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    buttonText: tr("cancel"),
                                    buttonStyle: TextStyles.textView14SemiBold
                                        .copyWith(color: mainColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Space(
                            boxHeight: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -50,
                    child: Image.asset(
                      wallet,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }));
  }
}
