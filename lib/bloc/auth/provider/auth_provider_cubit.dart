import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../layout/activity/auth/register/provider/cv_register_screen.dart';
import '../../../layout/activity/auth/register/provider/specialization_register_screen.dart';
import '../../../layout/activity/role/role_screen.dart';
import '../../../model/common/cities/city_model.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../model/provider/certificate/certificate_data.dart';
import '../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../widget/toast/toast.dart';
import '../../bottom_bar/bottom_bar_cubit.dart';

part 'auth_provider_state.dart';

class AuthProviderCubit extends Cubit<AuthProviderState> {
  AuthProviderCubit(this.authProviderRepository) : super(AuthProviderInitial());
  static AuthProviderCubit get(BuildContext context) =>
      BlocProvider.of(context);
  final AuthProviderRepository authProviderRepository;
  RoundedLoadingButtonController authController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController logoutController =
      RoundedLoadingButtonController();
  RoundedLoadingButtonController codeController =
      RoundedLoadingButtonController();
  int auth = 0;
  int timer = 60;
  bool isPassword = true;
  bool isConfirm = true;

  String? cityName;
  int? cityId;

  String? nationName;
  int? nationId;

  List<Map<String, dynamic>> gendreArList = [
    {"id": 1, "name": "ذكر"},
    {"id": 2, "name": "أنثى"}
  ];
  List<Map<String, dynamic>> gendreEnList = [
    {"id": 1, "name": "Male"},
    {"id": 2, "name": "Female"}
  ];
  List<TextEditingController> controllers = [];
  List<String?> validators = [null, null, null, null, null, null, null];

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

  List<bool> selectedGrade = [];
  List<int> gradesId = [];

  CityModel? city;
  File? cvFile;
  File? certificateFile;
  bool picked = false;
  bool? agree = false;

  pickCV() async {
    emit(PickInitState());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    cvFile = File(result!.files.single.path!);
    picked = true;
    emit(PickCVState());
  }

  pickCertificate() async {
    emit(PickInitState());
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    certificateFile = File(result!.files.single.path!);
    picked = true;
    emit(PickCertificateState());
  }

  void validate(String val, int index, bool password) {
    switch (password ? val.length < 8 : val.isEmpty) {
      case true:
        validators[index] =
            password == true ? tr("error_password") : tr("error_message");
        emit(ValidateEmptyState());
        break;
      case false:
        validators[index] = null;
        emit(ValidateNotEmptyState());
        break;
    }
    emit(ValidateState());
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

  NationalityModel? nation;

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

  List<Map<String, dynamic>> nationList = [
    {"id": 1, "name": "المملكة العربية السعودية"},
    {"id": 2, "name": "مصر"},
  ];
  List<Map<String, dynamic>> genderArList = [
    {"id": 1, "name": "ذكر"},
    {"id": 2, "name": "أنثى"}
  ];
  List<Map<String, dynamic>> genderEnList = [
    {"id": 1, "name": "Male"},
    {"id": 2, "name": "Female"}
  ];

  // bool? agree = false;

  agreeTerms(state) {
    switch (state == true) {
      case true:
        agree = true;
        emit(AcceptTermsState());
        break;
      case false:
        agree = false;
        emit(RejectTermsState());
    }
  }

  chooseGender(state) {
    switch (state == true) {
      case true:
        genderValue = 1;
        emit(AcceptTermsState());
        break;
      case false:
        genderValue = 2;
        emit(RejectTermsState());
    }
  }

  selectGender(state) {
    switch (state == gender) {
      case true:
        gender = state;
        emit(SameGenderState());
        break;
      case false:
        gender = state;
        emit(ChangeGenderState());
    }
    emit(SelectGenderState());
  }

  Future<void> logout() async {
    authProviderRepository.logOut().whenComplete(() async {
      BlocProvider.of<BottomBarCubit>(Get.context!).changeBottomBar(0);
      BlocProvider.of<BottomBarCubit>(Get.context!).changeProviderBar(0);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    });
    emit(LogoutState());
  }

  // bool showDeleteAccount = false;
  // Future<void> getDeleteStatus() async {
  //   emit(SelectGenderState());
  //   showDeleteAccount = await authProviderRepository.getDeleteStatus();
  //   emit(AuthProviderInitial());
  // }

  Future<void> deleteAccount() async {
    authProviderRepository.deleteAccount().whenComplete(() async {
      BlocProvider.of<BottomBarCubit>(Get.context!).changeBottomBar(0);
      BlocProvider.of<BottomBarCubit>(Get.context!).changeProviderBar(0);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    });
    emit(LogoutState());
  }

  void signout() {
    BlocProvider.of<BottomBarCubit>(Get.context!).changeBottomBar(0);
    BlocProvider.of<BottomBarCubit>(Get.context!).changeProviderBar(0);
    Get.offAll(() => const RoleScreen());
    emit(LogoutState());
  }

  changeLocale(BuildContext context) {
    if (Get.locale!.languageCode == "ar") {
      Get.updateLocale(const Locale("en"));
      context.setLocale(const Locale("en"));
      emit(ChangeToArState());
    } else {
      Get.updateLocale(const Locale("ar"));
      context.setLocale(const Locale("ar"));
      emit(ChangeToEnState());
    }
  }

  void securePassword() {
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
      // confirmColor = mainColor;
    } else {
      isConfirm = true;
      // confirmColor = hintColor.withValues(alpha:0.5);
    }
    emit(ChangeConfirmState());
  }

  validateGrades(Map<String, dynamic> data) {
    data.putIfAbsent("educational_stages[]",
        () => List.generate(gradesId.length, (index) => gradesId[index]));
    Get.to(() => CVRegisterScreen(
          data: data,
        ));
    emit(ValidateGradesState());
  }

  chooseGrades(state, index, data) {
    switch (state == false) {
      case true:
        selectedGrade[index] = false;
        gradesId.remove(data[index].id);
        emit(SameGradeState());
        break;
      case false:
        selectedGrade[index] = true;
        gradesId.add(data[index].id);
        emit(NewGradeState());
        break;
    }
    emit(ChooseGradeState());
  }

  getInitGrade(data) {
    selectedGrade = List.filled(data.length, false);
    emit(InitGradeState());
  }

  void validateEmail() {
    if (scientificName.text.isEmpty ||
        firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        email.text.isEmpty ||
        degree.text.isEmpty ||
        password.text.isEmpty ||
        confirm.text != password.text) {
      controllers = [
        scientificName,
        firstName,
        lastName,
        email,
        password,
        confirm,
        degree
      ];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = i > 3 ? tr("error_password") : tr("error_message")
            : validators[i] = null;
        controllers[4].text != controllers[5].text
            ? validators[5] = tr("error_same_password")
            : validators[5] = null;
      }
      authController.reset();
    } else {
      if (genderValue == null) {
        showToast(tr("error_gender"));
        authController.reset();
      } else if (cityId == null) {
        showToast(tr("error_city"));
        authController.reset();
      } else if (nationId == null) {
        showToast(tr("error_nation"));
        authController.reset();
      } else if (agree == false) {
        showToast(tr("error_agree"));
        authController.reset();
      } else {
        Map<String, dynamic> data = {
          "title": scientificName.text.trim(),
          "first_name": firstName.text.trim(),
          "last_name": lastName.text.trim(),
          "degree": degree.text.trim(),
          "city_id": cityId,
          "nationality_id": nationId,
          "gender": genderValue,
          "email": email.text.trim(),
          "password": password.text.trim(),
        };
        authProviderRepository
            .validateRegister(
              data,
              email.text.trim(),
            )
            .whenComplete(() => authController.reset());
      }
    }
    emit(ValidateEmailState());
  }

  validateBio(Map<String, dynamic> data) {
    if (bio.text.isEmpty) {
      controllers = [bio];
      controllers[0].text.isEmpty
          ? validators[0] = tr("error_message")
          : validators[0] = null;
      authController.reset();
    } else {
      data.putIfAbsent("bio", () => bio.text.trim());
      Get.to(() => SpecializationRegisterScreen(
            data: data,
          ));
    }
    emit(ValidateBioState());
  }

  void verifyProvider(Map<String, dynamic> data) {
    final String? extension = cvFile?.path.split('.').lastOrNull?.toLowerCase();
    if (cvFile == null) {
      showToast(tr("choose_cv"));
      authController.reset();
    } else if (extension != 'pdf') {
      showToast(tr("cv_must_be_pdf"));
      authController.reset();
    } else {
      authProviderRepository
          .providerVerify(cvFile!, data)
          .whenComplete(() => authController.reset());
    }
    emit(VerifyProviderState());
  }

  void registerProvider(File cvFile, Map<String, dynamic> data) {
    data.putIfAbsent("code", () => code.text.trim());
    authProviderRepository
        .providerRegister(cvFile, data)
        .whenComplete(() => codeController.reset());
    emit(RegisterProviderState());
  }

  void editCV() {
    if (cvFile == null) {
      showToast(tr("choose_cv"));
      authController.reset();
    } else {
      authProviderRepository
          .editCV(cvFile!)
          .whenComplete(() => authController.reset());
    }
    emit(RegisterProviderState());
  }

  void editCertificate() {
    if (certificateFile == null) {
      showToast(tr("upload_certificate"));
      authController.reset();
    } else {
      authProviderRepository
          .editCertificate(certificateFile!)
          .whenComplete(() => authController.reset());
    }
    emit(RegisterProviderState());
  }

  void deleteCertificate(int id) {
    authProviderRepository
        .deleteCertificate(id)
        .whenComplete(() => authController.reset());
    emit(DeleteCertificateState());
  }

  getCertificate() {
    authProviderRepository.getCertificate().then((value) {
      emit(CertificateLoadedState(data: value.data));
    });
  }
}
