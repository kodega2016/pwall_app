import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wally/services/database.dart';
import 'package:wally/models/wallpaper.dart';

class WallpaperFormScreen extends StatefulWidget {
  final Database db;
  final String uid;

  const WallpaperFormScreen({
    Key key,
    this.db,
    this.uid,
  }) : super(key: key);

  @override
  _WallpaperFormScreenState createState() => _WallpaperFormScreenState();
}

class _WallpaperFormScreenState extends State<WallpaperFormScreen> {
  File _image;
  final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
  List<ImageLabel> _detectedLabels;
  bool _isLoading = false;

  @override
  void dispose() {
    labeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wallpaper'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading) LinearProgressIndicator(),
            Center(
              child: InkWell(
                onTap: () async => await _pickImage(),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey[300]),
                  ),
                  child: _image == null
                      ? Icon(Ionicons.ios_camera_outline, size: 60)
                      : Image.file(_image, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_detectedLabels != null)
              Wrap(
                spacing: 6,
                children: [
                  ..._detectedLabels.map((e) {
                    return Chip(label: Text(e.text));
                  }).toList(),
                ],
              ),
            SizedBox(
              height: 45.0,
              child: ElevatedButton(
                onPressed: _image == null || _isLoading
                    ? () {}
                    : () async => await _save(),
                child: Text('Save'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final _picker = ImagePicker();
    final _pimage = await _picker.getImage(source: ImageSource.gallery);

    if (_pimage != null) {
      _image = File(_pimage.path);
      final FirebaseVisionImage _fbImage = FirebaseVisionImage.fromFile(_image);

      List<ImageLabel> labels = await labeler.processImage(_fbImage);
      _detectedLabels = labels;

      setState(() {});
    }
  }

  _save() async {
    try {
      _isLoading = true;
      setState(() {});
      final _wallpaper = Wallpaper(
        date: DateTime.now(),
        tags: _detectedLabels.map((e) => e.text).toList(),
        uploadedBy: widget.uid,
      );
      _isLoading = true;
      setState(() {});
      await widget.db.addWallpaper(_wallpaper, _image);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
      ));
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }
}
