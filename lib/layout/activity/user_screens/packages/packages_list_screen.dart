import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../bloc/package/package_cubit.dart';
import '../../../../model/common/packages/package_model.dart';
import '../../../../repository/common/packages/package_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/loader/loader.dart';
import '../../../view/connectivity/connectivity_view.dart';
import 'my_subscriptions_screen.dart';
import 'package_details_screen.dart';

class PackagesListScreen extends StatelessWidget {
  final int? providerId;

  const PackagesListScreen({super.key, this.providerId});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? queryParams =
        providerId != null ? {'provider_id': providerId} : null;

    return BlocProvider(
      create: (context) =>
          PackageCubit(PackageRepository())..getPackages(queryParams: queryParams),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            tr("monthly_packages"),
            style: TextStyle(color: mainColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: mainColor, size: 22.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.to(() => const MySubscriptionsScreen()),
              child: Text(
                tr("my_subscriptions"),
                style: TextStyle(fontSize: 12.sp, color: mainColor),
              ),
            ),
          ],
        ),
        body: ConnectivityView(
          child: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {
              if (state is PackageLoadingState) {
                return const Center(child: Loading());
              }
              if (state is PackageLoadedState) {
                if (state.packages.isEmpty) {
                  return Center(
                    child: Text(
                      tr("no_data"),
                      style: TextStyle(fontSize: 16.sp, color: grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.packages.length,
                  itemBuilder: (context, index) {
                    return _buildPackageCard(
                        context, state.packages[index]);
                  },
                );
              }
              if (state is PackageErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyle(fontSize: 14.sp, color: red),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: () => PackageCubit.get(context)
                            .getPackages(queryParams: queryParams),
                        child: Text(tr("retry")),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, PackageModel package) {
    return InkWell(
      onTap: () {
        Get.to(() => PackageDetailsScreen(package: package));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: grey.withValues(alpha: 0.1),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getTypeLabel(package.type ?? ''),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      package.price?.toStringAsFixed(2) ?? '0.00',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              if (package.providerName != null)
                Row(
                  children: [
                    Icon(Icons.person, size: 16.sp, color: grey),
                    SizedBox(width: 4.w),
                    Text(
                      package.providerName!,
                      style: TextStyle(fontSize: 14.sp, color: darkGrey),
                    ),
                  ],
                ),
              SizedBox(height: 4.h),
              if (package.subjectName != null)
                Row(
                  children: [
                    Icon(Icons.book, size: 16.sp, color: grey),
                    SizedBox(width: 4.w),
                    Text(
                      package.subjectName!,
                      style: TextStyle(fontSize: 14.sp, color: darkGrey),
                    ),
                  ],
                ),
              if (package.educationalStageName != null) ...[
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.school, size: 16.sp, color: grey),
                    SizedBox(width: 4.w),
                    Text(
                      package.educationalStageName!,
                      style: TextStyle(fontSize: 14.sp, color: darkGrey),
                    ),
                  ],
                ),
              ],
              if (package.sessionCount != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.sp, color: mainColor),
                    SizedBox(width: 4.w),
                    Text(
                      '${package.sessionCount} ${tr("sessions_remaining")}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
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
