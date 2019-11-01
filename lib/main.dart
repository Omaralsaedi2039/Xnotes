import 'package:flutter/material.dart';
import 'package:xnotes/screens/note_list.dart';
import 'package:xnotes/screens/note_detail.dart';
import 'package:flutter/services.dart';




void main() {

	runApp(MyApp());

	SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
		systemNavigationBarColor: Colors.white, // navigation bar color
		statusBarColor: Colors.white, // status bar color
		statusBarIconBrightness: Brightness.dark,
		systemNavigationBarIconBrightness: Brightness.dark,
	));

}

class MyApp extends StatelessWidget {

	@override
  Widget build(BuildContext context) {



		return MaterialApp(
	    title: 'NoteKeeper',
	    debugShowCheckedModeBanner: false,

	    theme: ThemeData(
		    primarySwatch: Colors.blue
	    ),
	    home: NoteList(),
    );
  }
}