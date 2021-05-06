class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final DateTime lastSignIn;

  AppUser({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.lastSignIn,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      displayName: map['display_name'],
      email: map['email'],
      lastSignIn: map['last_signin'],
      photoUrl: map['photo_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photo_url': photoUrl,
      'last_signin': lastSignIn,
    };
  }
}
