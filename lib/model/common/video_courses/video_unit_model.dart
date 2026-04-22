class VideoUnitModel {
  VideoUnitModel({
    this.id,
    this.title,
    this.description,
    this.youtubeUrl,
    this.duration,
    this.price,
    this.isFree,
    this.sortOrder,
    this.isPurchased,
  });

  int? id;
  String? title;
  String? description;
  String? youtubeUrl;
  int? duration;
  double? price;
  bool? isFree;
  int? sortOrder;
  bool? isPurchased;

  factory VideoUnitModel.fromJson(Map<String, dynamic> json) => VideoUnitModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        youtubeUrl: json["youtube_url"],
        duration: json["duration"],
        price: json["price"] != null ? (json["price"] as num).toDouble() : null,
        isFree: json["is_free"],
        sortOrder: json["sort_order"],
        isPurchased: json["is_purchased"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "youtube_url": youtubeUrl,
        "duration": duration,
        "price": price,
        "is_free": isFree,
        "sort_order": sortOrder,
        "is_purchased": isPurchased,
      };
}
