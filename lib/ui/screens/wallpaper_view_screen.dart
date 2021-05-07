import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
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
                    onPressed: () async {
                      await launch(wallpaper.url);
                    },
                    label: Text('Download'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Ionicons.ios_bookmark_outline),
                    onPressed: () async => await onFav(),
                    label: Text('Favourite'),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Ionicons.ios_share_outline),
                    onPressed: () async {
                      final DynamicLinkParameters parameters =
                          DynamicLinkParameters(
                        uriPrefix: 'https://kodega.page.link',
                        link: Uri.parse(
                            'https://kodega.page.link/${wallpaper.id}'),
                        androidParameters: AndroidParameters(
                          packageName: 'com.kodega.wally',
                          minimumVersion: 0,
                        ),
                        socialMetaTagParameters: SocialMetaTagParameters(
                          title: 'PWall',
                          description: 'Wallpaper application',
                          imageUrl: Uri.parse(wallpaper.url),
                        ),
                      );

                      final Uri dynamicUrl = await parameters.buildUrl();

                      Share.share(dynamicUrl.toString());
                    },
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
