import '../models/product.dart';
import '../data/mock_products.dart';

class DatabaseService {
  // Simulate database lookup with delay
  Future<Product?> fetchProductByBarcode(String barcode) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return MockProducts.getProductByBarcode(barcode);
  }

  // Search products by name or brand
  Future<List<Product>> searchProducts(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return [];
    }
    
    return MockProducts.searchProducts(query);
  }

  // Get all products (for testing/browsing)
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockProducts.getAllProducts();
  }

  // Check if product exists in database
  Future<bool> productExists(String barcode) async {
    final product = await fetchProductByBarcode(barcode);
    return product != null;
  }
}
