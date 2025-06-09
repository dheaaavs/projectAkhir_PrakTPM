class WishModel {
  String? status;
  String? message;
  List<Wishes>? data;

  WishModel({this.status, this.message, this.data});

  WishModel.fromJson(Map<String, dynamic> json) {
    status  = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = (json['data'] as List)
          .map((e) => Wishes.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Map<String, dynamic> toJson() => {
    'status' : status,
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
  bool?   acquired;
  String? createdAt;   // <─ ditambahkan
  String? updatedAt;   // <─ ditambahkan

  Wishes({
    this.id,
    this.title,
    this.price,
    this.desc,
    this.image,
    this.category,
    this.priority,
    this.acquired,
    this.createdAt,
    this.updatedAt,
  });

  factory Wishes.fromJson(Map<String, dynamic> json) {
    String? imageUrl;

    // --- konversi Buffer -> String URL jika ada ---
    try {
      final img = json['image'];
      if (img is Map && img['data'] is List) {
        List<int> bytes = List<int>.from(img['data']);
        if (bytes.isNotEmpty) {
          imageUrl = String.fromCharCodes(bytes);
        }
      } else if (img is String) {
        imageUrl = img;
      }
    } catch (_) {
      imageUrl = null;
    }

    return Wishes(
      id        : json['id'],
      title     : json['title'],
      price     : json['price'],
      desc      : json['desc'],
      image     : imageUrl,
      category  : json['category'],
      priority  : json['priority'],
      acquired  : json['acquired'],
      createdAt : json['createdAt'],
      updatedAt : json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id'       : id,
    'title'    : title,
    'price'    : price,
    'desc'     : desc,
    'image'    : image,
    'category' : category,
    'priority' : priority,
    'acquired' : acquired,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
