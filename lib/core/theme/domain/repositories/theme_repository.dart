import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';

/// Abstract boundary definition responsible for handling app theme persistence operations.
///
/// Enforces decoupled implementation strategies for writing or reading user-selected theme configurations
/// across local embedded key-value storage engines or remote runtime synced profiles.
abstract interface class ThemeRepository {
  /// Retrieves the cached theme mode string configuration from memory engines.
  ///
  /// Returns a functional [Either] layout yielding a localized [Failure] on the left channel,
  /// or a nullable [String] indicating the matching saved layout mode key signature on the right channel.
  Either<Failure, String?> getThemeMode();

  /// Caches the explicit theme mode string parameter to persistent local memory layouts.
  ///
  /// Returns a functional [Either] layout yielding a localized [Failure] on the left channel,
  /// or a successful [Unit] token instance confirming complete operational clearance on the right channel.
  Future<Either<Failure, Unit>> cacheThemeMode(String themeMode);
}
