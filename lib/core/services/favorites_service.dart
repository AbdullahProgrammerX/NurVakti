import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import 'device_service.dart';

enum ContentType {
  verse,
  hadith,
  risale,
  history,
  recipe;

  String get displayName {
    switch (this) {
      case ContentType.verse:
        return 'Ayetler';
      case ContentType.hadith:
        return 'Hadisler';
      case ContentType.risale:
        return 'Vecizeler';
      case ContentType.history:
        return 'Tarih';
      case ContentType.recipe:
        return 'Yemekler';
    }
  }
}

class FavoriteItem {
  final String id;
  final ContentType contentType;
  final String contentId;
  final Map<String, dynamic> contentData;
  final DateTime createdAt;

  const FavoriteItem({
    required this.id,
    required this.contentType,
    required this.contentId,
    required this.contentData,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] as String,
      contentType: ContentType.values.firstWhere(
            (e) => e.name == json['content_type'],
      ),
      contentId: json['content_id'] as String,
      contentData: json['content_data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class FavoritesService {
  final SupabaseClient _supabase;
  final String _deviceId;

  FavoritesService(this._supabase, this._deviceId);

  Future<List<FavoriteItem>> getFavorites({ContentType? type}) async {
    try {
      var query = _supabase
          .from('user_favorites')
          .select()
          .eq('device_id', _deviceId)
          .order('created_at', ascending: false);

      if (type != null) {
        query = query.eq('content_type', type.name);
      }

      final response = await query;

      return (response as List)
          .map((item) => FavoriteItem.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching favorites: $e');
      return [];
    }
  }

  Future<bool> isFavorite(ContentType type, String contentId) async {
    try {
      final response = await _supabase
          .from('user_favorites')
          .select('id')
          .eq('device_id', _deviceId)
          .eq('content_type', type.name)
          .eq('content_id', contentId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  Future<bool> addFavorite({
    required ContentType type,
    required String contentId,
    required Map<String, dynamic> contentData,
  }) async {
    try {
      await _supabase.from('user_favorites').insert({
        'device_id': _deviceId,
        'content_type': type.name,
        'content_id': contentId,
        'content_data': contentData,
      });
      return true;
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }

  Future<bool> removeFavorite(ContentType type, String contentId) async {
    try {
      await _supabase
          .from('user_favorites')
          .delete()
          .eq('device_id', _deviceId)
          .eq('content_type', type.name)
          .eq('content_id', contentId);
      return true;
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite({
    required ContentType type,
    required String contentId,
    required Map<String, dynamic> contentData,
  }) async {
    final isFav = await isFavorite(type, contentId);
    if (isFav) {
      return await removeFavorite(type, contentId);
    } else {
      return await addFavorite(
        type: type,
        contentId: contentId,
        contentData: contentData,
      );
    }
  }
}

final favoritesServiceProvider = FutureProvider<FavoritesService>((ref) async {
  final supabase = ref.watch(supabaseProvider);
  final deviceId = await ref.watch(deviceIdProvider.future);
  return FavoritesService(supabase, deviceId);
});

final favoritesProvider = FutureProvider.family<List<FavoriteItem>, ContentType?>((ref, type) async {
  final service = await ref.watch(favoritesServiceProvider.future);
  return service.getFavorites(type: type);
});

final isFavoriteProvider = FutureProvider.family<bool, (ContentType, String)>((ref, params) async {
  final service = await ref.watch(favoritesServiceProvider.future);
  final (type, contentId) = params;
  return service.isFavorite(type, contentId);
});
