import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/color/color.dart';

import '../../../res/value/style/textstyles.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';

class GradeCard extends StatefulWidget {
  const GradeCard({
    super.key,
    this.isSelected = false,
    this.title,
    this.image,
    this.subtitle,
    required this.id,
    required this.onTap,
    this.isEnabled = true,
  });

  final String? title, image, subtitle;
  final int id;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isEnabled;

  @override
  State<GradeCard> createState() => _GradeCardState();
}

class _GradeCardState extends State<GradeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.isEnabled ? widget.onTap : null,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: mainColor.withValues(alpha: 0.3),
                          blurRadius: 12.r,
                          offset: Offset(0, 4.h),
                          spreadRadius: 0,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? mainColor.withValues(alpha: 0.1)
                        : courseTypeColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: widget.isSelected
                          ? mainColor
                          : Colors.grey.withValues(alpha: 0.2),
                      width: widget.isSelected ? 2.w : 1.w,
                    ),
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      // Image Container with improved styling
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedImage(
                            imageUrl: widget.image ?? "",
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Content section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title
                            Text(
                              widget.title ?? "Grade Title",
                              style: widget.isSelected
                                  ? TextStyles.textView14SemiBold.copyWith(
                                      color: mainColor,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : TextStyles.textView14SemiBold.copyWith(
                                      color: grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Subtitle (optional)
                            if (widget.subtitle != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                widget.subtitle!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: widget.isSelected
                                      ? mainColor.withValues(alpha: 0.7)
                                      : grey.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: widget.isSelected ? 24.w : 0,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: widget.isSelected
                              ? mainColor
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: widget.isSelected
                            ? Icon(
                                Icons.check,
                                color: white,
                                size: 16.sp,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:my_academy/res/value/color/color.dart';
//
// import '../../../res/value/dimenssion/dimenssions.dart';
// import '../../../res/value/style/textstyles.dart';
// import '../../../widget/image_handler/image_from_network/network_image.dart';
//
// class GradeCard extends StatelessWidget {
//   const GradeCard(
//       {super.key,
//       this.isSelected = false,
//       this.title,
//       this.image,
//       required this.id,
//       required this.onTap});
//   final String? title, image;
//   final int id;
//   final VoidCallback? onTap;
//   final bool isSelected;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         semanticContainer: true,
//         shape: RoundedRectangleBorder(
//             side: BorderSide(color: isSelected ? mainColor : textfieldColor),
//             borderRadius: BorderRadius.circular(10.r)),
//         child: Container(
//           height: 85.h,
//           width: screenWidth,
//           color: isSelected ? mainColor : courseTypeColor,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Card(
//                   semanticContainer: true,
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.r),
//                   ),
//                   child: CachedImage(
//                     imageUrl: image ?? "",
//                     width: 60.w,
//                     height: 75.h,
//                     fit: BoxFit.cover,
//                   )),
//               Text(title ?? "",
//                   textAlign: TextAlign.center,
//                   softWrap: true,
//                   style: isSelected
//                       ? TextStyles.textView14SemiBold.copyWith(color: white)
//                       : TextStyles.textView14SemiBold.copyWith(color: grey)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
