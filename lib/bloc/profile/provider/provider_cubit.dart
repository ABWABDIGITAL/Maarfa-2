import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_academy/model/provider/provider/provider_model.dart';
import 'package:my_academy/repository/user/edit_profile/user_repository.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../model/common/nationalities/nationality_model.dart';
import '../../../model/provider/provider/provider_response.dart';

part 'provider_state.dart';

class ProviderCubit extends Cubit<ProviderState> {
  final UserRepository providerRepository;
  ProviderCubit(this.providerRepository) : super(ProviderInitial());

  static ProviderCubit get(BuildContext context) => BlocProvider.of(context);

  RoundedLoadingButtonController controller = RoundedLoadingButtonController();

  List<TextEditingController> controllers = [];
  List<String?> validators = [null, null, null, null, null, null, null, null];
  TextEditingController scientificName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController degree = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController code = TextEditingController();

  String? gender;
  String? nationality;
  String? birthdate;
  int? genderValue;
  // List<Map<String, dynamic>> nationList = [
  //   {"id": 1, "name": "المملكة العربية السعودية"},
  //   {"id": 2, "name": "مصر"},
  // ];
  // List<Map<String, dynamic>> genderArList = [
  //   {"id": 1, "name": "ذكر"},
  //   {"id": 2, "name": "أنثى"}
  // ];
  // List<Map<String, dynamic>> genderEnList = [
  //   {"id": 1, "name": "Male"},
  //   {"id": 2, "name": "Female"}
  // ];

  File? profileImage;

  NationalityModel? nation;
  String? nationName;
  int? nationId;

  bool picked = false;

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

  // selectGender(state) {
  //   switch (state == gender) {
  //     case true:
  //       gender = state;
  //       emit(SameGenderState());
  //       break;
  //     case false:
  //       gender = state;
  //       emit(ChangeGenderState());
  //   }
  //   emit(SelectGenderState());
  // }

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

  pickProfile() async {
    emit(PickInitState());
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return; // user cancelled
    profileImage = File(pickedFile.path);
    picked = true;
    emit(PickPictureState());
  }

  getInitData(Provider user, List<NationalityModel> nations) {
    scientificName.value = scientificName.value.copyWith(text: user.title);
    firstName.value = firstName.value.copyWith(text: user.firstName);
    lastName.value = lastName.value.copyWith(text: user.lastName);
    phone.value = phone.value.copyWith(text: user.phone);
    email.value = email.value.copyWith(text: user.email);
    degree.value = degree.value.copyWith(text: user.degree);
    chooseGender(user.gender == 1 ? true : false);
    for (int i = 0; i < nations.length; i++) {
      if (nations[i].id == user.nationality!.id &&
          nations[i].name == user.nationality!.name) {
        chooseNation(nations[i]);
      }
    }
    emit(InitProviderState());
  }

  getInitBio(Provider user) {
    bio.value = bio.value.copyWith(text: user.bio);
    emit(InitBioState());
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
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        scientificName.text.isEmpty ||
        email.text.isEmpty ||
        degree.text.isEmpty) {
      controllers = [scientificName, firstName, lastName, email, degree];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      controller.reset();
    } else {
      // final fcmToken = await NotificationService.instance!.getToken();
      Map<String, dynamic> data = {
        "title": scientificName.text.trim(),
        "first_name": firstName.text.trim(),
        "last_name": lastName.text.trim(),
        "degree": degree.text.trim(),
        "nationality_id": nationId,
        "gender": genderValue,
        "email": email.text.trim(),
      };
      providerRepository
          .editProviderProfile(picked == true ? profileImage : null, data)
          .whenComplete(() => controller.reset());
    }
    emit(EditProfileState());
  }

  void editBio() async {
    if (bio.text.isEmpty) {
      controllers = [bio];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      controller.reset();
    } else {
      // final fcmToken = await NotificationService.instance!.getToken();
      Map<String, dynamic> data = {"bio": bio.text.trim()};
      providerRepository.editBio(data).whenComplete(() => controller.reset());
    }
    emit(EditProfileState());
  }

  /// get from shared
  getCacheProvider() async {
    providerRepository.getCacheProvider().then((value) {
      emit(ProviderLoadedState(data: value));
    });
  }

  /// get from api and save to shared
  getProfile() async {
    providerRepository.getProviderProfile().then((value) {
      emit(ProviderLoadedState(data: value));
    });
  }
}
