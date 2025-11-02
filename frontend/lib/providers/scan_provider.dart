import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/scan_history.dart';
import '../models/product.dart';

class ScanProvider with ChangeNotifier {
  List<ScanHistory> _scanHistory = [];
  List<String> _favoriteProductIds = [];

  List<ScanHistory> get scanHistory => _scanHistory;
  List<String> get favoriteProductIds => _favoriteProductIds;

  // Get recent scans (last 10)
  List<ScanHistory> get recentScans {
    return _scanHistory.take(10).toList();
  }

  // Get favorite scans
  List<ScanHistory> get favoriteScans {
    return _scanHistory.where((scan) => scan.isFavorite).toList();
  }

  // Initialize and load saved data
  Future<void> initialize() async {
    await loadScanHistory();
    await loadFavorites();
  }

  // Load scan history from local storage
  Future<void> loadScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('scan_history');

      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _scanHistory = decoded.map((item) => ScanHistory.fromJson(item)).toList();
        // Sort by timestamp (most recent first)
        _scanHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        notifyListeners();
      }
    } catch (e) {
      print('Error loading scan history: $e');
    }
  }

  // Save scan history to local storage
  Future<void> saveScanHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_scanHistory.map((scan) => scan.toJson()).toList());
      await prefs.setString('scan_history', encoded);
    } catch (e) {
      print('Error saving scan history: $e');
    }
  }

  // Load favorites from local storage
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString('favorite_products');

      if (favoritesJson != null) {
        final List<dynamic> decoded = jsonDecode(favoritesJson);
        _favoriteProductIds = decoded.cast<String>();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  // Save favorites to local storage
  Future<void> saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorite_products', jsonEncode(_favoriteProductIds));
    } catch (e) {
      print('Error saving favorites: $e');
    }
  }

  // Add a new scan to history
  Future<void> addScan(Product product) async {
    final scan = ScanHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      product: product,
      isFavorite: _favoriteProductIds.contains(product.id),
    );

    // Add to beginning of list
    _scanHistory.insert(0, scan);

    // Keep only last 100 scans
    if (_scanHistory.length > 100) {
      _scanHistory = _scanHistory.take(100).toList();
    }

    await saveScanHistory();
    notifyListeners();
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }

    // Update scan history items
    _scanHistory = _scanHistory.map((scan) {
      if (scan.product.id == productId) {
        return scan.copyWith(isFavorite: _favoriteProductIds.contains(productId));
      }
      return scan;
    }).toList();

    await saveFavorites();
    await saveScanHistory();
    notifyListeners();
  }

  // Check if product is favorite
  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  // Remove scan from history
  Future<void> removeScan(String scanId) async {
    _scanHistory.removeWhere((scan) => scan.id == scanId);
    await saveScanHistory();
    notifyListeners();
  }

  // Clear all scan history
  Future<void> clearHistory() async {
    _scanHistory.clear();
    await saveScanHistory();
    notifyListeners();
  }

  // Clear all favorites
  Future<void> clearFavorites() async {
    _favoriteProductIds.clear();
    
    // Update scan history items
    _scanHistory = _scanHistory.map((scan) {
      return scan.copyWith(isFavorite: false);
    }).toList();

    await saveFavorites();
    await saveScanHistory();
    notifyListeners();
  }

  // Get scan by ID
  ScanHistory? getScanById(String scanId) {
    try {
      return _scanHistory.firstWhere((scan) => scan.id == scanId);
    } catch (e) {
      return null;
    }
  }

  // Search scans by product name
  List<ScanHistory> searchScans(String query) {
    final lowerQuery = query.toLowerCase();
    return _scanHistory.where((scan) {
      return scan.product.nameEnglish.toLowerCase().contains(lowerQuery) ||
          scan.product.nameKorean.contains(query) ||
          scan.product.brand.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Filter scans by dietary preference
  List<ScanHistory> filterByDietary(String dietary) {
    switch (dietary.toLowerCase()) {
      case 'halal':
        return _scanHistory.where((scan) => scan.product.isHalal).toList();
      case 'vegan':
        return _scanHistory.where((scan) => scan.product.isVegan).toList();
      case 'vegetarian':
        return _scanHistory.where((scan) => scan.product.isVegetarian).toList();
      case 'kosher':
        return _scanHistory.where((scan) => scan.product.isKosher).toList();
      default:
        return _scanHistory;
    }
  }
}
