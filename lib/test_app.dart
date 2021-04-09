import 'dart:convert';

import 'package:fetch_data/photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestApp extends StatefulWidget {
  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  late Future<List<PhotoAlbum>> _futurePhotos;
  List<PhotoAlbum> _photos = [];
  @override
  void initState() {
    super.initState();
    _futurePhotos = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Photos'),
        ),
        body: FutureBuilder<List<PhotoAlbum>>(
          future: _futurePhotos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _photos = snapshot.data!.map<PhotoAlbum>((e) => e).toList();
              return ListPhoto(photos: _photos);
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<List<PhotoAlbum>> fetchPhotos() async {
    final response = await http
        .get(Uri.https('jsonplaceholder.typicode.com', 'albums/1/photos'));
    if (response.statusCode == 200) {
      return parsedPhotoAlbum(response.body);
    } else {
      throw Exception('Failed load photos');
    }
  }

  List<PhotoAlbum> parsedPhotoAlbum(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<PhotoAlbum>((json) => PhotoAlbum.fromJson(json)).toList();
  }
}

class ListPhoto extends StatelessWidget {
  List<PhotoAlbum> photos = [];
  ListPhoto({required this.photos});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Photo ${photos[index].id}'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPhoto(photo: photos[index])));
            },
          );
        },
        itemCount: photos.length,
      ),
    );
  }
}

class DetailPhoto extends StatelessWidget {
  PhotoAlbum photo;
  DetailPhoto({required this.photo});
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text('Album ID:\t${photo.albumId}'),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text('ID:\t${photo.id}'),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text('Title:\t${photo.title}'),
              Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              Text('Image: '),
              Image.network('${photo.url}'),
            ],
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
