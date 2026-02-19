import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/bank_account/bank_account_cubit.dart';
import 'package:my_academy/repository/provider/bank_account/bank_account_repository.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/buttons/master_load/master_load_button.dart';
import 'package:my_academy/widget/space/space.dart';
import 'package:my_academy/widget/textfield/master/master_textfield.dart';

import '../../../view/connectivity/connectivity_view.dart';

class AddingBankAccount extends StatelessWidget {
  const AddingBankAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountCubit(BankAccountRepository()),
      child: Scaffold(
        appBar: DefaultAppBar(title: tr("add_bank")),
        body: ConnectivityView(
          child: BlocBuilder<BankAccountCubit, BankAccountState>(
            builder: (context, state) {
              final bloc = BankAccountCubit.get(context);
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => bloc.selectWallet(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: bloc.isBankAcount
                                    ? mainColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Text(
                                  tr("bank_account"),
                                  style: TextStyle(
                                    color: bloc.isBankAcount
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Space(boxWidth: 10.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => bloc.selectWallet(false),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: !bloc.isBankAcount
                                    ? mainColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: Text(
                                  tr("wallet"),
                                  style: TextStyle(
                                    color: !bloc.isBankAcount
                                        ? Colors.white
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Space(boxHeight: 20.h),
                    if (bloc.isBankAcount) ...[
                      MasterTextField(
                        controller: bloc.swiftCode,
                        hintText: tr("swift_code"),
                        errorText: bloc.validators.isNotEmpty
                            ? bloc.validators[0]
                            : null,
                        onChanged: (val) => bloc.validate(val, 0),
                      ),
                      Space(boxHeight: 12.h),
                      MasterTextField(
                        controller: bloc.bankName,
                        hintText: tr("bank_name"),
                        errorText: bloc.validators.length > 1
                            ? bloc.validators[1]
                            : null,
                        onChanged: (val) => bloc.validate(val, 1),
                      ),
                      Space(boxHeight: 12.h),
                      MasterTextField(
                        controller: bloc.iban,
                        hintText: tr("iban"),
                        errorText: bloc.validators.length > 2
                            ? bloc.validators[2]
                            : null,
                        onChanged: (val) => bloc.validate(val, 2),
                      ),
                      Space(boxHeight: 12.h),
                      MasterTextField(
                        controller: bloc.address,
                        hintText: tr("address"),
                        errorText: bloc.validators.length > 3
                            ? bloc.validators[3]
                            : null,
                        onChanged: (val) => bloc.validate(val, 3),
                      ),
                    ] else ...[
                      MasterTextField(
                        controller: bloc.walletName,
                        hintText: tr("wallet_name"),
                        errorText: bloc.validators.isNotEmpty
                            ? bloc.validators[0]
                            : null,
                        onChanged: (val) => bloc.validate(val, 0),
                      ),
                      Space(boxHeight: 12.h),
                      MasterTextField(
                        controller: bloc.walletNumber,
                        hintText: tr("wallet_number"),
                        errorText: bloc.validators.length > 1
                            ? bloc.validators[1]
                            : null,
                        onChanged: (val) => bloc.validate(val, 1),
                      ),
                      Space(boxHeight: 12.h),
                      MasterTextField(
                        controller: bloc.address,
                        hintText: tr("address"),
                        errorText: bloc.validators.length > 2
                            ? bloc.validators[2]
                            : null,
                        onChanged: (val) => bloc.validate(val, 2),
                      ),
                    ],
                    Space(boxHeight: 30.h),
                    MasterLoadButton(
                      buttonController: bloc.addController,
                      buttonText: tr("save"),
                      onPressed: () => bloc.addBankAccount(),
                    ),
                    Space(boxHeight: 30.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
