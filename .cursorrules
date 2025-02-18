# Baby Tracking App

## Project Management

Maintain a markdown file in instruction folder called `Tasks.md` that keeps track of things we need to do. We'll collaborate on this file and both add and remove items as we work on the project.

## Overview

I want to create a baby tracking app built in Flutter using Firebase for Authentication, Storage, and Realtime Sync. It will be an AI-first app, depending heavily on voice input. Users will use iOS AppIntents and the equivalent on Android to log things like feedings, nursing, medicine, sleep, etc.

### Core Dependencies

| Dependency | Purpose | Docs |
|------------|---------|------|
| **Flutter** | Mobile framework | [Docs](https://docs.flutter.dev/get-started/install) |
| **Firebase** | Auth, Database, Realtime Sync | [Docs](https://firebase.google.com/docs/flutter/setup?platform=ios) |
| **Cupertino Widgets** | UI Components | [Docs](https://docs.flutter.dev/ui/widgets/cupertino) |

## Database Models

### Kid

Represents a child being tracked.

| Field       | Type       | Description                  |
|------------|-----------|------------------------------|
| `id`       | UUID      | Primary key                  |
| `name`     | String    | Child's name                 |
| `dob`      | DateTime  | Date of birth                |
| `gender`   | String    | M, F, or Other               |
| `created_at` | DateTime  | Record creation timestamp  |
| `updated_at` | DateTime  | Last updated timestamp     |
| `account_id` | UUID      | Links to the parent's account |

### Log

Stores different baby activity logs (sleep, feeding, medicine, etc.).

| Field       | Type       | Description                               |
|------------|-----------|-------------------------------------------|
| `id`       | UUID      | Primary key                               |
| `type`     | ENUM      | `formula`, `sleep`, `medicine`, etc.      |
| `start_at` | DateTime  | Start time of the logged event           |
| `end_at`   | DateTime  | End time (for things like sleep)         |
| `amount`   | Decimal   | Used for formula oz/ml, medicine dosage  |
| `created_at` | DateTime  | Record creation timestamp               |
| `updated_at` | DateTime  | Last modified timestamp                 |
| `account_id` | UUID      | Links to the parent account              |
| `kid_id`   | UUID      | Links to the `Kid` model                 |

### Account

Groups all users and data under a single account.

| Field       | Type       | Description                  |
|------------|-----------|------------------------------|
| `id`       | UUID      | Primary key                  |
| `created_at` | DateTime  | Record creation timestamp  |
| `updated_at` | DateTime  | Last updated timestamp     |

### User

Represents an authenticated user.

| Field       | Type       | Description                              |
|------------|-----------|------------------------------------------|
| `id`       | UUID      | Firebase Auth UID                        |
| `account_id` | UUID      | Links to the `Account`                  |
| `email`    | String    | User's email address                     |
| `created_at` | DateTime  | Record creation timestamp              |

## Core Functionality (implement them in this order)

### 1. Project Setup & Environment Configuration

- Install dependencies (`expo`, `Firebase`, `gluestack`, etc.).
- Setup `.env` for API keys.
- Use `asdf` for managing runtime versions.

### 2. Authentication

- **Login** (email/password, Google SSO)
- **Logout**
- **Forgot Password** (via Firebase)
- **Magic Link Authentication** (optional)

### 3. Creating an Account

1. User signs up via Firebase Auth.
2. A new **Account** and **User** are created.
3. The user must create at least one **Kid**.
4. The first created kid is set as `current_kid_id` on the Account.

### 4. Dashboard

- **Card 1:** Summary stats (total sleep, feedings, medicine taken)
- **Card 2:** List of logged activities for today.
- **Navigation:** Users can paginate backward or forward by day.

### 5. Logging (CRUD)

- **Create, Edit, Delete logs** (sleep, formula, etc.).
- Form dynamically updates fields based on the selected `type` (e.g., Sleep logs require `end_at`).
- **Validation Rules:**
  - Sleep must be **at least 5 min**.
  - Formula intake **max 12oz** per session.

### 6. AI Logging

- **Press AI button** → Modal opens → Speech-to-Text starts.
- Live text preview as the user speaks.
- **“Stop” button** converts speech to structured data.
- OpenAI API processes voice input into logs.
- **Example AI Commands:**
  - “Oliver drank 5oz of formula.”
  - “Oliver slept from 4 to 4:30pm.”

### 7. Kids (Management)

- **CRUD operations for kids.**
- Pressig a kid row `current_kid_id`.

### 8. Notifications

- **Reminders** (e.g., “Time for medicine”).
- **Activity Alerts** (when another user logs something).
- **Daily Summary** (morning notification with the previous day’s stats).
- Uses **Firebase Messagging**
