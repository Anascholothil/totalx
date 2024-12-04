// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModels {
 String userId;
 String? id;
 String productName;
 int  price;
 int stock; 
 Timestamp createdAt;
  ProductModels({
    required this.userId,
     this.id,
    required this.productName,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  ProductModels copyWith({
    String? userId,
    String? id,
    String? productName,
    int? price,
    int? stock,
    Timestamp? createdAt,
  }) {
    return ProductModels(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'productName': productName,
      'price': price,
      'stock': stock,
      'createdAt': createdAt,
    };
  }

  factory ProductModels.fromMap(Map<String, dynamic> map) {
    return ProductModels(
      userId: map['userId'] as String,
      id: map['id'] as String,
      productName: map['productName'] as String,
      price: map['price'] as int,
      stock: map['stock'] as int,
      createdAt:map['createdAt'] as Timestamp,
    );
  }
 
  }

