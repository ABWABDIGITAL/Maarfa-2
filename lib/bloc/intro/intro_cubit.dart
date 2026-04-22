import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../layout/activity/role/role_screen.dart';
import '../../res/drawable/image/images.dart';
import '../../service/local/share_prefs_service.dart';

part 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit() : super(IntroInitial());
  static IntroCubit get(BuildContext context) => BlocProvider.of(context);
  SharedPrefService pref = SharedPrefService();
  List<String> imageIntro = [intro1, intro2];
  List<String> get subjectIntro => [
        tr("intro_description_1"),
        tr("intro_description_2"),
      ];
  List<String> get titleIntro => [
        tr("intro_title_1"),
        tr("intro_title_2"),
      ];
  int intro = 0;
  double percent = 1 / 2;

  changeIntro(state) {
    pref.setBool("seen", true);
    if (state < imageIntro.length - 1) {
      intro++;
      percent = percent == 1 ? 1 : percent + 1 / 2;
      emit(ChangeIntroState());
    } else {
      Get.offAll(() => const RoleScreen());
      emit(StartAppState());
    }
  }

  scrollIntro(state) {
    intro = state;
    emit(ChangeIntroScrollState());
  }

  // GuestDataModel guestData = GuestDataModel();

  // Future<void> guestLogin(BuildContext context) async {
  //   emit(GuestLoadingState());
  //
  //   try {
  //     // Use DioService to make the POST request
  //     final response = await DioService2().post(
  //       '/check-guest', // API endpoint path
  //       body: {}, // Add any required body parameters if needed
  //     );
  //
  //     // Handle the response using Either from dartz
  //     return response.fold(
  //           (failure) {
  //         // Failure case
  //         print('ssssssssssss');
  //         print(failure);
  //         print('ssssssssssss');
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(failure.toString()),
  //         ));
  //         emit(GuestErrorState(failure.toString()));
  //       },
  //           (data) {
  //         // Success case
  //         guestData = GuestDataModel.fromJson(data);
  //
  //         if (guestData.status == true && guestData.data?.guestToken != null) {
  //           // Save guest token to shared preferences
  //           SharedPreferences.getInstance().then((prefs) {
  //             prefs.setString('token', guestData.data!.guestToken!.removeAllWhitespace);
  //             // prefs.setString('guest-token', guestData.data!.guestToken!.removeAllWhitespace);
  //           });
  //
  //           SharedPreferences.getInstance().then((prefs) {
  //             prefs.setBool('isGuest', guestData.data!.isGuestMode!);
  //             // prefs.setString('guest-token', guestData.data!.guestToken!.removeAllWhitespace);
  //           });
  //
  //           print(guestData.data!.guestToken!.removeAllWhitespace);
  //           print(guestData.data!.isGuestMode);
  //
  //           // Show success SnackBar
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(guestData.message ?? 'Login as guest successful'),
  //           ));
  //
  //           // isUser
  //           //     ? Get.to(() => MainScreen())
  //           //     : Get.to(() => ProviderMainScreen());
  //
  //           emit(GuestSuccessState());
  //         } else {
  //           // Show error SnackBar
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text(guestData.message ?? 'Failed to login as guest'),
  //           ));
  //           emit(GuestErrorState(
  //               guestData.message ?? 'Failed to login as guest'));
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     // Handle unexpected errors
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text('An unexpected error occurred: $e'),
  //     ));
  //     emit(GuestErrorState('An unexpected error occurred: $e'));
  //   }
  // }

  // Future<void> guestLogin(BuildContext context) async {
  //   emit(GuestLoadingState());

  //   try {
  //     // Use DioService to make the POST request
  //     final response = await DioService2().post(
  //       '/check-guest', // API endpoint path
  //       body: {}, // Add any required body parameters if needed
  //     );

  //     // Handle the response using Either from dartz
  //     return response.fold(
  //       (failure) {
  //         // Failure case
  //         debugPrint('Failure: $failure');
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(failure.toString()),
  //         ));
  //         emit(GuestErrorState(failure.toString()));
  //       },
  //       (data) {
  //         // Success case
  //         guestData = GuestDataModel.fromJson(data);

  //         if (guestData.status == true && guestData.data?.guestToken != null) {
  //           // Save guest token and isGuest to shared preferences
  //           SharedPreferences.getInstance().then((prefs) {
  //             prefs.setString('token',
  //                 guestData.data!.guestToken!.replaceAll(RegExp(r'\s+'), ''));
  //             prefs.setBool('isGuest', guestData.data!.isGuestMode ?? true);
  //           });

  //           debugPrint(
  //               'Guest Token: ${guestData.data!.guestToken!.replaceAll(RegExp(r'\s+'), '')}');
  //           debugPrint('Is Guest Mode: ${guestData.data!.isGuestMode}');

  //           // Show success SnackBar
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(guestData.message ?? tr('login_success')),
  //           ));

  //           emit(GuestSuccessState());
  //         } else {
  //           // Show error SnackBar
  //           final errorMessage = guestData.message ?? tr('guest_login_failed');
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text(errorMessage),
  //           ));
  //           emit(GuestErrorState(errorMessage));
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     // Handle unexpected errors
  //     final errorMessage = tr('unexpected_error', args: [e.toString()]);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text(errorMessage),
  //     ));
  //     emit(GuestErrorState(errorMessage));
  //   }
  // }
}
