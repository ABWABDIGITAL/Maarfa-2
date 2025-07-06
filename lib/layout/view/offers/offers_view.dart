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
            final data = state.data;
            return _buildOffersView(context, data);
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
    return Container(
      color: Colors.grey[50], // Light background for better contrast
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        itemCount: data?.length ?? 0,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _buildOfferCard(context, data[index]);
        },
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, dynamic offer) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.h),
          onTap: () {
            // Handle offer tap
            _handleOfferTap(context, offer);
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildOfferImage(offer),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildOfferContent(offer),
                ),
                _buildArrowIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfferImage(dynamic offer) {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        color: cvBackgroundColor,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CachedImage(
            imageUrl: offer?.image ?? '',
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferContent(dynamic offer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offer?.name ?? 'No title',
          style: TextStyles.textView14SemiBold.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        Text(
          offer?.content ?? 'No description available',
          style: TextStyles.hintStyle.copyWith(
            fontSize: 14.sp,
            color: Colors.grey[600],
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.h),
        _buildOfferBadge(),
      ],
    );
  }

  Widget _buildOfferBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(6.h),
        border: Border.all(
          color: Colors.green[200]!,
          width: 0.5,
        ),
      ),
      child: Text(
        'Special Offer',
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
        color: Colors.grey[600],
      ),
    );
  }

  void _handleOfferTap(BuildContext context, dynamic offer) {
    // Implement navigation or action when offer is tapped
    // print('Offer tapped: ${offer?.name}');

    // Example: Show a snackbar with feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${offer?.name ?? 'offer'}...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../bloc/home/home_cubit.dart';
// import '../../../repository/provider/home/home_repository.dart';
// import '../../../res/value/color/color.dart';
// import '../../../res/value/dimenssion/dimenssions.dart';
// import '../../../res/value/style/textstyles.dart';
// import '../../../widget/error/page/error_page.dart';
// import '../../../widget/image_handler/image_from_network/network_image.dart';
// import '../../../widget/loader/loader.dart';
// import '../../../widget/master_list/custom_list.dart';
// import '../../../widget/side_padding/side_padding.dart';
// import '../../../widget/space/space.dart';
//
// class OffersView extends StatelessWidget {
//   const OffersView({super.key});
//   @override
//   Widget build(final BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) =>
//             HomeCubit(HomeRepository())..getOffers(),
//         child: BlocConsumer<HomeCubit, HomeState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               if (state is OffersLoadedState) {
//                 final data = state.data;
//                 return offersView(context, data);
//               } else if (state is OffersErrorState) {
//                 return const ErrorPage();
//               } else {
//                 return const Loading();
//               }
//             }));
//   }
//
//   offersView(context, data) {
//     return ListView(
//       children: [
//         CustomList(
//           child: (context, index) => SidePadding(
//               // sidePadding: 15,
//               child: Column(
//                 children: [
//                   const Space(
//                     boxHeight: 10,
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         clipBehavior: Clip.antiAliasWithSaveLayer,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.h),
//                           color: cvBackgroundColor
//                         ),
//                         child: CachedImage(
//                           imageUrl: data![index].image!,
//                           width: 90.w,
//                           height: 90.h,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SidePadding(
//                         sidePadding: 15,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(data![index].name!,
//                                 style: TextStyles.textView14SemiBold),
//                             SizedBox(
//                               width: screenWidth * 2 / 3,
//                               child: Text(data![index].content!,
//                                   // maxLines: 1,
//                                   softWrap: true,
//                                   style: TextStyles.hintStyle),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Space(
//                     boxHeight: 10,
//                   ),
//                   const Divider(),
//                 ],
//               )),
//           axis: Axis.vertical,
//           listHeight: screenHeight,
//           count: data.length,
//           scroll: const NeverScrollableScrollPhysics(),
//         ),
//       ],
//     );
//   }
// }
