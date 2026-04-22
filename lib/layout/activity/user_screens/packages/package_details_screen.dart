import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/package/package_cubit.dart';
import '../../../../model/common/packages/package_model.dart';
import '../../../../repository/common/packages/package_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/toast/toast.dart';
import '../../../view/connectivity/connectivity_view.dart';
import 'my_subscriptions_screen.dart';

class PackageDetailsScreen extends StatelessWidget {
  final PackageModel package;

  const PackageDetailsScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageCubit(PackageRepository()),
      child: Scaffold(
        appBar: DefaultAppBar(title: tr("packages")),
        body: ConnectivityView(
          child: BlocConsumer<PackageCubit, PackageState>(
            listener: (context, state) {
              if (state is SubscribedToPackageState) {
                showToast(tr("success"));
                Get.off(() => const MySubscriptionsScreen());
              }
              if (state is PackageErrorState) {
                showToast(state.message);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Package Type Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: blueGradient,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getTypeLabel(package.type ?? ''),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            package.price?.toStringAsFixed(2) ?? '0.00',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          if (package.sessionCount != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              '${package.sessionCount} ${tr("sessions_remaining")}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Provider Info
                    if (package.providerName != null)
                      _buildInfoRow(
                        Icons.person,
                        tr("provider"),
                        package.providerName!,
                      ),

                    // Subject
                    if (package.subjectName != null)
                      _buildInfoRow(
                        Icons.book,
                        tr("subject"),
                        package.subjectName!,
                      ),

                    // Educational Stage
                    if (package.educationalStageName != null)
                      _buildInfoRow(
                        Icons.school,
                        tr("educational_stage"),
                        package.educationalStageName!,
                      ),

                    // Package Type
                    _buildInfoRow(
                      Icons.category,
                      tr("package_type"),
                      _getTypeLabel(package.type ?? ''),
                    ),

                    // Description
                    if (package.description != null &&
                        package.description!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      Text(
                        tr("description"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: semiGray,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          package.description!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: darkGrey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 30.h),

                    // Subscribe Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: state is PackageLoadingState
                            ? null
                            : () {
                                _showSubscribeDialog(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: state is PackageLoadingState
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                tr("subscribe_to_package"),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: mainColor),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: blackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr("subscribe_to_package")),
        content: Text(
          '${tr("are_you_sure")}\n${tr("package_price")}: ${package.price?.toStringAsFixed(2)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr("cancel")),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              PackageCubit.get(context).subscribeToPackage(package.id!);
            },
            child: Text(
              tr("subscribe_to_package"),
              style: const TextStyle(color: mainColor),
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case '4_sessions':
        return tr("sessions_4");
      case '8_sessions':
        return tr("sessions_8");
      case '12_sessions':
        return tr("sessions_12");
      case 'full_term':
        return tr("full_term");
      default:
        return type;
    }
  }
}
