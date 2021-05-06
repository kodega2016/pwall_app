import 'package:firebase_core/firebase_core.dart';
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

class WallyApp extends StatelessWidget {
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
                      db.saveUser(snap.data);
                      return Provider<AppUser>.value(
                        value: snap.data,
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
