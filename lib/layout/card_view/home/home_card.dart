import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class RightHomeCard extends StatelessWidget {
  final String title, subTitle, buttonText, image;
  final VoidCallback? onTap;
  final Color? cardColor;

  const RightHomeCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.image,
    required this.subTitle,
    this.onTap,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = cardColor ?? accentColor;
    return _HomeCard(
      title: title,
      subTitle: subTitle,
      buttonText: buttonText,
      image: image,
      onTap: onTap,
      cardColor: bg,
      imageOnRight: true,
    );
  }
}

class LeftHomeCard extends StatelessWidget {
  final String title, subTitle, buttonText, image;
  final VoidCallback? onTap;
  final Color? cardColor;
  // Legacy params — kept for call-site compatibility, ignored
  final bool isEnabled;
  final String? semanticLabel;
  final IconData? leadingIcon;
  final Color? primaryColor;
  final Color? secondaryColor;

  const LeftHomeCard({
    super.key,
    required this.title,
    required this.buttonText,
    required this.image,
    required this.subTitle,
    this.onTap,
    this.cardColor,
    this.isEnabled = true,
    this.semanticLabel,
    this.leadingIcon,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = cardColor ?? mainColor;
    return _HomeCard(
      title: title,
      subTitle: subTitle,
      buttonText: buttonText,
      image: image,
      onTap: onTap,
      cardColor: bg,
      imageOnRight: false,
    );
  }
}

// ── Shared implementation ─────────────────────────────────────────────────────

class _HomeCard extends StatefulWidget {
  final String title, subTitle, buttonText, image;
  final VoidCallback? onTap;
  final Color cardColor;
  final bool imageOnRight;

  const _HomeCard({
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.image,
    required this.onTap,
    required this.cardColor,
    required this.imageOnRight,
  });

  @override
  State<_HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<_HomeCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: widget.cardColor.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(22.w),
              child: Row(
                children: widget.imageOnRight
                    ? [_content(), _image()]
                    : [_image(), SizedBox(width: 16.w), _content()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.subTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          _button(),
        ],
      ),
    );
  }

  Widget _image() {
    return SizedBox(
      width: 100.w,
      height: 120.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Image.asset(
          widget.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.image_outlined,
              color: Colors.white.withValues(alpha: 0.6),
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: widget.cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
        minimumSize: Size(0, 40.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.buttonText,
            style: TextStyles.errorStyle.copyWith(
              color: widget.cardColor,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(Icons.arrow_forward_rounded, size: 16.sp),
        ],
      ),
    );
  }
}
