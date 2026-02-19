import 'package:flutter/material.dart';
import 'value/color/color.dart';

/// Maarfa Design System — single source of truth for all visual tokens.
/// Import this file in any widget that needs spacing, radius, or shadow values.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 32;
  static const double screenPadding = 18;
}

abstract class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}

abstract class AppShadows {
  /// Subtle card shadow — use on all surface cards
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Elevated shadow — bottom sheets, modals, FABs
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  /// Ambient shadow — very subtle, for inline elements
  static List<BoxShadow> get ambient => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];
}

abstract class AppColors {
  // Brand
  static const Color primary = mainColor; // #F19704 amber
  static const Color primaryLight = lightColor; // #FFF4EB
  static const Color secondary = accentColor; // #3F2571 deep purple
  static const Color secondaryLight = boxColor; // #EEF2FF

  // Surfaces
  static const Color surface = white;
  static const Color background = scaffoldBackgroundColor; // #F9FAFB
  static const Color divider = borderColor; // #E8E8E8

  // Text
  static const Color textPrimary = primaryText; // #272727
  static const Color textSecondary = darkGrey; // #707070

  // Semantic
  static const Color success = inProgressColor; // #46B420
  static const Color successLight = inProgressBorderColor; // #CBF8BB
  static const Color error = circleColor; // #FF003E
  static const Color warning = mainColor; // #F19704
  static const Color star = secColor; // #EFB10B amber for ratings

  // Status badge colors
  static const Color pendingBg = Color(0xFFFFF3CD);
  static const Color pendingText = Color(0xFF856404);
  static const Color confirmedBg = Color(0xFFD1FAE5);
  static const Color confirmedText = Color(0xFF065F46);
  static const Color completedBg = Color(0xFFF3F4F6);
  static const Color completedText = Color(0xFF6B7280);
  static const Color cancelledBg = Color(0xFFFFE4E6);
  static const Color cancelledText = Color(0xFF9F1239);
  static const Color unreadNotifBg = Color(0xFFFFF8F0);
}

/// Status badge data — maps API status strings to visual tokens
class StatusConfig {
  final Color background;
  final Color textColor;
  final String label;
  final IconData icon;

  const StatusConfig({
    required this.background,
    required this.textColor,
    required this.label,
    required this.icon,
  });

  static StatusConfig fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const StatusConfig(
          background: AppColors.pendingBg,
          textColor: AppColors.pendingText,
          label: 'Pending',
          icon: Icons.hourglass_empty_rounded,
        );
      case 'confirmed':
      case 'accepted':
        return const StatusConfig(
          background: AppColors.confirmedBg,
          textColor: AppColors.confirmedText,
          label: 'Confirmed',
          icon: Icons.check_circle_outline_rounded,
        );
      case 'completed':
        return const StatusConfig(
          background: AppColors.completedBg,
          textColor: AppColors.completedText,
          label: 'Completed',
          icon: Icons.done_all_rounded,
        );
      case 'cancelled':
      case 'rejected':
        return const StatusConfig(
          background: AppColors.cancelledBg,
          textColor: AppColors.cancelledText,
          label: 'Cancelled',
          icon: Icons.cancel_outlined,
        );
      default:
        return const StatusConfig(
          background: AppColors.completedBg,
          textColor: AppColors.completedText,
          label: 'Unknown',
          icon: Icons.help_outline_rounded,
        );
    }
  }
}
