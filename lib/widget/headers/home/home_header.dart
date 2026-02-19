import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../layout/activity/notifications/notifications_screen.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../buttons/notification_button/notification_button.dart';

class HomeHeader extends StatelessWidget {
  final bool isNotify, isUser;
  final dynamic data;

  const HomeHeader({
    super.key,
    this.isNotify = true,
    required this.isUser,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl = isUser
        ? (data.data.user.image ?? '')
        : (data.data.authUser.imagePath ?? '');
    final String firstName = isUser
        ? (data.data.user.firstName ?? '')
        : (data.data.authUser.firstName ?? '');
    final String lastName = isUser
        ? (data.data.user.lastName ?? '')
        : (data.data.authUser.lastName ?? '');
    final String title = isUser ? '' : (data.data.authUser.title ?? '');
    final String fullName = '$title $firstName $lastName'.trim();
    final String initial =
        fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          // Avatar with network image + fallback
          _Avatar(imageUrl: imageUrl, initial: initial),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr("welcome_back"),
                  style: TextStyles.hintStyle.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.textView16SemiBold.copyWith(
                    color: primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NotificationButton(
            count: data.notificationsCount,
            onTap: () => isUser
                ? Get.to(const NotificationsScreen(isUser: true))
                : Get.to(const NotificationsScreen(isUser: false)),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  final String initial;

  const _Avatar({required this.imageUrl, required this.initial});

  @override
  Widget build(BuildContext context) {
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
    final idx =
        initial.isNotEmpty ? initial.codeUnitAt(0) % bgColors.length : 0;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColors[idx],
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1.5),
      ),
      child: ClipOval(
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _InitialFallback(
                  initial: initial,
                  fgColor: fgColors[idx],
                ),
              )
            : _InitialFallback(
                initial: initial,
                fgColor: fgColors[idx],
              ),
      ),
    );
  }
}

class _InitialFallback extends StatelessWidget {
  final String initial;
  final Color fgColor;

  const _InitialFallback({required this.initial, required this.fgColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: fgColor,
        ),
      ),
    );
  }
}
