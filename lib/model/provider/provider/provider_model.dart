import '../../common/educational_stages/educational_stages_model.dart';
import '../../common/nationalities/nationality_model.dart';
import '../../common/specializations/specializations_model.dart';
import '../bank_account/bank_account_model.dart';

class Provider {
  Provider(
      {this.id,
      this.title,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.bio,
      this.gender,
      this.degree,
      this.balance,
      this.rate,
      this.fcmToken,
      this.imagePath,
      this.cvPath,
      this.video,
      this.nationality,
      this.specializations,
      this.educationalStages,
      required this.wallet,
      required this.appRatio,
      required this.deservedAmount,
      required this.expectedAmount,
      this.provider,
      this.bankAccount,
      this.rateCount});
  int? id;
  String? title;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? bio;
  String? degree;
  int? gender;
  int? balance;
  double? rate;
  int? rateCount;
  String? fcmToken;
  String? imagePath;
  String? cvPath;
  String? video;
  NationalityModel? nationality;
  List<SpecializationsModel>? specializations;
  List<EducationalStageModel>? educationalStages;
  String? provider;
  BankAccountModel? bankAccount;
  final double wallet;
  final String appRatio;
  final double deservedAmount;
  final double expectedAmount;
  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        title: json["title"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        bio: json["bio"],
        degree: json["degree"],
        gender: json["gender"],
        balance: json["balance"],
        rate: json["rate"] == null ? null : (json["rate"] as num).toDouble(),
        fcmToken: json["fcm_token"],
        imagePath: json["image_path"],
        cvPath: json["cv_path"],
        video: json["video"],
        nationality: json["nationality"] == null
            ? null
            : NationalityModel.fromJson(json["nationality"]),
        specializations: json["specializations"] == null
            ? null
            : List<SpecializationsModel>.from(json["specializations"]
                .map((x) => SpecializationsModel.fromJson(x))),
        educationalStages: json["educational_stages"] == null
            ? null
            : List<EducationalStageModel>.from(json["educational_stages"]
                .map((x) => EducationalStageModel.fromJson(x))),
        wallet: double.tryParse(json["wallet"].toString()) ?? 0,
        appRatio: json["app_ratio"] ?? "",
        deservedAmount: json["deserved_amount"] == null
            ? 0.0
            : (json["deserved_amount"] as num).toDouble(),
        expectedAmount: json["expected_amount"] == null
            ? 0.0
            : (json["expected_amount"] as num).toDouble(),
        provider: json["provider"],
        bankAccount: json["bank_account"] == null
            ? null
            : BankAccountModel.fromJson(json["bank_account"]),
      );
}
