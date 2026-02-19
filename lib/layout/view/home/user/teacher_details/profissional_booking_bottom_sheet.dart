import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_teacher_details_data_model.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfessionalBookingBottomSheet extends StatefulWidget {
  final TeacherDetailsData teacher;
  final int lessonId;
  final Function(String date, String timeFrom, String timeTo, String type)
      onConfirm;

  const ProfessionalBookingBottomSheet({
    super.key,
    required this.teacher,
    required this.lessonId,
    required this.onConfirm,
  });

  static void show(
    BuildContext context,
    TeacherDetailsData teacher,
    int lessonId,
    Function(String date, String timeFrom, String timeTo, String type)
        onConfirm,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProfessionalBookingBottomSheet(
        teacher: teacher,
        lessonId: lessonId,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<ProfessionalBookingBottomSheet> createState() =>
      _ProfessionalBookingBottomSheetState();
}

class _ProfessionalBookingBottomSheetState
    extends State<ProfessionalBookingBottomSheet> {
  // ── State ──────────────────────────────────
  int _step = 0; // 0 = date, 1 = time
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedStartTime;
  String _selectedType = 'lesson';

  // Sample unavailable dates
  final List<DateTime> _unavailableDates = [
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 7)),
  ];

  // ── Computed ───────────────────────────────

  TimeOfDay? get _endTime {
    if (_selectedStartTime == null) return null;
    final startMinutes =
        _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
    final endMinutes = startMinutes + 60;
    return TimeOfDay(hour: (endMinutes ~/ 60) % 24, minute: endMinutes % 60);
  }

  bool get _canProceed {
    if (_step == 0) return _selectedDay != null;
    return _selectedStartTime != null;
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _displayTime(TimeOfDay t) {
    final h = t.hour;
    final m = t.minute.toString().padLeft(2, '0');
    if (h == 0) return '12:$m AM';
    if (h < 12) return '$h:$m AM';
    if (h == 12) return '12:$m PM';
    return '${h - 12}:$m PM';
  }

  // ── Actions ────────────────────────────────

  void _onNext() {
    if (_step == 0) {
      setState(() => _step = 1);
    } else {
      _confirmBooking();
    }
  }

  void _onBack() {
    if (_step == 1) {
      setState(() => _step = 0);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: accentColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.grey.shade800,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedStartTime = picked);
  }

  void _confirmBooking() {
    if (_selectedDay == null ||
        _selectedStartTime == null ||
        _endTime == null) {
      return;
    }

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);
    final from = _formatTimeOfDay(_selectedStartTime!);
    final to = _formatTimeOfDay(_endTime!);

    widget.onConfirm(dateStr, from, to, _selectedType);
    Navigator.pop(context);
  }

  // ── Build ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle
          _buildHandle(),

          // Header
          _buildHeader(),

          // Step indicator
          _buildStepIndicator(),

          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) {
                final slide = Tween<Offset>(
                  begin: Offset(_step == 0 ? -0.15 : 0.15, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeOutCubic));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              child: _step == 0
                  ? _buildDateStep(key: const ValueKey('date'))
                  : _buildTimeStep(key: const ValueKey('time')),
            ),
          ),

          // Bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ── Handle ─────────────────────────────────

  Widget _buildHandle() {
    return Container(
      width: 36.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  // ── Header ─────────────────────────────────

  Widget _buildHeader() {
    final name = widget.teacher.provider?.firstName ?? '';
    final spec = widget.teacher.provider?.specializations
            ?.map((s) => s.name ?? '')
            .where((n) => n.isNotEmpty)
            .join(', ') ??
        '';

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: accentColor.withValues(alpha: 0.3), width: 2),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipOval(
              child: widget.teacher.provider?.imagePath != null
                  ? Image.network(
                      widget.teacher.provider!.imagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatarIcon(),
                    )
                  : _defaultAvatarIcon(),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'book'.tr()} $name',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
                if (spec.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    spec,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon:
                Icon(Icons.close_rounded, color: Colors.grey[500], size: 22.w),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatarIcon() {
    return Icon(Icons.person_outline_rounded, color: accentColor, size: 24.w);
  }

  // ── Step Indicator ─────────────────────────

  Widget _buildStepIndicator() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Row(
        children: [
          _stepDot(index: 0, label: 'selectDate'.tr()),
          _stepLine(),
          _stepDot(index: 1, label: 'selectTime'.tr()),
        ],
      ),
    );
  }

  Widget _stepDot({required int index, required String label}) {
    final isActive = _step == index;
    final isDone = _step > index;

    return Expanded(
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? const Color(0xFF4CAF50)
                  : isActive
                      ? accentColor
                      : Colors.grey.shade200,
            ),
            child: Center(
              child: isDone
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 14.w)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : Colors.grey[500],
                      ),
                    ),
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? primaryText : Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        width: 24.w,
        height: 2.h,
        decoration: BoxDecoration(
          color: _step > 0 ? const Color(0xFF4CAF50) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(1.r),
        ),
      ),
    );
  }

  // ── Step 0: Date ───────────────────────────

  Widget _buildDateStep({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lesson type selector
          _buildTypeSelector(),
          SizedBox(height: 20.h),

          // Calendar
          _buildCalendar(),
          SizedBox(height: 16.h),

          // Selected date pill
          if (_selectedDay != null) _buildDatePill(),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'lessonType'.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            _typeOption('lesson', Icons.school_rounded, 'lessonee'.tr()),
            SizedBox(width: 10.w),
            _typeOption('course', Icons.library_books_rounded, 'courseee'.tr()),
          ],
        ),
      ],
    );
  }

  Widget _typeOption(String type, IconData icon, String label) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isSelected ? lightColor : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? mainColor : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? mainColor : Colors.grey[500], size: 18.w),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? mainColor : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.grey[600]),
          defaultTextStyle: TextStyle(color: Colors.grey[800]),
          todayTextStyle: const TextStyle(color: Colors.white),
          selectedTextStyle: const TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(
            color: mainColor.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: mainColor,
            shape: BoxShape.circle,
          ),
          disabledTextStyle: TextStyle(color: Colors.grey.shade300),
          disabledDecoration: const BoxDecoration(shape: BoxShape.circle),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: primaryText,
          ),
          leftChevronIcon:
              Icon(Icons.chevron_left_rounded, color: accentColor, size: 22.w),
          rightChevronIcon:
              Icon(Icons.chevron_right_rounded, color: accentColor, size: 22.w),
          headerPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        ),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        enabledDayPredicate: (day) =>
            !_unavailableDates.any((d) => isSameDay(d, day)),
        onDaySelected: (selected, focused) {
          if (!_unavailableDates.any((d) => isSameDay(d, selected))) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          }
        },
        onPageChanged: (focused) => setState(() => _focusedDay = focused),
      ),
    );
  }

  Widget _buildDatePill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: mainColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, color: mainColor, size: 16.w),
          SizedBox(width: 8.w),
          Text(
            DateFormat('EEEE, MMM dd, yyyy').format(_selectedDay!),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Time ───────────────────────────

  Widget _buildTimeStep({Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date summary chip
          _buildDateSummaryChip(),
          SizedBox(height: 24.h),

          // Time picker trigger
          _buildTimePickerCard(),
          SizedBox(height: 16.h),

          // Auto-generated end time
          if (_selectedStartTime != null) ...[
            _buildEndTimeCard(),
            SizedBox(height: 16.h),
            _buildBookingSummaryCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSummaryChip() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [accentColor, Color(0xFF5B3E9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 18.w),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE').format(_selectedDay!),
                style: TextStyle(color: Colors.white70, fontSize: 11.sp),
              ),
              Text(
                DateFormat('MMM dd, yyyy').format(_selectedDay!),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => _step = 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'change'.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'selectStartTime'.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: primaryText,
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: _pickTime,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: _selectedStartTime != null
                    ? mainColor
                    : Colors.grey.shade300,
                width: _selectedStartTime != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: (_selectedStartTime != null
                            ? mainColor
                            : Colors.grey.shade400)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: _selectedStartTime != null
                        ? mainColor
                        : Colors.grey.shade400,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _selectedStartTime != null
                        ? _displayTime(_selectedStartTime!)
                        : 'tapToSelectStartTime'.tr(),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: _selectedStartTime != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: _selectedStartTime != null
                          ? primaryText
                          : Colors.grey[500],
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[400],
                  size: 20.w,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEndTimeCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.schedule_rounded,
                color: Colors.grey[500], size: 20.w),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'generatedEndTime'.tr(),
                style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2.h),
              Text(
                _displayTime(_endTime!),
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700]),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '+1 hour',
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    final from = _displayTime(_selectedStartTime!);
    final to = _displayTime(_endTime!);
    final dateStr = DateFormat('MMM dd, yyyy').format(_selectedDay!);
    final typeLabel =
        _selectedType == 'lesson' ? 'lessonee'.tr() : 'courseee'.tr();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: mainColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_rounded, color: mainColor, size: 16.w),
              SizedBox(width: 6.w),
              Text(
                'selectedTimeSlot'.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB45309),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _summaryRow(Icons.calendar_today_rounded, dateStr),
          SizedBox(height: 6.h),
          _summaryRow(Icons.access_time_rounded, '$from – $to'),
          SizedBox(height: 6.h),
          _summaryRow(Icons.school_rounded, typeLabel),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.w, color: const Color(0xFFB45309)),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF92400E),
          ),
        ),
      ],
    );
  }

  // ── Bottom Bar ─────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: _onBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new_rounded,
                        size: 14.w, color: Colors.grey[600]),
                    SizedBox(width: 4.w),
                    Text(
                      _step == 0 ? 'cancel'.tr() : 'back'.tr(),
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Next / Confirm button
            Expanded(
              child: AnimatedOpacity(
                opacity: _canProceed ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _canProceed ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _step == 1 ? mainColor : accentColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        (_step == 1 ? mainColor : accentColor)
                            .withValues(alpha: 0.5),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _step == 1
                            ? Icons.check_circle_rounded
                            : Icons.arrow_forward_ios_rounded,
                        size: 18.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _step == 0 ? 'selectTime'.tr() : 'confirmBooking'.tr(),
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
