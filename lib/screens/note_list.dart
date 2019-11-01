import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xnotes/models/note.dart';
import 'package:xnotes/utils/database_helper.dart';
import 'package:xnotes/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {

	@override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

	DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
	int count = 0;

	@override
  Widget build(BuildContext context) {

		if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}

    return Scaffold(
			backgroundColor: Colors.white,

	    body:
				Container(
				  child: Row(
				      children: <Widget>[
				        Expanded(
				          child: Column(
				          	crossAxisAlignment: CrossAxisAlignment.stretch,
				          	children: <Widget>[
											Padding(
											  padding: const EdgeInsets.only(left: 35, top: 60, right: 35),
											  child: Text(
											  	"X Notes",
											  	style: TextStyle(
											  		fontSize: 55.0,
											  		color: Colors.grey,
											  		fontWeight: FontWeight.bold,
											  		fontFamily: 'Helvetica-Neu-Bold',
											  	),
											  ),
											),
											Expanded(
												child: Container(
													child:
														Center(
															child: Padding(
																padding: const EdgeInsets.only(top: 20),
																child:
																getNoteListView(),
														),
													),
												),
											),
				          	],
				          ),
				        ),
				      ],
				    ),
				  ),

	    floatingActionButton: Padding(
	      padding: const EdgeInsets.all(8.0),
	      child: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Note('', '', 2), 'Add Note', 'Discard', false);
		    },
				elevation: 0,
		    tooltip: 'Add Note',
		    child: Icon(Icons.add, color: Colors.white, size: 50.0,),
	      ),
	    ),
    );
  }


  ListView getNoteListView() {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				return Padding(
				  padding: const EdgeInsets.only(left: 35, right: 35),
				  child: Card(
						color: Color(0xffF0F0F0),
				  	elevation: 0.0,
						shape: RoundedRectangleBorder(
							borderRadius: BorderRadius.circular(15.0),
						),
				  	child: Padding(
				  	  padding: const EdgeInsets.all(8.0),
				  	  child: ListTile(
				  	  	title: Padding(
				  	  	  padding: const EdgeInsets.only(bottom: 8.0),
				  	  	  child:
									Text(this.noteList[position].title,
								style: TextStyle(
								fontSize: 20,
								fontWeight: FontWeight.bold,
								fontFamily: 'Helvetica-Neu-Bold',
							),
							),
				  	  	),

				  	  	subtitle: Text(this.noteList[position].description),
				  	  	onTap: () {
				  	  		debugPrint("ListTile Tapped");
				  	  		navigateToDetail(this.noteList[position],'Edit Note', 'Delete', true);
				  	  	},
				  	  ),
				  	),
				  ),
				);
			},
		);
  }

  // Returns the priority color
	Color getPriorityColor(int priority) {
		switch (priority) {
			case 1:
				return Colors.red;
				break;
			case 2:
				return Colors.yellow;
				break;

			default:
				return Colors.yellow;
		}
	}

	// Returns the priority icon
	Icon getPriorityIcon(int priority) {
		switch (priority) {
			case 1:
				return Icon(Icons.play_arrow);
				break;
			case 2:
				return Icon(Icons.keyboard_arrow_right);
				break;

			default:
				return Icon(Icons.keyboard_arrow_right);
		}
	}

	void _delete(BuildContext context, Note note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Note Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Note note, String title, String destroyButtonText, bool noteIsSaved) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title, destroyButtonText, noteIsSaved);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
  }

  void updateListView() {

		final Future<Database> dbFuture = databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}







