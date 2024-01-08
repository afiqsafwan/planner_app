import 'package:flutter/material.dart';
import '../models/data.dart'; // Import your Data model
import 'dart:convert'; //untuk database
import 'package:http/http.dart' as http; //untuk database
//import 'package:intl/intl.dart'; // untuk date format perlu letak 'intl^....' kat pubspec.yaml line 33 !!!!

class UpdateData extends StatefulWidget {
  final Data data;

  UpdateData(this.data);

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.data.title; // Set initial value for title
    noteController.text = widget.data.note; // Set initial value for note
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update plan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Link the GlobalKey<FormState>
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Update:',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: noteController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Validation logic for the note field
                  return null; // Add your validation if needed
                },
                // Logic to update note
              ),
              // Other fields to update
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  /////////////////////////////////////////////////////////////////////////////
                  if (_formKey.currentState!.validate()) {
                    // Perform the update logic using HTTP PUT request to Firebase
                    try {
                      final response = await http.put(
                        Uri.https(
                          'planner-7996b-default-rtdb.asia-southeast1.firebasedatabase.app',
                          'planner/${widget.data.id}.json',
                        ),
                        headers: {
                          'Content-Type': 'application/json',
                        },
                        body: json.encode(
                          {
                            'title': titleController.text,
                            'note': noteController.text,
                            // Add other fields to update if needed
                          },
                        ),
                      );

                      print(response.body);
                      print(response.statusCode);

                      if (response.statusCode == 200) {
                        Navigator.of(context).pop();
                      }
                    } catch (error) {
                      print(error);
                      // Handle error, show a snackbar, or display an error message
                    }
                  }
                  ////////////////////////////////////////////////////////////////////////////
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
















/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data.dart';

class UpdateData {
  static void showDetails(BuildContext context, Data data) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DataDetailsPage(data: data),
    ));
  }
}

class DataDetailsPage extends StatelessWidget {
  final Data data;

  const DataDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'title: ${data.title}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              'Note: ${data.note}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(data.date)}',
              style: TextStyle(fontSize: 16.0),
            ),
            // Display other details as needed
          ],
        ),
      ),
    );
  }
}
*/
