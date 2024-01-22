class DeckCardModel {
  int? id;
  String? name;
  int? status;
  String? image;

  DeckCardModel({this.id, this.name, this.status, this.image});

  DeckCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['image'] = this.image;
    return data;
  }
}
