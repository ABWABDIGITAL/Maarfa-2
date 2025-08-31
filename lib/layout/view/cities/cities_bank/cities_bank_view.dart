import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/model/common/cities/city_model.dart';

import '../../../../bloc/bank_account/bank_account_cubit.dart';
import '../../../../bloc/cities/cities_cubit.dart';
import '../../../../repository/provider/bank_account/bank_account_repository.dart';
import '../../../../res/drawable/icon/icons.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/buttons/master_load/master_load_button.dart';
import '../../../../widget/dropdown/dropdown/dropdown.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';

class CitiesBankView extends StatelessWidget {
  const CitiesBankView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocConsumer<CitiesCubit, CitiesState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocBuilder<CitiesCubit, CitiesState>(
              builder: (context, state) {
            if (state is AuthCityLoadedState) {
              final data = (state).data;
              return cityView(context, data!);
            } else if (state is CitiesLoadErrorState) {
              return const ErrorPage();
            } else {
              return const Loading();
            }
          });
        });
  }

  cityView(BuildContext context, List<CityModel> cities) {
    return BlocProvider(
        create: (BuildContext context) =>
            BankAccountCubit(BankAccountRepository()),
        child: BlocConsumer<BankAccountCubit, BankAccountState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = BankAccountCubit.get(context);
              return SidePadding(
                sidePadding: 30,
                child: ListView(
                  children: [
                    PaymentOption(
                      title: tr("bank_account"),
                      selected: bloc.isBankAcount,
                      onTap: () => bloc.selectWallet(true),
                    ),
                    SizedBox(height: 20),
                    PaymentOption(
                      title: tr("wallet"),
                      selected: !bloc.isBankAcount,
                      onTap: () => bloc.selectWallet(false),
                    ),
                    SizedBox(height: 20),
                    if (bloc.isBankAcount) ...[
                      MasterTextField(
                        controller: bloc.swiftCode,
                        hintText: "SWIFT Code",
                        errorText: bloc.validators[0],
                        onChanged: (val) => bloc.validate(val, 0),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.bankName,
                        hintText: tr("bank_name"),
                        errorText: bloc.validators[1],
                        onChanged: (val) => bloc.validate(val, 1),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.iban,
                        hintText: tr("IBAN"),
                        errorText: bloc.validators[2],
                        onChanged: (val) => bloc.validate(val, 2),
                      ),
                    ] else ...[
                      MasterTextField(
                        controller: bloc.walletName,
                        keyboardType: TextInputType.number,
                        hintText: tr("wallet_name"),
                        errorText: bloc.validators[0],
                        onChanged: (val) => bloc.validate(val, 0),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                      MasterTextField(
                        controller: bloc.walletNumber,
                        hintText: tr("wallet_number"),
                        errorText: bloc.validators[1],
                        onChanged: (val) => bloc.validate(val, 1),
                      ),
                    ],
                    const Space(
                      boxHeight: 15,
                    ),
                    MasterTextField(
                      controller: bloc.address,
                      hintText: tr("address"),
                      errorText: bloc.validators[3],
                      onChanged: (val) => bloc.validate(val, 3),
                    ),
                    const Space(
                      boxHeight: 15,
                    ),
                    BuildDropDown(
                      isExpanded: true,
                      value: bloc.city,
                      onChange: (val) => bloc.chooseCity(val),
                      items: cities
                          .map<DropdownMenuItem<dynamic>>((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Center(
                                child: Text("${value.name}",
                                    style: TextStyles.appBarStyle
                                        .copyWith(color: mainColor))));
                      }).toList(),
                      hint: tr("city"),
                      image: city,
                    ),
                    const Space(boxHeight: 100),
                    MasterLoadButton(
                      buttonController: bloc.addController,
                      buttonText: tr("add"),
                      onPressed: () => bloc.addBankAccount(),
                    ),
                  ],
                ),
              );
            }));
  }
}

class PaymentOption extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOption({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? lightColor : white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? mainColor : borderColor,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: mainColor.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? secColor.withValues(alpha: 0.1)
                    : greyColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                title.toLowerCase().contains('bank') || title.contains("بنك")
                    ? Icons.account_balance
                    : Icons.account_balance_wallet,
                color: selected ? mainColor : darkGrey,
                size: 28,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selected ? primaryText : darkGrey,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: mainColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
