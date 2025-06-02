class WishModel {
  String? status;
  String? message;
  List<Wishes>? data;

  WishModel({this.status, this.message, this.data});

  WishModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Wishes>[];
      json['data'].forEach((v) {
        data!.add(Wishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wishes {
  int? id;
  String? title;
  int? price;
  String? desc;
  String? image;
  String? category;
  String? priority;
  bool? acquired;
  String? createdAt;
  String? updatedAt;

  Wishes(
      {this.id,
        this.title,
        this.price,
        this.desc,
        this.image,
        this.category,
        this.priority,
        this.acquired,
        this.createdAt,
        this.updatedAt});

  Wishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    desc = json['desc'];
    image = json['image'];
    category = json['category'];
    priority = json['priority'];
    acquired = json['acquired'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['desc'] = this.desc;
    data['image'] = this.image;
    data['category'] = this.category;
    data['priority'] = this.priority;
    data['acquired'] = this.acquired;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}