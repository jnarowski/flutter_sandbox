# Baby Tracking App - TODO List

## Core Features

### Authentication

- [x] Email/Password Login
- [x] User Registration
- [x] Password Reset
- [ ] Magic Link Authentication
- [ ] Google SSO

### Account Setup (first time user)

Once a user has signed up, we need to setup their account with the following steps:

- [ ] Create a new account
  - [ ] Create a user and connect it to uid of firebase auth user
  - [ ] Create a new account
  - [ ] Add accountId to the user
- [ ] Create a new kid, set this as the current kid on the account and redirect them to the dashboard

Note this must be done before they can do anything in the app

### Logging

- [x] Basic CRUD Operations
- [x] Form Validation
- [x] Dynamic Fields Based on Type

### Log Types

- [x] Nursing
- [x] Bottle Feeding
- [x] Medicine
- [x] Sleep
- [x] Solids
- [x] Bathroom
- [x] Pumping
- [x] Activity
- [x] Growth

### UI/UX

- [x] Log Type Icons
- [x] Formatted Log Display
- [ ] Group Logs by Date
- [ ] Pull to Refresh
- [ ] Infinite Scroll
- [ ] Search/Filter Logs

### User Preferences

- Use the `account_screen.dart` screen as an entry point for these settings.
- Implement a specific widget for settings and keep `account_screen.dart` clean.
- User settings will be added to the users collection in Firebase using the `user_servic.dart` in `lib/features/users/user_service.dart`
- For app specific settings, they will be added to the app_provider in `lib/core/providers/app_provider.dart`.

- [ ] Default Units
  - [ ] Feeding (oz/ml)
  - [ ] Medicine (ml/oz)
  - [ ] Growth (in/cm, lb/kg)
- [ ] Time Format (12/24h)
- [ ] Add these defaults to the log form where appropriate.

### Analytics

- [ ] Daily Summary
- [ ] Weekly Trends
- [ ] Growth Charts
- [ ] Feeding Patterns
- [ ] Sleep Analysis

### Multi-user Support

- [ ] Share Account
- [ ] User Roles
- [ ] Activity History
- [ ] Real-time Updates

### AI Features

- [ ] Voice Input
- [ ] Natural Language Processing
- [ ] Smart Suggestions
- [ ] Pattern Recognition

### Notifications

- [ ] Medicine Reminders
- [ ] Feeding Alerts
- [ ] Sleep Schedule
- [ ] Growth Checkpoints
- [ ] Daily Summaries

## Technical Debt

### Testing

- [ ] Unit Tests
- [ ] Widget Tests
- [ ] Integration Tests
- [ ] E2E Tests

### Performance

- [ ] Caching
- [ ] Offline Support
- [ ] Image Optimization
- [ ] Query Optimization

### Security

- [ ] Data Encryption
- [ ] Input Sanitization
- [ ] Rate Limiting
- [ ] Audit Logging

### Documentation

- [ ] API Documentation
- [ ] User Guide
- [ ] Developer Setup
- [ ] Architecture Overview