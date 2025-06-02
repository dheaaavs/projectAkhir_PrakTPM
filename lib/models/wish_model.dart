class WishModel {
  String? status;
  String? message;
  List<Wishes>? data;

  WishModel({this.status, this.message, this.data});

  WishModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => Wishes.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    if (data != null) 'data': data!.map((v) => v.toJson()).toList(),
  };
}

class Wishes {
  int? id;
  String? title;
  int? price;
  String? desc;
  String? image;
  String? category;
  String? priority;
  bool acquired = false; // Default value langsung di deklarasi
  String? createdAt;
  String? updatedAt;

  Wishes({
    this.id,
    this.title,
    this.price,
    this.desc,
    this.image,
    this.category,
    this.priority,
    bool? acquired, // Opsional untuk override
    this.createdAt,
    this.updatedAt,
  }) : acquired = acquired ?? false; // Nilai override jika ada

  Wishes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'] is int
        ? json['price']
        : int.tryParse(json['price'].toString());
    desc = json['desc'];
    image = json['image'] is String
        ? json['image']
        : (json['image']?['secure_url'] ?? '') as String;
    category = json['category'];
    priority = json['priority'];
    acquired = json['acquired'] ?? false;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'desc': desc,
    'image': image,
    'category': category,
    'priority': priority,
    'acquired': acquired,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
