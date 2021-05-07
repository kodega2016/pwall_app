import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:wally/models/wallpaper.dart';

class WallpaperViewScreen extends StatelessWidget {
  final Wallpaper wallpaper;
  final Function onFav;

  WallpaperViewScreen({
    this.wallpaper,
    this.onFav,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: wallpaper.id,
                    child: CachedNetworkImage(
                      imageUrl: wallpaper.url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (ctx, url) => Image(
                        image: AssetImage('assets/placeholder.jpg'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Icon(
                        Ionicons.ios_close_outline,
                        color: Colors.white,
                      ),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: [
                  ...wallpaper.tags.map((e) {
                    return Chip(label: Text(e));
                  }).toList(),
                ],
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Ionicons.ios_download_outline),
                    onPressed: () {},
                    label: Text('Download'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Ionicons.ios_bookmark_outline),
                    onPressed: () async => await onFav(),
                    label: Text('Favourite'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Ionicons.ios_share_outline),
                    onPressed: () {},
                    label: Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
