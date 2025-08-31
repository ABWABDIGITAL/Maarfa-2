class BankAccountModel {
  BankAccountModel({this.bankAccountData, this.walletData});

  BankAccountData? bankAccountData;
  WalletModel? walletData;
  factory BankAccountModel.fromJson(Map<String, dynamic> json) =>
      BankAccountModel(
        bankAccountData: json["bank"] != null
            ? BankAccountData.fromJson(json["bank"])
            : null,
        walletData: json["wallet"] != null
            ? WalletModel.fromJson(json["wallet"])
            : null,
      );
}

class BankAccountData {
  BankAccountData(
      {this.id,
      this.swiftCode,
      this.address,
      this.bankName,
      this.cityId,
      this.iban});

  int? id;
  String? swiftCode;
  String? bankName;
  String? address;
  String? iban;
  int? cityId;

  factory BankAccountData.fromJson(Map<String, dynamic> json) =>
      BankAccountData(
        id: json["id"],
        swiftCode: json["swift_code"],
        bankName: json["bank_name"],
        iban: json["iban"],
        address: json["address"],
        cityId: json["city_id"],
      );
}

class WalletModel {
  WalletModel({
    this.id,
    this.swiftCode,
    this.walletName,
    this.walletNumber,
    this.address,
    this.type,
    this.city,
    this.providerId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? swiftCode;
  String? walletName;
  String? walletNumber;
  String? address;
  String? type; // Should be 'wallet'
  String? city;
  int? providerId;
  String? createdAt;
  String? updatedAt;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        id: json["id"],
        swiftCode: json["swift_code"],
        walletName: json["wallet_name"],
        walletNumber: json["wallet_number"],
        address: json["address"],
        type: json["type"],
        city: json["city"],
        providerId: json["provider_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "swift_code": swiftCode,
        "wallet_name": walletName,
        "wallet_number": walletNumber,
        "address": address,
        "type": type,
        "city": city,
        "provider_id": providerId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
