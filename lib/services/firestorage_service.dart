import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirestorageService {
  static final FirestorageService _firestorageService = FirestorageService._();
  FirestorageService._();
  factory FirestorageService() => _firestorageService;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    final _result =
        await _storage.ref().child('wallpapers').child('a').putFile(file);
    final _url = await _result.ref.getDownloadURL();
    return _url;
  }

  Future<void> deleteFile(String url) async {
    await _storage.refFromURL(url).delete();
  }
}
