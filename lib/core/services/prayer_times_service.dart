import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/prayer_time_model.dart';
import 'supabase_service.dart';

class PrayerTimesService {
  final SupabaseClient _supabase;

  PrayerTimesService(this._supabase);

  Future<PrayerTimeModel?> getPrayerTimes({
    required String city,
    required String district,
    required DateTime date,
  }) async {
    try {
      final dateStr = _formatDate(date);

      final response = await _supabase
          .from('prayer_times')
          .select()
          .eq('city', city)
          .eq('district', district)
          .eq('date', dateStr)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return PrayerTimeModel(
        city: response['city'] as String,
        district: response['district'] as String,
        date: DateTime.parse(response['date'] as String),
        times: PrayerTimesModel.fromJson(response['times'] as Map<String, dynamic>),
      );
    } catch (e) {
      print('Error fetching prayer times: $e');
      return null;
    }
  }

  Future<List<PrayerTimeModel>> getPrayerTimesRange({
    required String city,
    required String district,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final startStr = _formatDate(startDate);
      final endStr = _formatDate(endDate);

      final response = await _supabase
          .from('prayer_times')
          .select()
          .eq('city', city)
          .eq('district', district)
          .gte('date', startStr)
          .lte('date', endStr)
          .order('date');

      return (response as List)
          .map((item) => PrayerTimeModel(
        city: item['city'] as String,
        district: item['district'] as String,
        date: DateTime.parse(item['date'] as String),
        times: PrayerTimesModel.fromJson(item['times'] as Map<String, dynamic>),
      ))
          .toList();
    } catch (e) {
      print('Error fetching prayer times range: $e');
      return [];
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

final prayerTimesServiceProvider = Provider<PrayerTimesService>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return PrayerTimesService(supabase);
});

final currentPrayerTimesProvider = FutureProvider.family<PrayerTimeModel?, (String, String, DateTime)>(
      (ref, params) async {
    final service = ref.watch(prayerTimesServiceProvider);
    final (city, district, date) = params;
    return service.getPrayerTimes(
      city: city,
      district: district,
      date: date,
    );
  },
);
