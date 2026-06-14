# The ALU Connect

A Flutter application that connects African Leadership University (ALU) students and staff to campus opportunities — events, hackathons, clubs, internships, workshops, and more.

---

## Features

### Authentication
- **Sign Up** — any email registers as a student; `@alueducation.com` email automatically registers as staff
- **Login** — email + password; automatically routes to the correct experience based on role
- **Logout** — available from the profile screen
- Sessions are persisted locally using `shared_preferences`

### Student Features
- Browse a live feed of approved opportunities (events, hackathons, clubs, internships, workshops)
- Search and filter opportunities by category
- RSVP / Register for any opportunity with a full registration form
- Get a digital ticket with a QR code after registering
- Cancel RSVP at any time
- Post new opportunities — submitted posts go to staff for approval before appearing on the feed
- Track post statuses (approved, pending, rejected) from the profile screen
- Community chat rooms with reactions and reply support
- Notifications screen
- Profile screen showing registration count and post stats

### Staff Features
- Dedicated staff dashboard showing all pending student-submitted posts
- Approve posts — instantly publishes them to the student feed
- Reject posts — with an optional rejection note
- Profile screen with logout

---

## Role System

| Role | Email Required | Access |
|------|---------------|--------|
| Student | Any valid email | Feed, RSVP, Post, Chat, Profile |
| Staff | `@alueducation.com` only | Staff Dashboard, Approve/Reject Posts, Profile |

> Role is automatically determined by the email used during signup — no manual selection needed.

---

## Project Structure

```
lib/
├── main.dart                        # App entry point, service initialization
├── screens/
│   ├── onboarding_screen.dart       # Welcome screen with Login / Create Account
│   ├── login_screen.dart            # Login form with role-based routing
│   ├── signup_screen.dart           # Signup form with auto role detection
│   ├── main_screen.dart             # Bottom nav shell for student screens
│   ├── home_screen.dart             # Wrapper for home feed
│   ├── home_feed_screen.dart        # Opportunity feed with search & filter
│   ├── event_details_screen.dart    # Opportunity detail view
│   ├── rsvp_registration_screen.dart# RSVP form + digital ticket
│   ├── my_events_screen.dart        # Student's registered events & passes
│   ├── post_opportunity_screen.dart # Form to submit a new opportunity
│   ├── staff_dashboard_screen.dart  # Staff approval dashboard
│   ├── chat_list_screen.dart        # Community chat rooms list
│   ├── chat_screen.dart             # Individual chat room with reactions & replies
│   ├── notifications_screen.dart    # Notifications list
│   └── profile_screen.dart         # User profile with stats & logout
└── services/
    ├── auth_service.dart            # User auth, sessions, role detection
    ├── post_service.dart            # Opportunity posts with approval workflow
    ├── rsvp_service.dart            # RSVP registrations & persistence
    └── mock_data.dart               # Seed opportunities data
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.11.5 or higher)
- Dart SDK `^3.11.5`
- Android Studio / VS Code with Flutter extension

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/EstherShimwa/alu-connect.git
   cd alu-connect
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # Chrome (web)
   flutter run -d chrome

   # Windows desktop
   flutter run -d windows

   # Android (requires emulator or physical device)
   flutter run -d android
   ```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | UI framework |
| `shared_preferences` | ^2.2.0 | Local data persistence |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

---

## How It Works

### Posting an Opportunity (Student)
1. Tap the **+ Post** button on the home feed
2. Fill in the opportunity details (title, category, date, location, description)
3. Submit — post goes into **Pending** status
4. A staff member reviews and approves or rejects it
5. Once approved, the post appears on the feed for all students

### Approving a Post (Staff)
1. Login with an `@alueducation.com` account
2. Staff dashboard shows all pending posts
3. Tap **Approve** to publish or **Reject** to decline with an optional note

### RSVP Flow (Student)
1. Tap any opportunity on the feed
2. Tap **RSVP / Register Now**
3. Fill in name, email, cohort, t-shirt size, shuttle request
4. Submit — a digital ticket with QR code is generated
5. View ticket anytime from **My Events** tab

---

## Screenshots

> _Coming soon_

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add your feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## Team

Built by ALU students as a campus community platform.

---

## License

This project is for educational purposes at the African Leadership University.
