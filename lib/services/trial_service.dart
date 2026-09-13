import 'package:shared_preferences/shared_preferences.dart';

class TrialService {
  static const String _startDateKey = 'llano_music_trial_start_date';

  static const int trialDays = 30;

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<void> initialize() async {
    final savedStartDate = await _preferences.getString(_startDateKey);

    if (savedStartDate == null) {
      await _preferences.setString(
        _startDateKey,
        DateTime.now()
            .subtract(const Duration(days: 31))
            .toIso8601String(),
      );
    }
  }

  Future<DateTime> getStartDate() async {
    final savedStartDate = await _preferences.getString(_startDateKey);

    if (savedStartDate == null) {
      final now = DateTime.now()
          .subtract(const Duration(days: 31));

      await _preferences.setString(
        _startDateKey,
        now.toIso8601String(),
      );

      return now;
    }

    return DateTime.parse(savedStartDate);
  }

  Future<DateTime> getExpirationDate() async {
    final startDate = await getStartDate();

    return startDate.add(
      const Duration(days: trialDays),
    );
  }

  Future<bool> isExpired() async {
    final expirationDate = await getExpirationDate();

    return !DateTime.now().isBefore(expirationDate);
  }

  Future<int> getDaysRemaining() async {
    final expirationDate = await getExpirationDate();

    final difference = expirationDate.difference(DateTime.now());

    if (difference.isNegative) {
      return 0;
    }

    return difference.inDays + 1;
  }
}

