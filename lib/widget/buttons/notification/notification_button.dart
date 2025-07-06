// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../layout/activity/auth/register/user/notifications_screen.dart';
// import '../../../layout/activity/notifications/notifications_screen.dart';
// import '../../../res/value/color/color.dart';
//
// class NotificationButton extends StatelessWidget {
//   const NotificationButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Get.to(const NotificationsScreen(isUser: true,));
//       },
//       child: Container(
//         width: 45.w,
//         height: 45.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5.r),
//           border: Border.all(color: white),
//           color: white.withValues(alpha:0.1),
//         ),
//         child: const Center(
//             child: Icon(Icons.notifications_none_outlined,
//                 color: white, size: 20)),
//       ),
//     );
//   }
// }
