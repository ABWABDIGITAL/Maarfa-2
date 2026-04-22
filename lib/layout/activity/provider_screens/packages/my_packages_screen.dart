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
import '../../../../widget/loader/loader.dart';
import '../../../../widget/toast/toast.dart';
import '../../../view/connectivity/connectivity_view.dart';
import 'create_package_screen.dart';

class MyPackagesScreen extends StatelessWidget {
  const MyPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PackageCubit(PackageRepository())..getProviderPackages(),
      child: Scaffold(
        appBar: DefaultAppBar(title: tr("my_packages")),
        floatingActionButton: Builder(
          builder: (ctx) => FloatingActionButton(
            backgroundColor: mainColor,
            onPressed: () async {
              await Get.to(() => const CreatePackageScreen());
              if (ctx.mounted) {
                PackageCubit.get(ctx).getProviderPackages();
              }
            },
            child: Icon(Icons.add, color: white, size: 24.sp),
          ),
        ),
        body: ConnectivityView(
          child: BlocConsumer<PackageCubit, PackageState>(
            listener: (context, state) {
              if (state is PackageDeletedState) {
                showToast(tr("success"));
                PackageCubit.get(context).getProviderPackages();
              }
              if (state is PackageErrorState) {
                showToast(state.message);
              }
            },
            builder: (context, state) {
              if (state is PackageLoadingState) {
                return const Center(child: Loading());
              }
              if (state is ProviderPackagesLoadedState) {
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
                  child: Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp, color: red),
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
    return Container(
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (package.isActive ?? false)
                        ? inProgressColor.withValues(alpha: 0.1)
                        : red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    (package.isActive ?? false)
                        ? tr("active")
                        : tr("inactive"),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color:
                          (package.isActive ?? false) ? inProgressColor : red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            if (package.subjectName != null)
              Text(
                package.subjectName!,
                style: TextStyle(fontSize: 14.sp, color: darkGrey),
              ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tr("package_price")}: ${package.price?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: blackColor,
                  ),
                ),
                Text(
                  '${package.subscriptionsCount ?? 0} ${tr("subscriptions")}',
                  style: TextStyle(fontSize: 12.sp, color: grey),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final cubit = PackageCubit.get(context);
                      await Get.to(
                          () => CreatePackageScreen(package: package));
                      cubit.getProviderPackages();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: mainColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          tr("edit"),
                          style:
                              TextStyle(fontSize: 14.sp, color: mainColor),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _showDeleteDialog(context, package.id!);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          tr("delete"),
                          style: TextStyle(fontSize: 14.sp, color: red),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int packageId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(tr("delete")),
        content: Text(tr("are_you_sure")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr("cancel")),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              PackageCubit.get(context).deletePackage(packageId);
            },
            child: Text(tr("delete"), style: const TextStyle(color: red)),
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
