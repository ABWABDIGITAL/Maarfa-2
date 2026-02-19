import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../model/common/notifications/notification_model.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../activity/provider_screens/requests_sent/requests_sent_screen.dart';
import '../../activity/user_screens/request/course_pay/pay_screen.dart';

class NotificationsCard extends StatelessWidget {
  final NotificationModel data;
  final bool? isInProvider;
  final bool isRead;

  const NotificationsCard({
    super.key,
    required this.data,
    this.isInProvider = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(14.r),
        border: _buildDirectionalBorder(context),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: _iconBgColor(),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                _icon(),
                color: _iconColor(),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _title(),
                          style: TextStyle(
                            fontFamily: 'Shamel',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                            height: 1.3,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _relativeTime(),
                        style: TextStyle(
                          fontFamily: 'Shamel',
                          fontSize: 11.sp,
                          color: const Color(0xFF707070),
                        ),
                      ),
                    ],
                  ),

                  if ((data.title ?? '').isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      data.title!,
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 13.sp,
                        color: const Color(0xFF707070),
                        height: 1.4,
                      ),
                    ),
                  ],

                  if ((data.text ?? '').isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(
                      data.text!,
                      style: TextStyle(
                        fontFamily: 'Shamel',
                        fontSize: 12.sp,
                        color: const Color(0xFF707070),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  if (_hasAction()) ...[
                    SizedBox(height: 10.h),
                    _actionButton(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── helpers ──────────────────────────────────────────────────

  Border _buildDirectionalBorder(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.RTL;
    final accentSide = BorderSide(
      color: isRead ? const Color(0xFFE8E8E8) : mainColor,
      width: isRead ? 1 : 3,
    );
    const plainSide = BorderSide(color: Color(0xFFE8E8E8), width: 1);
    return Border(
      left: isRtl ? plainSide : accentSide,
      right: isRtl ? accentSide : plainSide,
      top: plainSide,
      bottom: plainSide,
    );
  }

  IconData _icon() {
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
        return Icons.school_rounded;
      case 'YourRequestWasAccepted.Lesson':
        return Icons.menu_book_rounded;
      case 'YouHaveNewRequest.Course':
        return Icons.assignment_rounded;
      case 'YouHaveNewRequest.Lesson':
        return Icons.edit_note_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _iconBgColor() {
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
      case 'YourRequestWasAccepted.Lesson':
        return const Color(0xFFD1FAE5);
      case 'YouHaveNewRequest.Course':
      case 'YouHaveNewRequest.Lesson':
        return const Color(0xFFFFF4EB);
      default:
        return const Color(0xFFEEF2FF);
    }
  }

  Color _iconColor() {
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
      case 'YourRequestWasAccepted.Lesson':
        return const Color(0xFF065F46);
      case 'YouHaveNewRequest.Course':
      case 'YouHaveNewRequest.Lesson':
        return mainColor;
      default:
        return const Color(0xFF3F2571);
    }
  }

  String _title() {
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
        return tr('course_request_accepted');
      case 'YourRequestWasAccepted.Lesson':
        return tr('lesson_request_accepted');
      case 'YouHaveNewRequest.Course':
        return tr('new_course_request');
      case 'YouHaveNewRequest.Lesson':
        return tr('new_lesson_request');
      default:
        return tr('notification');
    }
  }

  bool _hasAction() => [
        'YourRequestWasAccepted.Course',
        'YourRequestWasAccepted.Lesson',
        'YouHaveNewRequest.Course',
        'YouHaveNewRequest.Lesson',
      ].contains(data.type);

  String _actionLabel() {
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
      case 'YourRequestWasAccepted.Lesson':
        return tr('proceed_to_payment');
      default:
        return tr('view_request');
    }
  }

  VoidCallback _actionTap() {
    final rawId = data.objectId;
    final id = rawId is int ? rawId : int.tryParse(rawId.toString()) ?? 0;
    switch (data.type) {
      case 'YourRequestWasAccepted.Course':
        return () => Get.to(() => PayScreen(id: id, type: 'course'));
      case 'YourRequestWasAccepted.Lesson':
        return () => Get.to(() => PayScreen(id: id, type: 'lesson'));
      case 'YouHaveNewRequest.Course':
        return () => Get.to(() => RequestsSentScreen(id: id, type: 'course'));
      case 'YouHaveNewRequest.Lesson':
        return () => Get.to(() => RequestsSentScreen(id: id, type: 'lesson'));
      default:
        return () {};
    }
  }

  Widget _actionButton() {
    final isPayment = data.type?.contains('Accepted') ?? false;
    return GestureDetector(
      onTap: _actionTap(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isPayment ? const Color(0xFF065F46) : mainColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _actionLabel(),
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

  String _relativeTime() {
    final raw = data.createdAt;
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return tr('just_now');
      if (diff.inHours < 1) {
        return tr('minutes_ago', args: [diff.inMinutes.toString()]);
      }
      if (diff.inDays < 1) {
        return tr('hours_ago', args: [diff.inHours.toString()]);
      }
      if (diff.inDays < 7) {
        return tr('days_ago', args: [diff.inDays.toString()]);
      }
      return DateFormat('MMM d').format(dt);
    } catch (_) {
      return raw;
    }
  }
}
