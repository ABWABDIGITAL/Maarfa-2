import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/bottom_bar/bottom_bar_cubit.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';

class MasterBottomBar extends StatelessWidget {
  const MasterBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BottomBarCubit>(context, listen: true);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: _NavItem(
                  index: index,
                  selectedIndex: bloc.selectedIndex,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    bloc.changeBottomBar(index);
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_outlined,
    Icons.bookmark_outline_rounded,
    Icons.receipt_long_outlined,
    Icons.school_outlined,
    Icons.person_outline_rounded,
  ];

  static const _activeIcons = [
    Icons.home_rounded,
    Icons.bookmark_rounded,
    Icons.receipt_long_rounded,
    Icons.school_rounded,
    Icons.person_rounded,
  ];

  static const _labelKeys = [
    'home',
    'bookmark',
    'my_requests',
    'subscribe',
    'account',
  ];

  @override
  Widget build(BuildContext context) {
    final bool selected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with subtle indicator dot
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 40 : 36,
                  height: selected ? 32 : 28,
                  decoration: BoxDecoration(
                    color: selected
                        ? accentColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    selected ? _activeIcons[index] : _icons[index],
                    size: 22,
                    color: selected ? accentColor : const Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              tr(_labelKeys[index]),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? accentColor : const Color(0xFF9E9E9E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
