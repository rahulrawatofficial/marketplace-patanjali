// To parse this JSON data, do
//
//     final postAdModel = postAdModelFromJson(jsonString);

import 'dart:convert';

String postAdModelToJson(PostAdModel data) => json.encode(data.toJson());
String postAdModelFixedToJson(PostAdModelFixed data) =>
    json.encode(data.toJson());

class PostAdModel {
  List<UploadImage> uploadImage;
  UploadVideo uploadVideo;
  ReqData reqData;

  PostAdModel({
    this.uploadImage,
    this.uploadVideo,
    this.reqData,
  });

  Map<String, dynamic> toJson() => {
        "uploadImage": List<dynamic>.from(uploadImage.map((x) => x.toJson())),
        "uploadVideo": uploadVideo != null ? uploadVideo : {},
        "reqData": reqData.toJson(),
      };
}

class ReqData {
  String partyId;
  String productId;
  String description;
  DateTime closedDateTime;
  String quantity;
  String minimumQuantity;
  String minimumAmount;
  String fixedProduct;
  String quality;
  String organicCertificateNumber;
  String adType;
  String unit;
  String unitForFxiedPrice;

  String unitForMinimumAmount;
  String minimumUnit;
  String latitude;
  String longitude;
  String country;
  String state;
  String district;
  String tehsil;
  String block;
  String village;
  String custRequestCategoryId;

  ReqData({
    this.partyId,
    this.productId,
    this.description,
    this.closedDateTime,
    this.quantity,
    this.minimumQuantity,
    this.minimumAmount,
    this.fixedProduct,
    this.quality,
    this.organicCertificateNumber,
    this.adType,
    this.unit,
    this.unitForFxiedPrice,
    this.unitForMinimumAmount,
    this.minimumUnit,
    this.latitude,
    this.longitude,
    this.country,
    this.state,
    this.district,
    this.tehsil,
    this.block,
    this.village,
    this.custRequestCategoryId,
  });
  Map<String, dynamic> toJson() => quality == "CERTIFIED_ORGANIC"
      ? {
          "partyId": partyId,
          "productId": productId,
          "description": description,
          "closedDateTime": closedDateTime.toUtc().toString().substring(0, 19),
          "quantity": quantity,
          "minimumQuantity": minimumQuantity,
          "minimumAmount": minimumAmount,
          "fixedProduct": fixedProduct,
          "quality": quality,
          "organicCertificateNumber": organicCertificateNumber,
          "adType": adType,
          "unit": unit,
          "unitForFxiedPrice": unitForFxiedPrice,
          "unitForMinimumAmount": unitForMinimumAmount,
          "minimumUnit": minimumUnit,
          "latitude": latitude,
          "longitude": longitude,
          "country": country,
          "state": state,
          "district": district,
          "tehsil": tehsil,
          "adType": adType,
          "block": block,
          "village": village,
          "custRequestCategoryId": custRequestCategoryId,
        }
      : {
          "partyId": partyId,
          "productId": productId,
          "description": description,
          "closedDateTime": closedDateTime.toUtc().toString().substring(0, 19),
          "quantity": quantity,
          "minimumQuantity": minimumQuantity,
          "minimumAmount": minimumAmount,
          "minimumUnit": minimumUnit,
          "fixedProduct": fixedProduct,
          "unitForMinimumAmount": unitForMinimumAmount,
          "quality": quality,
          "adType": adType,
          "unit": unit,
          "unitForFxiedPrice": unitForFxiedPrice,
          "latitude": latitude,
          "longitude": longitude,
          "country": country,
          "state": state,
          "district": district,
          "tehsil": tehsil,
          "adType": adType,
          "block": block,
          "village": village,
          "custRequestCategoryId": custRequestCategoryId,
        };
}

class PostAdModelFixed {
  List<UploadImage> uploadImage;
  UploadVideo uploadVideo;
  ReqDataFixed reqData;

  PostAdModelFixed({
    this.uploadImage,
    this.uploadVideo,
    this.reqData,
  });

  Map<String, dynamic> toJson() => {
        "uploadImage": List<dynamic>.from(uploadImage.map((x) => x)),
        "uploadVideo": uploadVideo != null ? uploadVideo : {},
        "reqData": reqData.toJson(),
      };
}

class ReqDataFixed {
  String partyId;
  String productId;
  String description;
  DateTime closedDateTime;
  String quantity;
  String minimumQuantity;
  String minimumAmount;
  String fixedProduct;
  String amount;
  String quality;
  String organicCertificateNumber;
  String adType;
  String unit;
  String unitForFxiedPrice;
  String minimumUnit;
  String latitude;
  String longitude;
  String country;
  String state;
  String district;
  String tehsil;
  String block;
  String village;

  ReqDataFixed({
    this.partyId,
    this.productId,
    this.description,
    this.closedDateTime,
    this.quantity,
    this.minimumQuantity,
    this.minimumAmount,
    this.fixedProduct,
    this.amount,
    this.quality,
    this.organicCertificateNumber,
    this.adType,
    this.unit,
    this.unitForFxiedPrice,
    this.minimumUnit,
    this.latitude,
    this.longitude,
    this.country,
    this.state,
    this.district,
    this.tehsil,
    this.block,
    this.village,
  });

  Map<String, dynamic> toJson() => quality == "CERTIFIED_ORGANIC"
      ? {
          "partyId": partyId,
          "productId": productId,
          "description": description,
          "closedDateTime": closedDateTime.toUtc().toString().substring(0, 19),
          "quantity": quantity,
          "minimumQuantity": minimumQuantity,
          "minimumAmount": minimumAmount,
          "fixedProduct": fixedProduct,
          "amount": amount,
          "quality": quality,
          "organicCertificateNumber": organicCertificateNumber,
          "adType": adType,
          "unit": unit,
          "unitForFxiedPrice": unitForFxiedPrice,
          "minimumUnit": minimumUnit,
          "latitude": latitude,
          "longitude": longitude,
          "country": country,
          "state": state,
          "district": district,
          "tehsil": tehsil,
          "adType": adType,
          "block": block,
          "village": village,
        }
      : {
          "partyId": partyId,
          "productId": productId,
          "description": description,
          "closedDateTime": closedDateTime.toUtc().toString().substring(0, 19),
          "quantity": quantity,
          "minimumQuantity": minimumQuantity,
          "minimumAmount": minimumAmount,
          "fixedProduct": fixedProduct,
          "amount": amount,
          "quality": quality,
          "adType": adType,
          "unit": unit,
          "unitForFxiedPrice": unitForFxiedPrice,
          "minimumUnit": minimumUnit,
          "latitude": latitude,
          "longitude": longitude,
          "country": country,
          "state": state,
          "district": district,
          "tehsil": tehsil,
          "adType": adType,
          "block": block,
          "village": village,
        };
}

class UploadImage {
  String image;
  String fileName;
  String mimeTypeId;

  UploadImage({
    this.image,
    this.fileName,
    this.mimeTypeId,
  });

  factory UploadImage.fromJson(Map<String, dynamic> json) => UploadImage(
        image: json["image"],
        fileName: json["fileName"],
        mimeTypeId: json["mimeTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "fileName": fileName,
        "mimeTypeId": mimeTypeId,
      };
}

class UploadVideo {
  String video;
  String fileName;
  String mimeTypeId;

  UploadVideo({
    this.video,
    this.fileName,
    this.mimeTypeId,
  });

  factory UploadVideo.fromJson(Map<String, dynamic> json) => UploadVideo(
        video: json["video"],
        fileName: json["fileName"],
        mimeTypeId: json["mimeTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "video": video,
        "fileName": fileName,
        "mimeTypeId": mimeTypeId,
      };
}
