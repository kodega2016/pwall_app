import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wally/appcolors.dart';
import 'package:wally/models/app_user.dart';
import 'package:wally/services/auth.dart';
import 'package:wally/ui/screens/home_screen.dart';
import 'package:wally/ui/screens/login_screen.dart';

import 'services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WallyApp());
}

class WallyApp extends StatefulWidget {
  @override
  _WallyAppState createState() => _WallyAppState();
}

class _WallyAppState extends State<WallyApp> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        Navigator.pushNamed(context, deepLink.path);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseAuth>(create: (ctx) => Auth()),
        Provider<Database>(create: (ctx) => FirebaseDatabase()),
      ],
      child: MaterialApp(
        title: 'Wally',
        theme: ThemeData(
          fontFamily: GoogleFonts.baumans().fontFamily,
          primaryColor: primaryColor,
        ),
        home: Consumer<BaseAuth>(
          builder: (context, noty, _) {
            return StreamBuilder<AppUser>(
              stream: noty.authStateChanges,
              builder: (context, snap) {
                if (snap.hasData) {
                  return Consumer<Database>(
                    builder: (ctx, db, _) {
                      return StreamProvider<AppUser>.value(
                        // initialData: AppUser(
                        //   id: snap.data.id,
                        //   displayName: snap.data.displayName,
                        // ),
                        initialData: null,
                        catchError: (e, s) {
                          print(e);
                          print(s);
                          return;
                        },
                        value: db.streamUser(snap.data.id),
                        child: HomeScreen(),
                      );
                    },
                  );
                }
                return LoginScreen();
              },
            );
          },
        ),
      ),
    );
  }
}
