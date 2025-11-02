import 'product.dart';

class ScanHistory {
  final String id;
  final DateTime timestamp;
  final Product product;
  final bool isFavorite;

  ScanHistory({
    required this.id,
    required this.timestamp,
    required this.product,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'product': product.toJson(),
      'isFavorite': isFavorite,
    };
  }

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      product: Product.fromJson(json['product']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  ScanHistory copyWith({
    String? id,
    DateTime? timestamp,
    Product? product,
    bool? isFavorite,
  }) {
    return ScanHistory(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      product: product ?? this.product,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
