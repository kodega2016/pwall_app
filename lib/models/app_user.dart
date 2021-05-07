class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final DateTime lastSignIn;
  final List<String> favourites;

  AppUser({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.lastSignIn,
    this.favourites = const [],
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      displayName: map['displayName'],
      email: map['email'],
      lastSignIn: map['last_signin'].toDate(),
      photoUrl: map['photo_url'],
      favourites: List<String>.from(map['favourites']) ?? [],
    );
  }

  AppUser copyWith({List favourites}) {
    return AppUser(
      id: this.id,
      displayName: this.displayName,
      email: this.email,
      favourites: favourites ?? this.favourites,
      lastSignIn: this.lastSignIn,
      photoUrl: this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photo_url': photoUrl,
      'last_signin': lastSignIn,
      'favourites': favourites,
    };
  }
}
