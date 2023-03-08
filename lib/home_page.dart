import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/globals.dart';
import 'package:music_app/theme_cubit.dart';

class NasaImage extends StatefulWidget {
  @override
  _NasaImageState createState() => _NasaImageState();
}

class _NasaImageState extends State<NasaImage> {
  String _selectedDate = '1995-06-16';
  String? _imageUrl;
  String _title = "";
  String _description="";
  String _apiKey = '5P9dzt8G6pHlSNP1zT8KoytLmDS8fXGM1P8126np';
  Future<void> _fetchImage() async {
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=${_apiKey}&date=$_selectedDate');
    final response = await http.get(url);


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _title = data['title'];
        _description = data['explanation'];
        _imageUrl = data['url'];
        print(_title);
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NASA Image of the Day'),
        actions: [
          IconButton(
              onPressed: (){
                context.read<ThemeCubit>().toggleTheme();
              },
              icon: context.read<ThemeCubit>().state.brightness == Brightness.light
              ? Icon(Icons.light_mode_rounded)
              : Icon(Icons.dark_mode_rounded)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter date in the format YYYY-MM-DD',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _fetchImage();

              },
              child: Text('Fetch Image'),
            ),

            Text(_title,style: brawlerStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w600,color: Theme.of(context).primaryColor)),
            Text(_description),
            const SizedBox(height: 10,),




            _imageUrl != null
            ? SizedBox(height: 220,width: 450,child: Image.network(_imageUrl!))
            : Text(""),




          ],
        ),
      ),
    );
  }
}
