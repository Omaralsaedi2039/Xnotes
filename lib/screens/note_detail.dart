import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xnotes/models/note.dart';
import 'package:xnotes/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteDetail extends StatefulWidget {

	final String appBarTitle;
	final Note note;
	final String destroyButtonText;
	final bool noteIsSaved;

	NoteDetail(this. note, this.appBarTitle, this.destroyButtonText, this.noteIsSaved);

	@override
  State<StatefulWidget> createState() {



    return NoteDetailState(this.note, this.appBarTitle, this.destroyButtonText, this.noteIsSaved);
  }
}

class NoteDetailState extends State<NoteDetail> {

	static var _priorities = ['High', 'Low'];

	DatabaseHelper helper = DatabaseHelper();

	String appBarTitle;
	Note note;
	String destroyButtonText;
	bool noteIsSaved;


	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	NoteDetailState(this.note, this.appBarTitle, this.destroyButtonText, this.noteIsSaved);


	@override
  Widget build(BuildContext context) {


		if(noteIsSaved == true){
			titleController.text = note.title;
			descriptionController.text = note.description;
		}



		TextStyle textStyle = Theme.of(context).textTheme.title;

    return WillPopScope(

	    onWillPop: () {
	    	// Write some code to control things, when user press Back navigation button in device navigationBar
		    moveToLastScreen();
	    },

	    child: Scaffold(
				backgroundColor: Colors.white,

	    body: ListView(
				children: <Widget>[

					Padding(
					padding: EdgeInsets.only(top: 25.0, bottom: 15.0, right: 35, left: 35),
						child: Text(
							this.appBarTitle + ":",
							style: TextStyle(
								fontSize: 55.0,
								color: Colors.grey,
								fontWeight: FontWeight.bold,
								fontFamily: 'Helvetica-Neu-Bold',
							),
						),
					),

					Padding(
						padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35, left: 35),
						child: Container(
							decoration: new BoxDecoration(
									color: Color(0xffF0F0F0), //new Color.fromRGBO(255, 0, 0, 0.0),
									borderRadius: new BorderRadius.all(Radius.circular(10.0))
							),
							child: Padding(
								padding: const EdgeInsets.all(10.0),
								child: TextField(
									keyboardType: TextInputType.multiline,
									maxLines: null,
									controller: titleController,
									style: TextStyle(
										fontSize: 45.0,
										color: Colors.black,
										fontWeight: FontWeight.bold,
										fontFamily: 'Helvetica-Neu-Bold',
									),
									onChanged: (value) {
										noteIsSaved = false;
									},
									decoration: InputDecoration(
										hintText: 'Title',
										border: InputBorder.none,
									),
								),
							),
						),
					),

					Padding(
						padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35, left: 35),

						child: Container(
						decoration: new BoxDecoration(
								color: Color(0xffF0F0F0), //new Color.fromRGBO(255, 0, 0, 0.0),
								borderRadius: new BorderRadius.all(Radius.circular(10.0))
						),
							child: Padding(
						padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15),

								child: TextField(
									keyboardType: TextInputType.multiline,
									maxLines: null,
									controller: descriptionController,
									style: TextStyle(
											fontSize: 18.0,
											color: Colors.black,
										),
									onChanged: (value) {
										noteIsSaved = false;
										},
									decoration: InputDecoration(
											border: InputBorder.none,
											hintText: 'Your note',
										),
								),
							),
						),
					),

					Padding(
						padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 35, left: 35),
						child: Row(
							children: <Widget>[
								Expanded(
									child: RaisedButton(
										elevation: 0,
										shape: RoundedRectangleBorder(
												borderRadius: new BorderRadius.circular(18.0),
										),

										color: Theme.of(context).primaryColorDark,
										textColor: Theme.of(context).primaryColorLight,
										child: Text(
											'Save',
											style: TextStyle(
												fontFamily: 'Helvetica-Neu-Bold',
											),
											textScaleFactor: 1.5,
										),
										onPressed: () {

											if(titleController.text == null || descriptionController.text == null || titleController.text == '' || descriptionController.text == ''){
												Fluttertoast.showToast(
														msg: 'You can\'t save a note without title or description',
														toastLength: Toast.LENGTH_SHORT,
														gravity: ToastGravity.CENTER,
														timeInSecForIos: 1,
														backgroundColor: Colors.red,
														textColor: Colors.white
												);

											}
											else{
												updateTitle();
												updateDescription();
												noteIsSaved = true;
												setState(() {
													debugPrint("Save button clicked");
													_save();
												});
											}

										},
									),
								),

								Container(width: 30.0,),

								Expanded(
									child: RaisedButton(
										elevation: 0,
										shape: RoundedRectangleBorder(
											borderRadius: new BorderRadius.circular(18.0),
										),
										color: Theme.of(context).primaryColorDark,
										textColor: Theme.of(context).primaryColorLight,
										child: Text(
											this.destroyButtonText,
											textScaleFactor: 1.5,
											style: TextStyle(
												fontFamily: 'Helvetica-Neu-Bold',
											),
										),
										onPressed: () {
											setState(() {
												debugPrint("Delete button clicked");

												if(this.destroyButtonText == 'Discard'){
													_discard();
												}
												else if(this.destroyButtonText == "Delete"){
													_delete();
												}
											});
										},
									),
								),
							],
						),
					),
				],
	    ),
    )
		);
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Convert the String priority in the form of integer before saving it to Database
	void updatePriorityAsInt(String value) {
		switch (value) {
			case 'High':
				note.priority = 1;
				break;
			case 'Low':
				note.priority = 2;
				break;
		}
	}

	// Convert int priority to String priority and display it to user in DropDown
	String getPriorityAsString(int value) {
		String priority;
		switch (value) {
			case 1:
				priority = _priorities[0];  // 'High'
				break;
			case 2:
				priority = _priorities[1];  // 'Low'
				break;
		}
		return priority;
	}

	// Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

	// Update the description of Note object
	void updateDescription() {
		note.description = descriptionController.text;
	}

	// Save data to database
	void _save() async {


		moveToLastScreen();

		note.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (note.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(note);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(note);
		}


	}

	void _delete() async {

		moveToLastScreen();

		// Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
		// the detail page by pressing the FAB of NoteList page.
		if (note.id == null) {
			_showAlertDialog('Status', 'No Note was deleted');
			return;
		}

		// Case 2: User is trying to delete the old note that already has a valid ID.
		int result = await helper.deleteNote(note.id);
		if (result == 0) {
			_showAlertDialog('Status', 'Error Occured while Deleting Note');
		}
	}

	void _discard() async {

		moveToLastScreen();

	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}

}










