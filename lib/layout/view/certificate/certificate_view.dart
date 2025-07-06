import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../model/provider/certificate/certificate_data.dart';
import '../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/alert/delete/delete_alert.dart';
import '../../../widget/buttons/master/master_button.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/provider_screens/certificate/add_certificate_screen.dart';
import '../../activity/static/empty_screens/empty_screens.dart';

class CertificateView extends StatelessWidget {
  const CertificateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthProviderCubit(AuthProviderRepository())..getCertificate(),
        child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<AuthProviderCubit, AuthProviderState>(
                  builder: (context, state) {
                if (state is CertificateLoadedState) {
                  final data = (state).data;
                  return certificateView(context, data);
                } else if (state is CertificateErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              });
            }));
  }

  certificateView(context, CertificateData? data) {
    return BlocProvider(
        create: (BuildContext context) =>
            AuthProviderCubit(AuthProviderRepository()),
        child: BlocConsumer<AuthProviderCubit, AuthProviderState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AuthProviderCubit.get(context);
              return SidePadding(
                sidePadding: 30,
                child: ListView(
                  children: [
                    Text(
                      tr("certificate"),
                      style: TextStyles.introStyle
                          .copyWith(color: black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tr("certificate_note"),
                      style: TextStyles.hintStyle,
                    ),
                    const Space(
                      boxHeight: 10,
                    ),
                    data!.certificates.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmptyScreen(
                                title: tr("no_certificate"),
                                image: emptyCurrent,
                                width: screenWidth,
                                height: 300.h,
                                color: mainColor.withValues(alpha: 0.3),
                              ),
                            ],
                          )
                        : CustomList(
                            listHeight: 10000000000000,
                            count: data.certificates.length,
                            child: (context, index) => Stack(
                              alignment: FractionalOffset.topLeft,
                              children: [
                                Card(
                                  color: profileColor,
                                  child: SizedBox(
                                    width: screenWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.asset(terms,
                                              height: 130.h,
                                              width: 100.w,
                                              fit: BoxFit.contain),
                                          const Space(
                                            boxHeight: 30,
                                          ),
                                          Text(
                                              data.certificates[index].url
                                                  .toString()
                                                  .split('/')
                                                  .last,
                                              textAlign: TextAlign.center,
                                              style: TextStyles.appBarStyle
                                                  .copyWith(
                                                      color: black,
                                                      fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () => deleteAlert(
                                        deleteTap: () => bloc.deleteCertificate(
                                            data.certificates[index].id)),
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20.h,
                                      color: circleColor,
                                    )),
                              ],
                            ),
                          ),
                    const Space(
                      boxHeight: 25,
                    ),
                    MasterButton(
                      // buttonController: bloc.authController,
                      buttonText: tr("add_certificate"),
                      onPressed: () =>
                          Get.to(() => const AddCertificateScreen()),
                    ),
                    const Space(
                      boxHeight: 10,
                    ),
                  ],
                ),
              );
            }));
  }
}
