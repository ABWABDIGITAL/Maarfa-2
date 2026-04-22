import 'package:flutter/cupertino.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../res/drawable/icon/icons.dart';
import '../../res/value/color/color.dart';
import '../../res/value/style/textstyles.dart';

class ClanderTable extends StatelessWidget {
  final void Function(DateTime, DateTime)? onTap;
  final DateTime focusedDay;
  const ClanderTable({super.key, required this.onTap, required this.focusedDay});
  @override
  Widget build(BuildContext context) {
    return SidePadding(
      child: TableCalendar(
        currentDay: focusedDay,
        calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(gradient: filterGradient),
            selectedDecoration: BoxDecoration(gradient: filterGradient)),
        onDaySelected: onTap,
        firstDay: DateTime.now(),
        lastDay: DateTime(DateTime.now().year + 1),
        focusedDay: focusedDay,
        headerStyle: HeaderStyle(
          titleCentered: true,
          leftChevronIcon: const ImageIcon(
            AssetImage(rightArrow),
            color: mainColor,
          ),
          rightChevronIcon:
              const ImageIcon(AssetImage(leftArrow), color: mainColor),
          titleTextStyle: TextStyles.introStyle.copyWith(color: mainColor),
        ),
      ),
    );
  }
}
