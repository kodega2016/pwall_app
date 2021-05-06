import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:wally/models/wallpaper.dart';
import 'package:wally/ui/screens/wallpaper_view_screen.dart';

class WallpaperItem extends StatelessWidget {
  const WallpaperItem({
    Key key,
    @required this.wallpaper,
    this.onDelete,
  }) : super(key: key);

  final Wallpaper wallpaper;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return WallpaperViewScreen(
            wallpaper: wallpaper,
          );
        }));
      },
      child: Stack(
        children: [
          Hero(
            tag: wallpaper.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: wallpaper.url,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Image(
                  image: AssetImage('assets/placeholder.jpg'),
                ),
              ),
            ),
          ),
          if (onDelete != null)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () async => await onDelete(),
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Icon(Ionicons.ios_close_outline, color: Colors.red),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        offset: Offset(0, 0.3),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
