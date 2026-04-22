import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/package/package_cubit.dart';
import '../../../../model/user/package_subscriptions/package_subscription_model.dart';
import '../../../../repository/common/packages/package_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/toast/toast.dart';
import '../../../view/connectivity/connectivity_view.dart';

class MySubscriptionsScreen extends StatelessWidget {
  const MySubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PackageCubit(PackageRepository())..getMySubscriptions(),
      child: Scaffold(
        appBar: DefaultAppBar(title: tr("my_subscriptions")),
        body: ConnectivityView(
          child: BlocConsumer<PackageCubit, PackageState>(
            listener: (context, state) {
              if (state is SessionUsedState) {
                showToast(tr("session_used_success"));
                PackageCubit.get(context).getMySubscriptions();
              }
              if (state is PackageErrorState) {
                showToast(state.message);
                PackageCubit.get(context).getMySubscriptions();
              }
            },
            builder: (context, state) {
              if (state is SubscriptionLoadingState ||
                  state is PackageLoadingState) {
                return const Center(child: Loading());
              }
              if (state is SubscriptionsLoadedState) {
                if (state.subscriptions.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.subscriptions.length,
                  itemBuilder: (context, index) {
                    return _buildSubscriptionCard(
                        context, state.subscriptions[index]);
                  },
                );
              }
              if (state is PackageErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 48.w, color: Colors.grey[400]),
                      SizedBox(height: 12.h),
                      Text(
                        state.message,
                        style: TextStyle(fontSize: 14.sp, color: red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () =>
                            PackageCubit.get(context).getMySubscriptions(),
                        child: Text(tr("retry")),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64.w, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            tr("no_subscriptions"),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context, PackageSubscriptionModel sub) {
    final isActive = sub.status == 'active';
    final remaining = sub.sessionsRemaining ?? 0;
    final used = sub.sessionsUsed ?? 0;
    final total = remaining + used;
    final progress = total > 0 ? used / total : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status badge
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isActive
                  ? mainColor.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? mainColor.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.inventory_2_rounded,
                    size: 22.w,
                    color: isActive ? mainColor : grey,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.package?.typeLabel ?? '',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      if (sub.package?.providerName != null)
                        Text(
                          sub.package!.providerName!,
                          style:
                              TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                _statusBadge(sub.status ?? ''),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Subject & Stage
                if (sub.package?.subjectName != null)
                  _infoRow(Icons.book_rounded, sub.package!.subjectName!),
                if (sub.package?.educationalStageName != null)
                  _infoRow(
                      Icons.school_rounded, sub.package!.educationalStageName!),

                SizedBox(height: 12.h),

                // Progress bar
                Row(
                  children: [
                    Text(
                      '${tr("sessions_used")}: $used / $total',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$remaining ${tr("sessions_remaining")}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: remaining > 0 ? inProgressColor : red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8.h,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress < 0.8 ? inProgressColor : mainColor,
                    ),
                  ),
                ),

                // Expiry date
                if (sub.expiresAt != null) ...[
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 14.w, color: Colors.grey[500]),
                      SizedBox(width: 4.w),
                      Text(
                        '${tr("expires")}: ${_formatDate(sub.expiresAt!)}',
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 14.h),

                // Use Session Button
                if (isActive && remaining > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showUseSessionDialog(context, sub),
                      icon: Icon(Icons.play_circle_rounded, size: 20.w),
                      label: Text(
                        tr("use_session"),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inProgressColor,
                        foregroundColor: white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case 'active':
        bgColor = inProgressColor.withValues(alpha: 0.1);
        textColor = inProgressColor;
        label = tr("active");
        break;
      case 'expired':
        bgColor = red.withValues(alpha: 0.1);
        textColor = red;
        label = tr("expired");
        break;
      case 'completed':
        bgColor = mainColor.withValues(alpha: 0.1);
        textColor = mainColor;
        label = tr("completed");
        break;
      default:
        bgColor = grey.withValues(alpha: 0.1);
        textColor = grey;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(icon, size: 16.w, color: mainColor),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(fontSize: 13.sp, color: darkGrey),
          ),
        ],
      ),
    );
  }

  void _showUseSessionDialog(
      BuildContext context, PackageSubscriptionModel sub) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(
        sub: sub,
        onConfirm: (date, timeFrom, timeTo) {
          PackageCubit.get(context).useSession(
            sub.id!,
            date: date,
            timeFrom: timeFrom,
            timeTo: timeTo,
          );
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}

// ── Booking Sheet ──────────────────────────────────────

class _BookingSheet extends StatefulWidget {
  final PackageSubscriptionModel sub;
  final Function(String date, String timeFrom, String timeTo) onConfirm;

  const _BookingSheet({required this.sub, required this.onConfirm});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  @override
  Widget build(BuildContext context) {
    final providerName = widget.sub.package?.providerName ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            tr("use_session"),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          if (providerName.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              providerName,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
          ],
          SizedBox(height: 20.h),

          // Date picker
          _buildPickerRow(
            icon: Icons.calendar_today_rounded,
            label: tr("date"),
            value:
                '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
          ),
          SizedBox(height: 12.h),

          // Start time
          _buildPickerRow(
            icon: Icons.access_time_rounded,
            label: tr("time_from"),
            value: _formatTime(_startTime),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _startTime,
              );
              if (picked != null) {
                setState(() {
                  _startTime = picked;
                  // Auto-set end time 1 hour later
                  _endTime = TimeOfDay(
                    hour: (picked.hour + 1) % 24,
                    minute: picked.minute,
                  );
                });
              }
            },
          ),
          SizedBox(height: 12.h),

          // End time
          _buildPickerRow(
            icon: Icons.access_time_filled_rounded,
            label: tr("time_to"),
            value: _formatTime(_endTime),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _endTime,
              );
              if (picked != null) setState(() => _endTime = picked);
            },
          ),
          SizedBox(height: 8.h),

          // Sessions remaining
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
            decoration: BoxDecoration(
              color: inProgressColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.confirmation_number_rounded,
                    size: 16.w, color: inProgressColor),
                SizedBox(width: 8.w),
                Text(
                  '${tr("sessions_remaining")}: ${widget.sub.sessionsRemaining}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: inProgressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // Confirm button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final dateStr =
                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
                final fromStr =
                    '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}';
                final toStr =
                    '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}';
                widget.onConfirm(dateStr, fromStr, toStr);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: inProgressColor,
                foregroundColor: white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, size: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    tr("confirm"),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20.w, color: accentColor),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }
}
