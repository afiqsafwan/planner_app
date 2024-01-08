import 'package:flutter/material.dart';
import '../models/data.dart';
import '../widgets/update_data.dart';
import 'package:intl/intl.dart'; // untuk date format dd/MM/yyyy perlu letak 'intl^....' kat pubspec.yaml line 33 !!!!
import 'package:http/http.dart' as http; //untuk database http
import 'dart:convert'; //untuk database json

class DataList extends StatelessWidget {
  //untuk tukarkan warna card
  Color getCardColor(DateTime currentDate, DateTime dueDate) {
    Duration difference = dueDate.difference(currentDate);
    if (difference.inDays < 1) {
      return const Color.fromARGB(255, 131, 10, 1);
    } else if (difference.inDays <= 3) {
      return Colors.red;
    } else if (difference.inDays <= 7) {
      return const Color.fromARGB(255, 248, 136, 128);
    } else {
      return Colors.white;
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////
  //guna bila card di click
  void _showCardDetails(BuildContext context, Data data) {
    //UpdateData.showDetails(context, data); // Call update_data.dart
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateData(data),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  void _showCardDetails(BuildContext context, Data data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Note: ${data.note}'),
                Text(
                    'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(data.date)}'),
                // Display other details as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          fetchDataFromFirebase(), // function untuk pangil fetchDataFromFirebase() kat bawah
      builder: (ctx, snapshot) {
        //ConnectionState.waiting untuk menunjukkan dapat data ke tak
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loader while fetching
        } else {
          if (snapshot.hasError) {
            return Text('Error fetching data');
          } else {
            List<Data> dataList = snapshot.data as List<Data>;
            //////////////////////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////////////////
            ///design data output
            ////////////////////////////////////////////////////////////////////////////////////////////////////
            DateTime currentDate = DateTime.now();
            return Column(
              children: dataList.map((e) {
                return GestureDetector(
                    ///////////////////////////////////////////

                    onTap: () {
                      //supaya card boleh click
                      //call _showCardDetails above
                      _showCardDetails(context, e);
                      //print kat debug console
                      print('Card tapped: ${e.title}');
                    },
                    /////////////////////////////////////////////
                    child: Card(
                      // buat card
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.orange,
                            width: 2), // Border color and width
                        borderRadius:
                            BorderRadius.circular(10), // Adjust bucu border
                      ),

                      color: getCardColor(currentDate, e.duedate), //card color
                      elevation: 8, // bayang untuk card
                      shadowColor: Colors.black, //bayang color
                      child: Padding(
                        padding: EdgeInsets.all(
                            8), //untuk masuk data dalam kotak/padding properly
                        child: Row(
                          children: <Widget>[
                            //
                            //
                            //
                            //untuk buat duedate berada kat kanan dan title kat kiri
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // buat ia rapat ke kiri
                                children: <Widget>[
                                  Text(
                                    e.title.length > 20
                                        ? '${e.title.substring(0, 20)}...'
                                        : e.title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    e.note.length >
                                            20 //limit the output length show
                                        ? '${e.note.substring(0, 20)}...'
                                        : e.note,
                                    style: TextStyle(fontSize: 14),
                                    maxLines: 2, //max 2 line show
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(e
                                        .date), //kena letak import 'package:intl/intl.dart';
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .end, // Align content to the start
                                children: <Widget>[
                                  ///////////////////////////////////////////////////////////////////
                                  ///untuk button keluar update dan delete
                                  ///////////////////////////////////////////////////////////////////
                                  PopupMenuButton(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        child: Text('Delete'),
                                        value: 'delete',
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'update') {
                                        // Handle update logic
                                      } else if (value == 'delete') {
                                        // Handle delete logic
                                      }
                                    },
                                  ),
                                  ///////////////////////////////////////////////////////////////
                                  Text('Due Date:'),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(e
                                        .duedate), //untuk bukan string kena tukar kpd string dulu tapi untuk dateformat x perlu
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            //
                            //
                            //
                          ],
                        ),
                      ),
                    ));
              }).toList(),
            );
            ///////////////////////////////////////////////////////////////////////////////////////////////////
            ///////////////////////////////////////////////////////////////////////////////////////////////////
          }
        }
      },
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///call data from database
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

Future<List<Data>> fetchDataFromFirebase() async {
  final url = Uri.https(
    'planner-7996b-default-rtdb.asia-southeast1.firebasedatabase.app',
    'planner.json',
  );

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic>? dataMap = json.decode(response.body);
      if (dataMap != null) {
        List<Data> dataList = [];
        dataMap.forEach((key, value) {
          dataList.add(Data(
            id: key,
            title: value['title'],
            note: value['note'],
            duedate: DateTime.parse(
                value['duedate'].toString().replaceAll('/', '-')),
            date: DateTime.parse(value['date'].toString().replaceAll('/', '-')),
          ));
        });
        return dataList;
      } else {
        return []; // Return empty list if dataMap is null
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
