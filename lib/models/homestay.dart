class Homestay {
  String? homestayId;
  String? userId;
  String? homestayImages;
  String? homestayName;
  String? homestayDesc;
  String? homestayPrice;
  String? homestayAddress;
  String? homestayState;
  String? homestayLocal;
  String? homestayLat;
  String? homestayLng;
  String? homestayDate;

  Homestay(
      {this.homestayId,
      this.userId,
      this.homestayImages,
      this.homestayName,
      this.homestayDesc,
      this.homestayPrice,
      this.homestayAddress,
      this.homestayState,
      this.homestayLocal,
      this.homestayLat,
      this.homestayLng,
      this.homestayDate});

  Homestay.fromJson(Map<String, dynamic> json) {
    homestayId = json['homestay_id'];
    userId = json['user_id'];
    homestayImages = json['homestay_imagesNum'];
    homestayName = json['homestay_name'];
    homestayDesc = json['homestay_desc'];
    homestayPrice = json['homestay_price'];
    homestayAddress = json['homestay_address'];
    homestayState = json['homestay_state'];
    homestayLocal = json['homestay_local'];
    homestayLat = json['homestay_lat'];
    homestayLng = json['homestay_lng'];
    homestayDate = json['homestay_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['homestay_id'] = homestayId;
    data['user_id'] = userId;
    data['homestay_imagesNum'] = homestayImages;
    data['homestay_name'] = homestayName;
    data['homestay_desc'] = homestayDesc;
    data['homestay_price'] = homestayPrice;
    data['homestay_address'] = homestayAddress;
    data['homestay_state'] = homestayState;
    data['homestay_local'] = homestayLocal;
    data['homestay_lat'] = homestayLat;
    data['homestay_lng'] = homestayLng;
    data['homestay_date'] = homestayDate;
    return data;
  }
}