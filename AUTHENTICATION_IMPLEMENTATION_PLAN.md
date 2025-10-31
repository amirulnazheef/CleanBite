# Authentication & Profile System Implementation Plan

## Overview
Implement a complete authentication system with local database storage for user credentials, profile management, and personalized dietary preferences.

## Current State Analysis

### Existing Components
✅ `lib/models/user_preferences.dart` - User preferences model
✅ `lib/providers/user_provider.dart` - User state management
✅ `shared_preferences` package - Already in pubspec.yaml
✅ Login and Signup screens - UI implemented

### Missing Components
❌ User credential storage (email/password)
❌ Authentication service
❌ User model (separate from preferences)
❌ Edit profile screen
❌ Dietary preferences management screen
❌ Allergen alerts management screen
❌ Integration with login/signup flows
❌ Profile display with user info

## Implementation Steps

### Phase 1: Database & Models

#### 1.1 Create User Model (`lib/models/user.dart`)
```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final DateTime createdAt;
  
  // Methods: toJson, fromJson, copyWith
}
```

#### 1.2 Create Authentication Service (`lib/services/auth_service.dart`)
- Store/retrieve user credentials securely
- Hash passwords (using crypto package)
- Validate login credentials
- Register new users
- Check if email exists
- Clear all data (for testing)

#### 1.3 Update User Provider (`lib/providers/user_provider.dart`)
- Add current user state
- Add authentication methods
- Link with auth service
- Manage user session

### Phase 2: Authentication Flow

#### 2.1 Update Signup Screen
- Integrate with auth service
- Save user credentials
- Create user profile
- Initialize preferences
- Navigate to profile setup or home

#### 2.2 Update Login Screen
- Validate credentials against stored data
- Load user profile on success
- Show error messages for invalid credentials
- Handle "Remember me" functionality

#### 2.3 Update Splash Screen
- Check if user is logged in
- Auto-navigate to home if logged in
- Navigate to onboarding if first time

### Phase 3: Profile Management

#### 3.1 Create Edit Profile Screen (`lib/screens/edit_profile_screen.dart`)
- Edit name
- Edit email
- Change password
- Upload/change profile picture (optional)
- Save changes

#### 3.2 Update Profile Screen (`lib/screens/profile_screen.dart`)
- Display current user info (name, email)
- Show profile picture
- Display stats (scans, favorites)
- Add "Edit Profile" button
- Show dietary preferences summary
- Show allergen alerts summary

#### 3.3 Create Dietary Preferences Screen (`lib/screens/dietary_preferences_screen.dart`)
- Checkboxes for: Halal, Vegan, Vegetarian, Kosher, Gluten-Free, etc.
- Save preferences
- Update user provider

#### 3.4 Create Allergen Alerts Screen (`lib/screens/allergen_alerts_screen.dart`)
- Checkboxes for common allergens: Nuts, Dairy, Eggs, Soy, Wheat, Fish, Shellfish, etc.
- Save allergen list
- Update user provider

### Phase 4: Integration

#### 4.1 Update Main App (`lib/main.dart`)
- Wrap with Provider (ChangeNotifierProvider)
- Initialize UserProvider on app start
- Add new routes

#### 4.2 Update Navigation
- Add route guards (check if logged in)
- Redirect to login if not authenticated
- Handle logout flow

#### 4.3 Update Home Screen
- Display personalized greeting with user name
- Show dietary preferences chips
- Filter content based on preferences

## Database Schema (SharedPreferences)

### Keys:
1. `users_db` - JSON string of all users (Map<String, User>)
2. `current_user_id` - String of logged-in user ID
3. `user_preferences_{userId}` - JSON string of user preferences
4. `is_logged_in` - Boolean
5. `remember_me` - Boolean

### User Storage Structure:
```json
{
  "users_db": {
    "user_id_1": {
      "id": "user_id_1",
      "email": "user@example.com",
      "passwordHash": "hashed_password",
      "name": "John Doe",
      "profileImage": null,
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  },
  "current_user_id": "user_id_1",
  "user_preferences_user_id_1": {
    "name": "John Doe",
    "language": "en",
    "dietaryRestrictions": ["halal", "vegan"],
    "allergens": ["nuts", "dairy"],
    "darkMode": false,
    "notifications": true
  },
  "is_logged_in": true
}
```

## Security Considerations

1. **Password Hashing**: Use `crypto` package to hash passwords
2. **No Plain Text**: Never store passwords in plain text
3. **Validation**: Validate email format and password strength
4. **Session Management**: Clear sensitive data on logout
5. **Local Storage Only**: This is a local app, no backend API

## Dependencies to Add

```yaml
dependencies:
  crypto: ^3.0.3  # For password hashing
  uuid: ^4.0.0    # For generating user IDs
```

## Testing Checklist

- [ ] Sign up with new account
- [ ] Login with correct credentials
- [ ] Login fails with wrong credentials
- [ ] Email validation works
- [ ] Password strength validation works
- [ ] User profile displays correctly
- [ ] Edit profile updates data
- [ ] Dietary preferences save correctly
- [ ] Allergen alerts save correctly
- [ ] Logout clears session
- [ ] Auto-login works on app restart
- [ ] Multiple users can be created
- [ ] Each user has separate preferences
- [ ] Profile data persists after app restart

## Files to Create/Modify

### New Files:
1. `lib/models/user.dart`
2. `lib/services/auth_service.dart`
3. `lib/screens/edit_profile_screen.dart`
4. `lib/screens/dietary_preferences_screen.dart`
5. `lib/screens/allergen_alerts_screen.dart`

### Modified Files:
1. `lib/main.dart` - Add Provider
2. `lib/providers/user_provider.dart` - Add auth methods
3. `lib/screens/login_screen.dart` - Integrate auth
4. `lib/screens/signup_screen.dart` - Integrate auth
5. `lib/screens/profile_screen.dart` - Display user info
6. `lib/screens/splash_screen.dart` - Check login status
7. `pubspec.yaml` - Add dependencies

## Implementation Order

1. ✅ Create plan (this document)
2. Add dependencies to pubspec.yaml
3. Create User model
4. Create AuthService
5. Update UserProvider
6. Update Signup screen
7. Update Login screen
8. Update Splash screen
9. Create Edit Profile screen
10. Create Dietary Preferences screen
11. Create Allergen Alerts screen
12. Update Profile screen
13. Update Main app with Provider
14. Test complete flow
15. Document changes

---

**Status**: 📋 Planning Complete - Ready for Implementation
**Estimated Time**: 2-3 hours
**Priority**: High
