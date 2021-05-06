import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavouriteScreen extends StatelessWidget {
  static var favourites = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StaggeredGridView.countBuilder(
          staggeredTileBuilder: (int i) => StaggeredTile.fit(1),
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          itemCount: favourites.length,
          itemBuilder: (context, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: favourites[i],
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Image(
                  image: AssetImage('assets/placeholder.jpg'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
