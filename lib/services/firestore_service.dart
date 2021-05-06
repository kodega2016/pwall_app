import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService<T> {
  static final FirestoreService _service = FirestoreService._();
  factory FirestoreService() => _service;
  FirestoreService._();

  final _firestore = FirebaseFirestore.instance;

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final _ref = _firestore.doc(path);
    await _ref.set(data, SetOptions(merge: true));
  }

  Future<void> addData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final _ref = _firestore.collection(path);
    await _ref.add(data);
  }

  Stream<List<T>> collectionStream<T>({
    String path,
    T builder(Map<String, dynamic> map, String id),
    Query queryBuilder(Query query),
  }) {
    Query _query = _firestore.collection(path);
    if (queryBuilder != null) {
      _query = queryBuilder(_query);
    }
    final _snaps = _query.snapshots();
    return _snaps.map(
        (event) => event.docs.map<T>((e) => builder(e.data(), e.id)).toList());
  }

  Future<void> deleteData({
    @required String path,
  }) async {
    final _ref = _firestore.doc(path);
    await _ref.delete();
  }
}
