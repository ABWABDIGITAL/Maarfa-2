// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../res/value/color/color.dart';
// import '../../../res/value/style/textstyles.dart';

// class ProfileButton extends StatelessWidget {
//   final String title, image;
//   final VoidCallback? onTap;
//   final bool isLogout;
//   const ProfileButton(
//       {super.key,
//       required this.title,
//       required this.image,
//       this.onTap,
//       this.isLogout = false});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//               color:
//                   isLogout ? const Color(0xffFFEAEA) : const Color(0xffDDE3E7),
//               borderRadius: BorderRadius.circular(12)),
//           child: Row(
//             children: [
//               const SizedBox(width: 16),
//               if (image.isNotEmpty)
//                 SvgPicture.asset(image, height: 25)
//               else
//                 const SizedBox(width: 25),
//               const SizedBox(width: 16),
//               Text(title,
//                   style: TextStyles.appBarStyle.copyWith(
//                       color: primaryText, fontWeight: FontWeight.bold)),
//               const Spacer(),
//               if (!isLogout)
//                 const Icon(
//                   Icons.arrow_forward_ios,
//                   color: primaryText,
//                 ),
//               const SizedBox(
//                 width: 16,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class ProfileButton extends StatelessWidget {
  final String title, image;
  final VoidCallback? onTap;
  final bool isLogout;
  const ProfileButton({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white, // Background white
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              if (image.isNotEmpty)
                SvgPicture.asset(
                  image,
                  height: 25,
                )
              else
                const SizedBox(width: 25),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyles.appBarStyle.copyWith(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (!isLogout)
                Icon(
                  Icons.arrow_forward_ios,
                  color: mainColor, // Arrow is mainColor now
                  size: 18,
                ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
