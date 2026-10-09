import 'package:fpdart/fpdart.dart';
import '../../../error/failures.dart';

/// Abstract boundary definition responsible for handling application locale persistence operations.
///
/// Enforces decoupled implementation strategies for writing or reading user-selected language configurations
/// across local embedded key-value storage engines or remote runtime synced profiles.
abstract interface class LocaleRepository {
  /// Retrieves the cached language code string configuration from memory engines.
  ///
  /// Returns a functional [Either] layout yielding a localized [Failure] on the left channel,
  /// or a nullable [String] indicating the matching saved language layout key signature on the right channel.
  Either<Failure, String?> getCachedLanguageCode();

  /// Caches the explicit language code string parameter to persistent local memory layouts.
  ///
  /// Returns a functional [Either] layout yielding a localized [Failure] on the left channel,
  /// or a successful [Unit] token instance confirming complete operational clearance on the right channel.
  Future<Either<Failure, Unit>> cacheLanguageCode(String languageCode);
}
