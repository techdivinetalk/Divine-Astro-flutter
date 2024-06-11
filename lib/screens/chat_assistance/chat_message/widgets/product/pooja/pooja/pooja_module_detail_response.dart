class PoojaModuleDetailResponse {
  PageDetail? pageDetail;
  PoojaDetails? poojaDetails;
  List<CustomerTestimonials>? customerTestimonials;
  Cta? cta;
  bool? success;
  int? statusCode;
  String? message;

  PoojaModuleDetailResponse(
      {this.pageDetail,
      this.poojaDetails,
      this.customerTestimonials,
      this.cta,
      this.success,
      this.statusCode,
      this.message});

  PoojaModuleDetailResponse.fromJson(Map<String, dynamic> json) {
    pageDetail = json['page_detail'] != null ? PageDetail.fromJson(json['page_detail']) : null;
    poojaDetails = json['pooja_details'] != null ? PoojaDetails.fromJson(json['pooja_details']) : null;
    if (json['customer_testimonials'] != null) {
      customerTestimonials = <CustomerTestimonials>[];
      json['customer_testimonials'].forEach((v) {
        customerTestimonials!.add(CustomerTestimonials.fromJson(v));
      });
    }
    cta = json['cta'] != null ? Cta.fromJson(json['cta']) : null;
    success = json['success'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pageDetail != null) {
      data['page_detail'] = pageDetail!.toJson();
    }
    if (poojaDetails != null) {
      data['pooja_details'] = poojaDetails!.toJson();
    }
    if (customerTestimonials != null) {
      data['customer_testimonials'] = customerTestimonials!.map((v) => v.toJson()).toList();
    }
    if (cta != null) {
      data['cta'] = cta!.toJson();
    }
    data['success'] = success;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}

class PageDetail {
  String? title;
  Countdown? countdown;

  PageDetail({this.title, this.countdown});

  PageDetail.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    countdown = json['countdown'] != null ? Countdown.fromJson(json['countdown']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (countdown != null) {
      data['countdown'] = countdown!.toJson();
    }
    return data;
  }
}

class Countdown {
  String? timeStart;

  Countdown({this.timeStart});

  Countdown.fromJson(Map<String, dynamic> json) {
    timeStart = json['time_start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_start'] = timeStart;
    return data;
  }
}

class PoojaDetails {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  Astrologer? astrologer;
  List<String>? benefits;
  Process? process;

  PoojaDetails(
      {this.id, this.name, this.description, this.imageUrl, this.astrologer, this.benefits, this.process});

  PoojaDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    astrologer = json['astrologer'] != null ? Astrologer.fromJson(json['astrologer']) : null;
    benefits = json['benefits'].cast<String>();
    process = json['process'] != null ? Process.fromJson(json['process']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image_url'] = imageUrl;
    if (astrologer != null) {
      data['astrologer'] = astrologer!.toJson();
    }
    data['benefits'] = benefits;
    if (process != null) {
      data['process'] = process!.toJson();
    }
    return data;
  }
}

class Astrologer {
  String? name;
  int? id;
  String? profileImageUrl;

  Astrologer({this.name, this.id, this.profileImageUrl});

  Astrologer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    profileImageUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['profile_image_url'] = profileImageUrl;
    return data;
  }
}

class Process {
  List<String>? steps;
  List<String>? arrangements;

  Process({this.steps, this.arrangements});

  Process.fromJson(Map<String, dynamic> json) {
    steps = json['steps'].cast<String>();
    arrangements = json['arrangements'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['steps'] = steps;
    data['arrangements'] = arrangements;
    return data;
  }
}

class CustomerTestimonials {
  String? name;
  String? date;
  String? comment;
  int? rating;

  CustomerTestimonials({this.name, this.date, this.comment, this.rating});

  CustomerTestimonials.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    comment = json['comment'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['date'] = date;
    data['comment'] = comment;
    data['rating'] = rating;
    return data;
  }
}

class Cta {
  String? buttonText;
  String? buttonColor;
  String? buttonColorBg;

  Cta({this.buttonText, this.buttonColor, this.buttonColorBg});

  Cta.fromJson(Map<String, dynamic> json) {
    buttonText = json['button_text'];
    buttonColor = json['button_color'];
    buttonColorBg = json['button_color_bg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['button_text'] = buttonText;
    data['button_color'] = buttonColor;
    data['button_color_bg'] = buttonColorBg;
    return data;
  }
}
