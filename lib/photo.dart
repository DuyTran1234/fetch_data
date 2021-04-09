class PhotoAlbum {
  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;
  PhotoAlbum(
      {required this.albumId,
      required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});
  factory PhotoAlbum.fromJson(Map<String, dynamic> json) {
    return PhotoAlbum(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }
}
