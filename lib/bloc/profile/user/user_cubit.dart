import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../model/common/cities/city_model.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../model/user/user/user_model.dart';
import '../../../model/user/user/user_response.dart';
import '../../../repository/user/edit_profile/user_repository.dart';
import '../../../res/value/color/color.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  UserCubit(this.userRepository) : super(UserInitial());

  static UserCubit get(BuildContext context) => BlocProvider.of(context);
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
  List<TextEditingController> controllers = [];
  List<String?> validators = [null, null, null, null, null];
  TextEditingController phone = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirm = TextEditingController();

  String? gender;
  String? nationality;
  DateTime? pickedDate;
  String? birthdate;
  int? genderValue;
  CityModel? city;
  String? cityName;
  int? cityId;

  bool isPassword = true;
  bool isConfirm = true;
  bool isOld = true;

  List<Map<String, dynamic>> genderArList = [
    {"id": 1, "name": tr("male")},
    {"id": 2, "name": "أنثى"}
  ];
  List<Map<String, dynamic>> genderList = [
    {"id": 1, "name": tr("male")},
    {"id": 2, "name": tr("female")}
  ];
  List<Map<String, dynamic>> genderEnList = [
    {"id": 1, "name": "Male"},
    {"id": 2, "name": "Female"}
  ];

  File? profileImage;

  bool picked = false;

  NationalityModel? nation;
  String? nationName;
  int? nationId;

  chooseNation(val) {
    switch (nation == val) {
      case true:
        nation = val;
        nationName = val.name;
        nationId = val.id;
        emit(SameNationState());
        break;
      case false:
        nation = val;
        nationName = val.name;
        nationId = val.id;
        emit(ChangeNationState());
        break;
    }
    emit(ChooseNationState());
  }

  chooseGender(state) {
    switch (state == true) {
      case true:
        genderValue = 1;
        emit(SameGenderState());
        break;
      case false:
        genderValue = 2;
        emit(ChangeGenderState());
    }
    emit(SelectGenderState());
  }

  pickDate() async {
    pickedDate = await showDatePicker(
      context: Get.context!,
      locale: const Locale("en"),
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: blackColor,
            ),
          ),
          child: child ?? const SizedBox()),
    );
    if (pickedDate != null) {
      birthdate = DateFormat("yyyy-MM-dd", "en").format(pickedDate!);
    }
    emit(SelectBirthdateState());
  }

  pickProfile() async {
    emit(PickInitState());
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    profileImage = File(pickedFile?.path ?? "");
    picked = true;
    emit(PickPictureState());
  }

  void securePassword() {
    if (isOld == true) {
      isOld = false;
      // secureColor = mainColor;
    } else {
      isOld = true;
      // secureColor = hintColor.withValues(alpha:0.5);
    }
    emit(ChangeOldState());
  }

  void secureNewPassword() {
    if (isPassword == true) {
      isPassword = false;
      // secureColor = mainColor;
    } else {
      isPassword = true;
      // secureColor = hintColor.withValues(alpha:0.5);
    }
    emit(ChangePasswordState());
  }

  void secureConfirm() {
    if (isConfirm == true) {
      isConfirm = false;
    } else {
      isConfirm = true;
    }
    emit(ChangeConfirmState());
  }

  chooseCity(val) {
    switch (city == val) {
      case true:
        city = val;
        cityName = val.name;
        cityId = val.id;
        emit(SameCityState());
        break;
      case false:
        city = val;
        cityName = val.name;
        cityId = val.id;
        emit(ChangeCityState());
        break;
    }
    emit(ChooseCityState());
  }

  getInitData(
      UserModel user, List<CityModel> cities, List<NationalityModel> nations) {
    firstName.value = firstName.value.copyWith(text: user.firstName);
    lastName.value = lastName.value.copyWith(text: user.lastName);
    user.phone == null
        ? null
        : phone.value = phone.value.copyWith(text: user.phone);
    email.value = email.value.copyWith(text: user.email);
    user.birthDate == null
        ? null
        : birthdate = DateFormat("yyyy-MM-dd", "en").format(user.birthDate!);
    chooseGender(user.gender == 1 ? true : false);
    if (user.city != null) {
      for (int i = 0; i < cities.length; i++) {
        if (cities[i].id == user.city!.id &&
            cities[i].name == user.city!.name) {
          chooseCity(cities[i]);
        }
      }
    }
    if (user.nationality != null) {
      for (int i = 0; i < nations.length; i++) {
        if (nations[i].id == user.nationality!.id &&
            nations[i].name == user.nationality!.name) {
          chooseNation(nations[i]);
        }
      }
    }
    emit(InitUserState());
  }

  void validate(String val, int index, bool password) {
    switch (password ? val.length < 8 : val.isEmpty) {
      case true:
        validators[index] =
            password ? tr("error_password") : tr("error_message");
        emit(ValidateEmptyState());
        break;
      case false:
        validators[index] = null;
        emit(ValidateNotEmptyState());
        break;
    }
    emit(ValidateState());
  }

  void editProfile() async {
    if (firstName.text.isEmpty || lastName.text.isEmpty || email.text.isEmpty) {
      controllers = [firstName, lastName, email];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      controller.reset();
    } else {
      // final fcmToken = await NotificationService.instance!.getToken();
      Map<String, dynamic> data = {
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "birth_date": birthdate,
        "nationality_id": nationId,
        "gender": genderValue,
        "city_id": cityId,
        "email": email.text.trim(),
        "phone": phone.text.trim(),
      };
      userRepository
          .editProfile(picked == true ? profileImage : null, data)
          .whenComplete(() => controller.reset());
    }
    emit(EditProfileState());
  }

  void validateEmail(bool isUser) async {
    if (email.text.isEmpty) {
      controllers = [email];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      controller.reset();
    } else {
      userRepository
          .validateEmail(email.text.trim(), isUser)
          .whenComplete(() => controller.reset());
    }
    emit(ValidateEmailState());
  }

  void changePassword() async {
    if (newPassword.text.isEmpty ||
        oldPassword.text.isEmpty ||
        confirm.text.isEmpty) {
      controllers = [oldPassword, newPassword, confirm];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_password")
            : validators[i] = null;
      }
      controller.reset();
    } else {
      Map<String, dynamic> data = {
        "old_password": oldPassword.text.trim(),
        "new_password": newPassword.text.trim(),
        "new_password_confirmation": confirm.text.trim(),
      };
      userRepository
          .changePassword(data)
          .whenComplete(() => controller.reset());
    }
    emit(EditPasswordState());
  }

  /// get from shared
  getCacheUser() async {
    userRepository.getCacheUser().then((value) {
      emit(UserLoadedState(data: value));
    });
  }

  /// get from api and save to shared
  getProfile() async {
    userRepository.getUserProfile().then((value) {
      // print(value.data);
      emit(UserApiLoadedState(data: value));
    });
  }

  getProfileCache() async {
    userRepository.getCacheUser().then((value) {
      // print(value.data);
      emit(UserApiLoadedState(data: value));
    });
  }
}
