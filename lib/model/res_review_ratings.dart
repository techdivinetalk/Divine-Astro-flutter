class ResReviewRatings {
  Data? data;
  bool? success;
  int? statusCode;
  String? message;

  ResReviewRatings({this.data, this.success, this.statusCode, this.message});

  ResReviewRatings.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class Data {
  int? totalReviews;
  double? totalRating;
  int? i1Rating;
  int? i2Rating;
  int? i3Rating;
  int? i4Rating;
  int? i5Rating;
  List<AllReviews>? allReviews;
  AstrologerDetails? astrologerDetails;

  Data(
      {this.totalReviews,
      this.totalRating,
      this.i1Rating,
      this.i2Rating,
      this.i3Rating,
      this.i4Rating,
      this.i5Rating,
      this.allReviews,
      this.astrologerDetails});

  Data.fromJson(Map<String, dynamic> json) {
    totalReviews = json['total_reviews'];
    totalRating = json['total_rating'];
    i1Rating = json['1_rating'];
    i2Rating = json['2_rating'];
    i3Rating = json['3_rating'];
    i4Rating = json['4_rating'];
    i5Rating = json['5_rating'];
    if (json['all_reviews'] != null) {
      allReviews = <AllReviews>[];
      json['all_reviews'].forEach((v) {
        allReviews!.add(AllReviews.fromJson(v));
      });
    }
    astrologerDetails = json['astrologer_details'] != null
        ? AstrologerDetails.fromJson(json['astrologer_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_reviews'] = totalReviews;
    data['total_rating'] = totalRating;
    data['1_rating'] = i1Rating;
    data['2_rating'] = i2Rating;
    data['3_rating'] = i3Rating;
    data['4_rating'] = i4Rating;
    data['5_rating'] = i5Rating;
    if (allReviews != null) {
      data['all_reviews'] = allReviews!.map((v) => v.toJson()).toList();
    }
    if (astrologerDetails != null) {
      data['astrologer_details'] = astrologerDetails!.toJson();
    }
    return data;
  }
}

class AllReviews {
  int? isAnonymous;
  String? customerName;
  String? customerImage;
  int? customerId;
  String? reviewDate;
  String? comment;
  double? rating;
  int? id;
  // Null? replyData;

  AllReviews({
    this.isAnonymous,
    this.customerName,
    this.customerImage,
    this.customerId,
    this.reviewDate,
    this.comment,
    this.rating,
    this.id,
    // this.replyData
  });

  AllReviews.fromJson(Map<String, dynamic> json) {
    isAnonymous = json['is_anonymous'];
    customerName = json['customer_name'];
    customerImage = json['customer_image'];
    customerId = json['customer_id'];
    reviewDate = json['review_date'];
    comment = json['comment'];
    rating = json['rating'];
    id = json['id'];
    // replyData = json['reply_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_anonymous'] = isAnonymous;
    data['customer_name'] = customerName;
    data['customer_image'] = customerImage;
    data['customer_id'] = customerId;
    data['review_date'] = reviewDate;
    data['comment'] = comment;
    data['rating'] = rating;
    data['id'] = id;
    // data['reply_data'] = this.replyData;
    return data;
  }
}

class AstrologerDetails {
  int? id;
  String? name;
  int? experiance;
  String? image;

  AstrologerDetails({this.id, this.name, this.experiance, this.image});

  AstrologerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    experiance = json['experiance'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['experiance'] = experiance;
    data['image'] = image;
    return data;
  }
}
