import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:wally/models/app_user.dart';
import 'package:wally/models/wallpaper.dart';
import 'package:wally/services/auth.dart';
import 'package:wally/services/database.dart';
import 'package:wally/ui/screens/wallpaper_form_screen.dart';
import 'package:wally/ui/widgets/wallpaper_item.dart';

class ProfileScreen extends StatelessWidget {
  static var favourites = [
    "https://images.pexels.com/photos/775483/pexels-photo-775483.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3326103/pexels-photo-3326103.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/1927314/pexels-photo-1927314.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    "https://images.pexels.com/photos/2085376/pexels-photo-2085376.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3377538/pexels-photo-3377538.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3381028/pexels-photo-3381028.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/3389722/pexels-photo-3389722.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
  ];
  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    final _user = context.watch<AppUser>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Ionicons.ios_log_out_outline),
            onPressed: () async {
              final _isLoggedOut = await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                        title: Text('Are you sure to logout?'),
                        content: Text('You will be logout from the system.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('No')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Yes')),
                        ],
                      ) ??
                      false;
                },
              );

              if (_isLoggedOut) await context.read<BaseAuth>().signOut();
            },
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 24),
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: _user.photoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/placeholder.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          width: 2.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '${_user.displayName}',
                  textAlign: TextAlign.center,
                  style: _textTheme.subtitle1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${_user.email}',
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Up-loads",
                          style: _textTheme.subtitle1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Ionicons.ios_add_circle_outline),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) {
                                return WallpaperFormScreen(
                                  db: context.read<Database>(),
                                  uid: _user.id,
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<List<Wallpaper>>(
                      stream: context
                          .read<Database>()
                          .streamWallpapers(uid: _user.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final _wallpapers = snapshot.data;
                          if (_wallpapers.isEmpty)
                            return Center(
                              child: Text('No wallpapers uploaded yet.'),
                            );

                          return StaggeredGridView.countBuilder(
                            staggeredTileBuilder: (int i) =>
                                StaggeredTile.fit(1),
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            shrinkWrap: true,
                            primary: false,
                            crossAxisSpacing: 20,
                            itemCount: _wallpapers.length,
                            itemBuilder: (context, i) {
                              return WallpaperItem(
                                wallpaper: _wallpapers[i],
                                onDelete: () async {
                                  try {
                                    await context
                                        .read<Database>()
                                        .deleteWallpaper(_wallpapers[i]);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              );
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
