// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../res/drawable/icon/icons.dart';
// import '../../../../../res/drawable/image/images.dart';
// import '../../../../../res/value/color/color.dart';
// import '../../../../../res/value/dimenssion/dimenssions.dart';
// import '../../../../../res/value/style/textstyles.dart';
// import '../../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
// import '../../../../../widget/buttons/master/master_button.dart';
// import '../../../../../widget/side_padding/side_padding.dart';
// import '../../../../../widget/space/space.dart';

// class BankAccount extends StatelessWidget {
//   const BankAccount({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: FractionalOffset.topCenter,
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.red,
//           child: Image.asset(
//             staticBackground,
//             fit: BoxFit.fill,
//           ),
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: DefaultAppBar(title: tr("bank_account")),
//           body: SidePadding(
//             sidePadding: 20,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 100),
//                   child: Container(
//                     height: 150.h,
//                     width: 200,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                           image: AssetImage(wallet), fit: BoxFit.contain),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     Text(tr("amount_found"),
//                         style: TextStyles.headerStyle.copyWith(
//                           color: black,
//                         )),
//                     Text(tr("2.000"),
//                         style: TextStyles.headerStyle.copyWith(
//                           color: mainColor,
//                         )),
//                     Text(tr("sar"),
//                         style: TextStyles.headerStyle.copyWith(
//                           color: mainColor,
//                           fontSize: 16,
//                         )),
//                   ],
//                 ),
//                 Text(
//                   tr("bank_account"),
//                   style: TextStyles.appBarStyle
//                       .copyWith(color: black, fontSize: 16),
//                 ),
//                 Container(
//                   width: screenWidth,
//                   height: 200,
//                   color: mainColor.withValues(alpha:0.1),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(plusIcon),
//                       Text(
//                         tr("add_bank"),
//                         style: TextStyles.appBarStyle
//                             .copyWith(color: mainColor, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Space(
//                   boxHeight: 40,
//                 ),
//                 MasterButton(
//                   buttonText: tr("reckoning"),
//                   onPressed: () {},
//                 ),
//                 const Space(
//                   boxHeight: 10,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
