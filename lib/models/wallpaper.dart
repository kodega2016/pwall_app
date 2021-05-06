class Wallpaper {
  final String id;
  final String url;
  final DateTime date;
  final List<String> tags;
  final String uploadedBy;

  Wallpaper({
    this.id,
    this.url,
    this.date,
    this.tags,
    this.uploadedBy,
  });

  factory Wallpaper.fromMap(Map<String, dynamic> map, String id) {
    return Wallpaper(
      id: id,
      date: map['date'].toDate(),
      tags: List<String>.from(map['tags']),
      uploadedBy: map['uploaded_by'],
      url: map['url'],
    );
  }
  Wallpaper copyWith({String url}) {
    return Wallpaper(
      id: this.id,
      date: this.date,
      tags: this.tags,
      uploadedBy: this.uploadedBy,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'tags': tags,
      'uploadedBy': uploadedBy,
      'url': url,
    };
  }
}
