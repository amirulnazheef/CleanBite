# CleanBite App - Detailed Implementation Plan

## Project Overview
CleanBite is a Flutter app that helps users identify dietary classifications of food products by scanning barcodes. The app focuses on Korean products, translating ingredients to English and determining if products are Halal, Vegan, Kosher, etc.

## Core Flow
1. **Barcode Scan** → Check mock database
2. **If not found** → OCR ingredient text from product label
3. **Translate** Korean text to English
4. **Classify** ingredients based on dietary rules
5. **Display** results with explanations

---

## Information Gathered

### Current State
- **Existing Files:**
  - `lib/main.dart`: Routes defined but some screens missing
  - `lib/screens/splash_screen.dart`: Onboarding implemented with swiper
  - `lib/screens/scan_screen.dart`: Basic barcode logic, references missing services
  - `lib/screens/home_screen.dart`: Currently a recipe app (needs complete rewrite)
  - `lib/services/translation_service.dart`: Google Translate API integration
  - `pubspec.yaml`: Only has cupertino_icons, needs many dependencies

- **Missing Components:**
  - Login screen
  - Results screen
  - Ingredient explanation screen
  - Settings screen
  - Profile screen (needs update)
  - OCR service
  - Database service (mock)
  - AI classification service
  - Product/Ingredient models
  - State management (Provider)

### Technical Requirements
- Flutter SDK 3.9.2+
- Mock database for initial implementation
- Google Translate API for Korean→English
- OCR for ingredient text extraction
- Dietary classification logic (Halal, Vegan, Kosher, allergens)

---

## Detailed Implementation Plan

### Phase 1: Dependencies Setup
**Files to modify:** `pubspec.yaml`

Add dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Barcode & Image
  barcode_scan2: ^4.3.3
  image_picker: ^1.0.7
  
  # OCR
  google_ml_kit: ^0.16.3
  
  # Network
  http: ^1.2.0
  
  # UI Components
  flutter_swiper_null_safety: ^1.0.2
  
  # State Management
  provider: ^6.1.1
  
  # Local Storage
  shared_preferences: ^2.2.2
```

---

### Phase 2: Data Models
**New files to create:**

1. **`lib/models/product.dart`**
   - Product ID, name, barcode
   - Brand, image URL
   - Ingredients list
   - Dietary classifications (isHalal, isVegan, isKosher, etc.)
   - Allergen warnings

2. **`lib/models/ingredient.dart`**
   - Ingredient name (Korean & English)
   - Dietary classifications
   - Allergen info
   - Source/reference

3. **`lib/models/user_preferences.dart`**
   - User name, language preference
   - Dietary restrictions (List<String>)
   - Allergen alerts (List<String>)
   - Dark mode preference

4. **`lib/models/scan_history.dart`**
   - Scan timestamp
   - Product reference
   - Classification result

---

### Phase 3: Services Layer
**New files to create:**

1. **`lib/services/database_service.dart`**
   - Mock database with 10-15 sample Korean products
   - `Future<Product?> fetchProductByBarcode(String barcode)`
   - `Future<List<Product>> searchProducts(String query)`
   - Products include common Korean items with Korean ingredient lists

2. **`lib/services/ocr_service.dart`**
   - Use google_ml_kit for text recognition
   - `Future<String> extractTextFromImage(String imagePath)`
   - Handle Korean character recognition
   - Error handling for poor image quality

3. **`lib/services/ai_classification_service.dart`**
   - Rule-based classification logic
   - `Future<Map<String, dynamic>> classifyIngredients(List<String> ingredients)`
   - Check against known non-Halal ingredients (gelatin, alcohol, pork derivatives)
   - Check against non-Vegan ingredients (dairy, eggs, honey, animal products)
   - Check against allergens (nuts, soy, gluten, etc.)
   - Return classification with reasons

**File to update:**
4. **`lib/services/translation_service.dart`**
   - Ensure proper error handling
   - Add retry logic
   - Cache translations locally

---

### Phase 4: State Management
**New files to create:**

1. **`lib/providers/user_provider.dart`**
   - Manage user authentication state
   - Store user preferences
   - Language selection
   - Persist data with shared_preferences

2. **`lib/providers/scan_provider.dart`**
   - Manage scan history
   - Favorite products list
   - Recent scans
   - Persist data locally

---

### Phase 5: Screens Implementation

#### 1. **`lib/screens/login_screen.dart`** (NEW)
**UI Components:**
- App logo and tagline
- Login options: Email, Google, Apple (mock buttons)
- Profile setup form:
  - Name input field
  - Dietary preferences checkboxes (Halal, Kosher, Vegan, Vegetarian, Pescatarian)
  - Allergy checkboxes (Nuts, Dairy, Gluten, Soy, Eggs, Shellfish)
  - Language dropdown (Korean, English)
- "Save Preferences" button
- "Continue as Guest" button
- Navigate to home screen after setup

#### 2. **`lib/screens/home_screen.dart`** (COMPLETE REWRITE)
**UI Components:**
- AppBar with "CleanBite" title and profile icon
- Search bar for manual product search
- Floating Action Button (FAB) for camera/scan
- Recent scans section:
  - List of last 5-10 scanned products
  - Show product name, image thumbnail
  - Dietary status icons (✓ or ✗)
  - Tap to view details
- Quick filter chips:
  - "Halal", "Vegan", "Kosher", "Allergy-Safe", "All"
  - Filter recent scans by dietary preference
- Empty state when no scans yet

#### 3. **`lib/screens/scan_screen.dart`** (UPDATE)
**UI Components:**
- Camera preview with barcode frame overlay
- Instruction text: "Align barcode inside the box"
- Scan button
- Manual input button (opens text field for barcode entry)
- Loading overlay during processing:
  - "Scanning barcode..."
  - "Checking database..."
  - "Analyzing ingredients..."
  - "Translating..."
  - "Classifying..."

**Logic Flow:**
```
1. Scan barcode
2. Query DatabaseService
3. If found → Navigate to ResultsScreen
4. If not found:
   a. Prompt user to take photo of ingredients
   b. Use OCRService to extract text
   c. Use TranslationService to translate Korean→English
   d. Use AIClassificationService to classify
   e. Navigate to ResultsScreen with data
```

#### 4. **`lib/screens/results_screen.dart`** (NEW)
**UI Components:**
- Product image (if available)
- Product name and brand
- Dietary classification badges:
  - ✅ Halal | ❌ Not Vegan | ⚠️ Contains Nuts
  - Color-coded (green, red, orange)
- Explanation card:
  - "This product contains gelatin (animal-sourced)"
  - "Not suitable for Halal or Vegan diets"
- Ingredients list:
  - Show all ingredients
  - Highlight problematic ones in red
  - Korean text with English translation
- Action buttons:
  - Save to favorites (heart icon)
  - Report incorrect info
  - Share
- "See ingredient details" button → Navigate to IngredientExplanationScreen

#### 5. **`lib/screens/ingredient_explanation_screen.dart`** (NEW)
**UI Components:**
- Ingredient name (Korean + English)
- Dietary classifications section:
  - Halal status: ✅ Halal / ❌ Haram / ⚠️ Doubtful
  - Vegan status: ✅ Vegan / ❌ Contains animal products
  - Kosher status
  - Allergen info
- Explanation card:
  - "Gelatin is derived from animal collagen"
  - "Common sources: pork, beef, fish"
  - "Not suitable for vegetarian/vegan diets"
- Reference links (optional)
- "Add to watchlist" button
- "Suggest correction" button

#### 6. **`lib/screens/settings_screen.dart`** (NEW)
**UI Components:**
- Language settings:
  - Radio buttons: Korean, English
- Dietary preferences:
  - Update checkboxes (same as login)
- Allergy alerts:
  - Update checkboxes
- Dark mode toggle
- Notifications toggle (mock)
- About section:
  - App version
  - Privacy policy link
  - Terms of service link
- Contact/Feedback:
  - Email support button
  - Rate app button
- Clear cache button
- Logout button

#### 7. **`lib/screens/profile_screen.dart`** (UPDATE)
**UI Components:**
- User avatar and name
- Dietary preferences badges
- Statistics:
  - Total scans
  - Products saved
  - Last scan date
- Scan history section:
  - List of all scans with dates
  - Filter by date range
  - Search functionality
- Favorite products section:
  - Grid/list of saved products
  - Quick access to product details
- Account settings button → Navigate to SettingsScreen
- Delete account button (with confirmation)

---

### Phase 6: Data Layer

#### 1. **`lib/data/mock_products.dart`** (NEW)
Create 10-15 sample Korean products:
```dart
// Example products:
- Shin Ramyun (신라면) - Contains beef extract (not Halal/Vegan)
- Choco Pie (초코파이) - Contains gelatin (not Halal/Vegan)
- Banana Milk (바나나맛 우유) - Vegetarian, contains dairy
- Kimchi (김치) - Vegan (if no fish sauce)
- Seaweed Snack (김) - Vegan, allergen: may contain soy
```

Each product includes:
- Barcode number
- Korean name
- English name
- Brand
- Ingredient list (Korean)
- Ingredient list (English)
- Classifications
- Image URL (placeholder)

#### 2. **`lib/data/ingredient_database.dart`** (NEW)
Database of common ingredients with classifications:
```dart
// Examples:
- 젤라틴 (Gelatin): Not Halal, Not Vegan, Not Kosher
- 돼지고기 (Pork): Not Halal, Not Kosher
- 알코올 (Alcohol): Not Halal
- 우유 (Milk): Not Vegan, Allergen: Dairy
- 땅콩 (Peanuts): Allergen: Nuts
```

---

### Phase 7: Main App Update

**`lib/main.dart`** (UPDATE)
- Wrap MaterialApp with MultiProvider
- Add UserProvider and ScanProvider
- Initialize shared_preferences
- Update theme for dark mode support
- Ensure all routes are properly defined

---

## Dependent Files Summary

### Files to Create (17 new files):
1. `lib/models/product.dart`
2. `lib/models/ingredient.dart`
3. `lib/models/user_preferences.dart`
4. `lib/models/scan_history.dart`
5. `lib/services/database_service.dart`
6. `lib/services/ocr_service.dart`
7. `lib/services/ai_classification_service.dart`
8. `lib/providers/user_provider.dart`
9. `lib/providers/scan_provider.dart`
10. `lib/screens/login_screen.dart`
11. `lib/screens/results_screen.dart`
12. `lib/screens/ingredient_explanation_screen.dart`
13. `lib/screens/settings_screen.dart`
14. `lib/data/mock_products.dart`
15. `lib/data/ingredient_database.dart`
16. `TODO.md` ✅ (already created)
17. `IMPLEMENTATION_PLAN.md` (this file)

### Files to Update (4 files):
1. `pubspec.yaml` - Add dependencies
2. `lib/main.dart` - Add Provider setup
3. `lib/screens/home_screen.dart` - Complete rewrite for dashboard
4. `lib/screens/scan_screen.dart` - Update with service integration
5. `lib/screens/profile_screen.dart` - Update for new features

---

## Follow-up Steps

### After Implementation:
1. **Test barcode scanning** with real device (camera required)
2. **Test OCR** with Korean product labels
3. **Verify translation** accuracy
4. **Test classification** logic with various ingredients
5. **Check navigation** flow through all screens
6. **Test state persistence** (favorites, history, preferences)
7. **Verify UI/UX** on different screen sizes
8. **Add error handling** for network failures
9. **Optimize performance** (image processing, API calls)
10. **Prepare for real database** integration (document API endpoints needed)

### Future Enhancements:
- Real backend API integration
- User authentication (Firebase/Auth0)
- Cloud database for products
- Community contributions (user-submitted products)
- Barcode generation for custom products
- Nutrition facts display
- Recipe suggestions based on dietary preferences
- Multi-language support (beyond Korean/English)

---

## Notes
- All services use mock data initially
- Translation service requires Google API key (user to provide)
- OCR works offline with google_ml_kit
- State persists locally with shared_preferences
- Ready for backend integration (clear separation of concerns)
