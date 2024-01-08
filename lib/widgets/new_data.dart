//for user input
import 'package:flutter/material.dart';

import 'dart:convert'; //untuk database
import 'package:http/http.dart' as http; //untuk database
import 'package:intl/intl.dart'; // untuk date format perlu letak 'intl^....' kat pubspec.yaml line 33 !!!!

class NewData extends StatefulWidget {
  final Function addTrx;

  NewData(this.addTrx);

  @override
  _NewDataState createState() => _NewDataState();
}

class _NewDataState extends State<NewData> {
  final _formKey = GlobalKey<FormState>(); // database key
  final titleController = TextEditingController();
  final noteController = TextEditingController();
  DateTime _dateTime = DateTime.now();
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
////untuk database
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void _savedata() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'planner-7996b-default-rtdb.asia-southeast1.firebasedatabase.app', //buang 'https://....../'
          'planner.json');

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': titleController.text,
              'note': noteController.text,
              'duedate': DateFormat('yyyy/MM/dd').format(_dateTime),
              'date': DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now()),
            },
          ),
        );
        print(response.body);
        print(response.statusCode);

        if (response.statusCode == 200) {
          //200 data berjaya dimasukkan dlm database
          // Clear form fields selepas success submit data
          titleController.clear();
          noteController.clear();
          setState(() {
            _dateTime = DateTime.now();
          });
        }
      } catch (error) {
        print(error);
      }
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void pickDuedate() async {
    // untuk set duedate
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    );

    if (pickedDate != null) {
      // kalu tak letak ni bila tekan cancel dia akan crash
      setState(() {
        _dateTime = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////
    return Card(
      elevation: 8,
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              //
              //text field untuk title
              TextField(
                decoration: InputDecoration(labelText: 'title'),
                controller: titleController,
                //onChanged: (val) => {titleInput = val},
              ),
              //
              //
              //text field untuk note
              TextField(
                decoration: InputDecoration(labelText: 'note'),
                controller: noteController,
                maxLines: null, //max line yg dibenarkan
                minLines: 3, //line yg keluar
                //onChanged: (val) => {titleInput = val},
              ),
              //
              //
              //untuk pilih duedate
              SizedBox(height: 15),
              Text(
                'Due Date ',
                style: TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8), //size box
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              Colors.grey), // Optional border for the container
                    ),
                    child: Text(
                      DateFormat('yyyy/MM/dd').format(_dateTime),
                    ),
                  ),
                  SizedBox(
                      width: 10), //Add space between the text and the button
                  MaterialButton(
                    onPressed: pickDuedate,
                    child: Text('choose duedate'),
                    color: Colors.blue,
                  ),
                ],
              ),
              //
              //
              //untuk button dan send data yg diletak dlm database
              ElevatedButton(
                onPressed: _savedata,
                child: Text('Save'),
              ),
              /*
              //untuk button dan send data sebelum database
            ElevatedButton(
              onPressed: () {
                print(titleController);
                print(noteController);
                widget.addTrx(
                  titleController.text,
                  noteController.text,
                  _dateTime,
                );
              },
              child: Text('Save'),
            ),
            */
              //
              //
              //
            ],
          ),
        ),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////////
}
