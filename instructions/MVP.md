# MVP - Launch Tasks

## Phase 1

### User Settings

The user will be able to store settings like default unit of measurement and time formatting.

- [ ] Implement user settings and form defaults`
  - [ ] It will be stored in the user document in firebase.
  - [ ] The user settings will be accessible in the account_screen.
  - [ ] Once the user saves the settings, it will update the appProvider
  - [ ] The user date default settings will be used to format dates across the app  
  - [ ] The user default units will populate defaults in the log forms
- [ ] Store user's timezone

### UI/UX

- [ ] Redesign all screens, especially forms to conform to `instructions/DesignSystem.md`
- [ ] Implement design theme and colors
- [ ] Generate logo

### Logging

- [ ] Log userId for all events
- [ ] Polish all forms within log forms
- [ ] Add convenience methods for date picker `lib/features/logs/widgets/shared/date_time_picker.dart` (now, 5 mins ago, 10 mins ago etc)

### AI Features

- [ ] Make `llm_logging_service` fault tolerant. Add fallbacks and error handling
- [ ] Implement `llm_logging_service` with AppIntents to run in background and add listener
- [ ] Add tests for `llm_logging_service` with 'llm_service' mocked

### Test and Package

- [ ] Ensure voice to text works on iOS and Android
- [ ] Prepare iOS app store for release
- [ ] Prepare Android for release
- [ ] Submit app to Test Flight

### Release

- [ ] Write description and upload screenshots
- [ ] Create iOS and Android app store listings
- [ ] Release to app stores

## Phase 2

### General
- [ ] Deep linking invite process
- [ ] Implement CI/CD
