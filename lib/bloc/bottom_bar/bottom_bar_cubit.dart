import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../layout/activity/provider_screens/appointments/appointments_screen.dart';
import '../../layout/activity/provider_screens/home/home_screen.dart';
import '../../layout/activity/provider_screens/requests/requests_screen.dart';
import '../../layout/activity/user_screens/bookmark/bookmark_screen.dart';
import '../../layout/activity/user_screens/home/home_screen.dart';
import '../../layout/activity/user_screens/main/main_screen.dart';
import '../../layout/activity/user_screens/my_requests/my_requests_screen.dart';
import '../../layout/activity/user_screens/profile/profile_screen.dart';
import '../../layout/activity/user_screens/subscribe/subscribe_screen.dart';
import 'bottom_bar_states.dart';

class BottomBarCubit extends Cubit<BottomBarStates> {
  BottomBarCubit() : super(BottomBarInitState());

  static BottomBarCubit get(BuildContext context) => BlocProvider.of(context);

  int selectedIndex = 0;
  int selectedProvider = 0;
  List<Widget> pageList = const [
    HomeScreen(),
    BookmarkScreen(),
    MyRequestsScreen(),
    SubscribeScreen(),
    ProfileScreen(isUser: true),
  ];

  List<Widget> providerList = [
    const ProviderHomeScreen(),
    const ProviderRequestsScreen(),
    const ProviderAppointmentsScreen(),
    const ProfileScreen(isUser: false),
  ];

  void changeBottomBar(index) {
    selectedIndex = index;
    emit(ChangeBottomBarState());
  }

  void changeProviderBar(index) {
    selectedProvider = index;
    emit(ChangeProviderBarState());
  }

  void presistBottomBar(index) {
    selectedIndex = index;
    emit(ChangeBottomBarState());
    Get.to(() => const MainScreen());
  }
}
