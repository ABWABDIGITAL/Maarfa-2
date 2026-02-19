import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../activity/user_screens/request/course_pay/pay_screen.dart';

class RequestSubjectCard extends StatelessWidget {
  const RequestSubjectCard({
    super.key,
    required this.lessonTitle,
    required this.lessonId,
    required this.id,
    required this.name,
    required this.price,
    required this.onlineCheck,
    required this.acceptanceCheck,
    required this.onTap,
  });

  final String lessonTitle;
  final int id, lessonId;
  final String name;
  final String price;
  final String onlineCheck;
  final String acceptanceCheck;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusConfig();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: acceptanceCheck.toLowerCase() == 'accepted'
              ? () => Get.to(() => PayScreen(
                  type: 'lesson', id: lessonId, isRequest: true, requestId: id))
              : onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: avatar area + content
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar — flat colored circle, no gradient
                    _Avatar(name: name),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subject title
                          Text(
                            lessonTitle,
                            style: TextStyle(
                              fontFamily: 'Shamel',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF272727),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Teacher name
                          Row(
                            children: [
                              const Icon(Icons.person_outline_rounded,
                                  size: 13, color: Color(0xFF707070)),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontFamily: 'Shamel',
                                    fontSize: 12.sp,
                                    color: const Color(0xFF707070),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Price
                          Row(
                            children: [
                              const Icon(Icons.attach_money_rounded,
                                  size: 13, color: Color(0xFF065F46)),
                              SizedBox(width: 2.w),
                              Text(
                                '$price ${tr("sar")}',
                                style: TextStyle(
                                  fontFamily: 'Shamel',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF065F46),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Request ID badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: const Color(0xFFE8E8E8), width: 1),
                      ),
                      child: Text(
                        '#$id',
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 11.sp,
                          color: const Color(0xFF707070),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Divider
                const Divider(
                    color: Color(0xFFE8E8E8), thickness: 1, height: 1),

                SizedBox(height: 10.h),

                // Bottom row: online badge + status + action
                Row(
                  children: [
                    // Online/Offline pill
                    _Pill(
                      label: tr('online'),
                      bgColor: const Color(0xFFEEF2FF),
                      textColor: const Color(0xFF3F2571),
                      icon: Icons.wifi_rounded,
                    ),
                    const Spacer(),
                    // Status pill
                    _Pill(
                      label: status.label,
                      bgColor: status.bgColor,
                      textColor: status.textColor,
                      icon: status.icon,
                    ),
                    SizedBox(width: 8.w),
                    // Action button
                    if (acceptanceCheck.toLowerCase() == 'accepted')
                      _ActionButton(
                        label: tr('pay_now'),
                        color: const Color(0xFF065F46),
                        onTap: () => Get.to(() => PayScreen(
                              type: 'lesson',
                              id: lessonId,
                              isRequest: true,
                              requestId: id,
                            )),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _StatusConfig _statusConfig() {
    switch (acceptanceCheck.toLowerCase()) {
      case 'accepted':
        return _StatusConfig(
          label: tr('accepted'),
          bgColor: const Color(0xFFD1FAE5),
          textColor: const Color(0xFF065F46),
          icon: Icons.check_circle_outline_rounded,
        );
      case 'pending':
        return _StatusConfig(
          label: tr('pending'),
          bgColor: const Color(0xFFFFF3CD),
          textColor: const Color(0xFF856404),
          icon: Icons.hourglass_empty_rounded,
        );
      case 'rejected':
        return _StatusConfig(
          label: tr('rejected'),
          bgColor: const Color(0xFFFFE4E6),
          textColor: const Color(0xFF9F1239),
          icon: Icons.cancel_outlined,
        );
      case 'paid':
        return _StatusConfig(
          label: tr('paid'),
          bgColor: const Color(0xFFEEF2FF),
          textColor: const Color(0xFF3F2571),
          icon: Icons.payment_rounded,
        );
      default:
        return _StatusConfig(
          label: acceptanceCheck,
          bgColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF6B7280),
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

// ── Sub-widgets ────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    const bgColors = [
      Color(0xFFE8F4FD),
      Color(0xFFFFF3E0),
      Color(0xFFE8F5E9),
      Color(0xFFFCE4EC),
      Color(0xFFEDE7F6),
    ];
    const fgColors = [
      Color(0xFF1565C0),
      Color(0xFFE65100),
      Color(0xFF2E7D32),
      Color(0xFFC62828),
      Color(0xFF4527A0),
    ];
    final idx = initial.codeUnitAt(0) % bgColors.length;

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: bgColors[idx],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: fgColors[idx],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const _Pill({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: textColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Shamel',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Shamel',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });
}
