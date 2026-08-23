import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/favorite_bus.dart';
import '../services/favorites_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  List<FavoriteBus> _favorites = [];
  List<FavoriteBus> get favorites => _favorites;

  FavoriteProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _favoritesService.getUserFavorites(user.uid).listen((favorites) {
          _favorites = favorites;
          notifyListeners();
        });
      } else {
        _favorites = [];
        notifyListeners();
      }
    });
  }

  bool isFavorite(String busId) {
    return _favorites.any((bus) => bus.busId == busId);
  }

  Future<void> toggleFavorite(String busId, String source, String destination) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (isFavorite(busId)) {
      await _favoritesService.removeFavorite(user.uid, busId);
    } else {
      final favorite = FavoriteBus(
        busId: busId,
        source: source,
        destination: destination,
        addedAt: DateTime.now(),
      );
      await _favoritesService.addFavorite(user.uid, favorite);
    }
  }
}
