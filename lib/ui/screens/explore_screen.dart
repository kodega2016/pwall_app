import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wally/models/wallpaper.dart';
import 'package:wally/services/database.dart';
import 'package:wally/ui/widgets/wallpaper_item.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Explore')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: StreamBuilder<List<Wallpaper>>(
          stream: context.read<Database>().streamWallpapers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final _wallpapers = snapshot.data;
              if (_wallpapers.isEmpty)
                return Center(
                  child: Text('No wallpapers found.'),
                );
              return StaggeredGridView.countBuilder(
                staggeredTileBuilder: (int i) => StaggeredTile.fit(1),
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                itemCount: _wallpapers.length,
                itemBuilder: (context, i) {
                  return WallpaperItem(wallpaper: _wallpapers[i]);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
