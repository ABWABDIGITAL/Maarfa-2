import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/home/home_cubit.dart';
import '../../../repository/provider/home/home_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/loader/loader.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          HomeCubit(HomeRepository())..getOffers(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OffersLoadedState) {
            return _buildOffersView(context, state.data);
          } else if (state is OffersErrorState) {
            return const ErrorPage();
          } else {
            return const Loading();
          }
        },
      ),
    );
  }

  Widget _buildOffersView(BuildContext context, dynamic data) {
    if (data == null || (data as List).isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 52, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              tr('no_offers'),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
      itemCount: data.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => _buildOfferCard(data[index]),
    );
  }

  Widget _buildOfferCard(dynamic offer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail — no overlay gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedImage(
                imageUrl: offer?.image ?? '',
                width: 76.w,
                height: 76.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer?.name ?? '',
                    style: TextStyles.textView14SemiBold.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF272727),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    offer?.content ?? '',
                    style: TextStyles.hintStyle.copyWith(
                      fontSize: 13.sp,
                      color: const Color(0xFF707070),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // "Special Offer" pill — using translation key
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tr('special_offer'),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}
