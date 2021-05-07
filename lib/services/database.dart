import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:wally/models/app_user.dart';
import 'package:wally/services/api_path.dart';
import 'firestorage_service.dart';
import 'firestore_service.dart';
import 'package:wally/models/wallpaper.dart';

abstract class Database {
  Future<void> saveUser(AppUser user);
  Stream<AppUser> streamUser(String id);
  Future addWallpaper(Wallpaper wallpaper, File file);
  Stream<List<Wallpaper>> streamWallpapers({String uid});
  Future<void> deleteWallpaper(Wallpaper wallpaper);
  Future<void> updateFavList(String uid, List<String> ids);
  Stream<List<Wallpaper>> streamFavs(List<String> ids);
}

class FirebaseDatabase implements Database {
  final _service = FirestoreService();
  final _storage = FirestorageService();

  Future<void> saveUser(AppUser user) async {
    await _service.setData(path: ApiPath.users(user.id), data: user.toMap());
  }

  Future addWallpaper(Wallpaper wallpaper, File file) async {
    final _url = await _storage.uploadFile(file, wallpaper.uploadedBy);
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
    try {
      await _storage.deleteFile(wallpaper.url);
    } catch (e) {
      print(e);
    }
    await _service.deleteData(path: ApiPath.wallpaper(wallpaper.id));
  }

  @override
  Future<void> updateFavList(String uid, List<String> ids) async {
    await _service.setData(path: 'users/$uid/favourites', data: {'ids': ids});
  }

  @override
  Stream<AppUser> streamUser(String id) {
    return _service.streamSingle(
        path: ApiPath.users(id),
        builder: (data, id) => AppUser.fromMap(data, id));
  }

  @override
  Stream<List<Wallpaper>> streamFavs(List<String> ids) {
    return Rx.combineLatest2(
      Stream.value(ids),
      streamWallpapers(),
      _combiner,
    );
  }

  List<Wallpaper> _combiner(List ids, List<Wallpaper> wallpapers) {
    return wallpapers
        .where((element) => ids.contains(element.id))
        .toSet()
        .toList();
  }
}
