# InstaClone (Clean Architecture)

A mobile production-grade application built with Flutter and Supabase, designed for high scalability, testability, and performance.

---

## 🚀 Core Features
* **Authentication:** Secure sign-up, sign-in, and session management via Supabase Auth.
* **Real-time Interactions:** Instant updates for chats, feeds, likes, comments, and user activities.
* **Media Handling:** High-performance image uploads and distribution backed by Supabase Storage.
* **Push Notifications:** Target-driven cloud messaging powered by Firebase Cloud Messaging (FCM).
* **Security First:** Database integrity enforced via PostgreSQL Triggers and custom Row-Level Security (RLS) policies.

---

## 🏗️ Architectural Patterns

The project strictly adheres to **Clean Architecture** principles decoupled into highly isolated layers. Combined with a **Feature-Based Structure**, this ensures that adding new capabilities does not break existing code.

### Layer Responsibilities
* **Data Layer:** Handles raw database interactions, network requests, and external APIs. Converts raw JSON schemas into internal Data Models.
* **Domain Layer:** The pure, completely isolated core of the application. Contains business logic entities and use cases. It has no dependencies on Flutter, databases, or UI.
* **Presentation Layer:** Manages user UI execution. Consumes business events and reactively builds the view state.

---

## 🛠️ Tech Stack & Dependencies

* **UI Framework:** [Flutter] - Cross-platform mobile development.
* **Backend-as-a-Service:** [Supabase] - PostgreSQL database, Authentication, and Storage.
* **State Management:** [BLoC (Business Logic Component)] - Predictable state changes via events and states.
* **Dependency Injection:** [GetIt] - Fast Service Locator for decoupling dependencies and facilitating mock injections.
* **Routing & Navigation:** [GoRouter] - Declarative routing with deep-linking capability.
* **Push Notifications:** [Firebase Cloud Messaging (FCM)] - Low-latency remote push capabilities.
* **Unit & Unit Mock Testing:** [Mocktail] - Null-safe mocking library to validate use cases and BLoC components.
* **Functional Error Handling:** Implements the `Either` class pattern across all repositories to enforce compile-time type safety over runtime exceptions.
* **Code Documentation:** Fully documented public APIs, classes, and use cases to maximize project maintainability and clean onboarding.

---

## 🧪 Testing Strategy

Robust test coverage is critical to this project's production-grade claim. Utilizing **Mocktail**, the test suite isolates dependencies cleanly:
* **Domain Logic Validation:** Use cases are verified under isolated parameters.
* **BLoC State Streams:** Events are injected to assert precise chronological State emissions.
* **Boundary Defenses:** Failures and exceptions originating from the Data layer are mocked to ensure UI-layer graceful failure handling.
* **Widget UI Testing:** Component interactions are pumped to assert look-and-feel behavior and verify that appropriate BLoC events trigger on user input.