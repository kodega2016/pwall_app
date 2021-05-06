import 'dart:io';
import 'package:wally/models/app_user.dart';
import 'package:wally/services/api_path.dart';
import 'firestorage_service.dart';
import 'firestore_service.dart';
import 'package:wally/models/wallpaper.dart';

abstract class Database {
  Future<void> saveUser(AppUser user);
  Future addWallpaper(Wallpaper wallpaper, File file);
  Stream<List<Wallpaper>> streamWallpapers({String uid});
  Future<void> deleteWallpaper(Wallpaper wallpaper);
}

class FirebaseDatabase implements Database {
  final _service = FirestoreService();
  final _storage = FirestorageService();

  Future<void> saveUser(AppUser user) async {
    await _service.setData(path: ApiPath.users(user.id), data: user.toMap());
  }

  Future addWallpaper(Wallpaper wallpaper, File file) async {
    final _url = await _storage.uploadFile(file);
    final _wallpaper = wallpaper.copyWith(url: _url);
    await _service.addData(
        path: ApiPath.wallpapers(), data: _wallpaper.toMap());
  }

  @override
  Stream<List<Wallpaper>> streamWallpapers({String uid}) {
    return _service.collectionStream(
      path: ApiPath.wallpapers(),
      builder: (data, id) => Wallpaper.fromMap(data, id),
      queryBuilder: uid != null
          ? (query) => query.where('uploadedBy', isEqualTo: uid)
          : null,
    );
  }

  @override
  Future<void> deleteWallpaper(Wallpaper wallpaper) async {
    await _storage.deleteFile(wallpaper.url);
    await _service.deleteData(path: ApiPath.wallpaper(wallpaper.id));
  }
}
