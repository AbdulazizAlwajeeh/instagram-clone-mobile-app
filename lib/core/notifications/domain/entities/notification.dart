/// Core domain entity representing a system or push notification.
///
/// This class encapsulates the pure business data for a single notification entry,
/// keeping the domain layer decoupled from any database, Firebase, or Apple drivers.
class Notification {
  /// Unique identifier key for the notification record.
  final String id;

  /// The visual title string displayed on the system tray or alert banner.
  final String title;

  /// The literal textual content body of the notification message.
  final String body;

  /// Hidden metadata and contextual data parameters used for deep linking routing.
  ///
  /// Holds key-value payloads like chat IDs, post IDs, or sender tokens.
  final Map<String, dynamic> payload;

  /// Creates an immutable [Notification] domain entity instance.
  const Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
