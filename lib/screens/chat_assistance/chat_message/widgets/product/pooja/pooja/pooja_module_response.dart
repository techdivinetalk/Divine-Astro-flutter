class PoojaModuleResponse {
  String? pageTitle;
  List<Events>? events;

  PoojaModuleResponse({this.pageTitle, this.events});

  PoojaModuleResponse.fromJson(Map<String, dynamic> json) {
    pageTitle = json['page_title'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_title'] = pageTitle;
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int? id;
  String? date;
  String? title;
  String? description;
  int? productId;
  String? imageUrl;
  int? astroId;
  String? astroImage;

  Events(
      {this.id,
      this.date,
      this.title,
      this.description,
      this.productId,
      this.imageUrl,
      this.astroId,
      this.astroImage});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    description = json['description'];
    productId = json['product_id'];
    imageUrl = json['image_url'];
    astroId = json['astro_id'];
    astroImage = json['astro_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['title'] = title;
    data['description'] = description;
    data['product_id'] = productId;
    data['image_url'] = imageUrl;
    data['astro_id'] = astroId;
    data['astro_image'] = astroImage;
    return data;
  }
}
