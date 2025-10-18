# CleanBite App Implementation Plan

## Phase 1: Dependencies & Setup
- [ ] Add required packages to pubspec.yaml
  - barcode_scan2 (barcode scanning)
  - image_picker (camera/gallery access)
  - google_ml_kit (OCR functionality)
  - http (API calls for translation)
  - flutter_swiper_null_safety (onboarding slides)
  - provider (state management)
  - shared_preferences (local storage)

## Phase 2: Models
- [ ] Create lib/models/product.dart (product data model)
- [ ] Create lib/models/ingredient.dart (ingredient data model)
- [ ] Create lib/models/user_preferences.dart (user dietary preferences)
- [ ] Create lib/models/scan_history.dart (scan history model)

## Phase 3: Services
- [ ] Create lib/services/ocr_service.dart (OCR using google_ml_kit)
- [ ] Create lib/services/database_service.dart (mock database with sample products)
- [ ] Create lib/services/ai_classification_service.dart (dietary classification logic)
- [ ] Update lib/services/translation_service.dart (ensure it works properly)

## Phase 4: Screens Implementation
- [ ] Create lib/screens/login_screen.dart
  - Login options (Email/Google/Apple mock)
  - Profile setup form (name, dietary preferences, allergies)
  - Language selection (Korean/English)
  - Guest mode option
  
- [ ] Update lib/screens/home_screen.dart (Main Dashboard)
  - Search bar for manual product search
  - Floating Action Button (FAB) for scan
  - Recent scans list with dietary icons
  - Quick filter chips (Vegan, Halal, Kosher, etc.)
  - Profile icon navigation
  
- [ ] Update lib/screens/scan_screen.dart
  - Camera view with barcode frame
  - Real-time detection UI
  - Loading animation during processing
  - Manual input option
  - Integration with all services (database -> OCR -> translate -> classify)
  
- [ ] Create lib/screens/results_screen.dart
  - Product name and image display
  - Dietary classification badges (✅ Halal, ❌ Vegan, ⚠️ Contains nuts)
  - Short explanation text
  - Ingredient list with problematic ingredients highlighted
  - Save/Favorite/Report buttons
  - "See more details" link
  
- [ ] Create lib/screens/ingredient_explanation_screen.dart
  - Ingredient name and details
  - Dietary classifications
  - Reason/Reference for classification
  - Add to favorites option
  - Suggest correction button
  
- [ ] Create lib/screens/settings_screen.dart
  - Language settings toggle
  - Dietary preferences update
  - Dark mode toggle
  - Notifications settings
  - About/Contact/Feedback sections
  
- [ ] Update lib/screens/profile_screen.dart
  - User information display
  - Scan history overview
  - Favorite products list
  - Account settings (logout, delete account)

## Phase 5: State Management
- [ ] Create lib/providers/user_provider.dart (user preferences and auth state)
- [ ] Create lib/providers/scan_provider.dart (scan history and favorites)
- [ ] Update lib/main.dart to integrate Provider

## Phase 6: Data Layer
- [ ] Create lib/data/mock_products.dart (sample product database)
- [ ] Create lib/data/ingredient_database.dart (ingredient classifications)

## Phase 7: Testing & Polish
- [ ] Test navigation flow: Splash -> Login -> Home -> Scan -> Results
- [ ] Test barcode scanning functionality
- [ ] Test OCR and translation flow
- [ ] Test classification logic
- [ ] Verify UI/UX consistency across all screens
- [ ] Add loading states and error handling
- [ ] Test language switching

## Phase 8: Documentation
- [ ] Update README.md with project description and setup instructions
- [ ] Add comments to complex code sections
- [ ] Document API integration points for future real database connection
