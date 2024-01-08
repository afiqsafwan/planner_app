import 'package:flutter/material.dart';
import 'models/data.dart';
import 'package:planner_app/widgets/new_data.dart'; //new_transaction.dart
import 'package:planner_app/widgets/data_list.dart'; //new_transaction.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // untuk buang debug water mark kat bucu atas
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //controller for text field widget

//////////////////////////////////////////////////////////////////////////////////
//////untuk new_data dan data_list
//////////////////////////////////////////////////////////////////////////////////
  final List<Data> datas = [];

  void _addNewData(String trxTitle, String trxNote, DateTime trxDuedate) {
    final newTrx = Data(
        id: DateTime.now().toString(),
        title: trxTitle,
        note: trxNote,
        duedate: trxDuedate,
        date: DateTime.now());

    setState(() {
      datas.add(newTrx);
    });
  }

//////////////////////////////////////////////////////////////////////////////////
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planner'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(188, 255, 153, 0),
      ),
      body: SingleChildScrollView(
        // supaya boleh scroll
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround, //control the axis
          crossAxisAlignment: CrossAxisAlignment.stretch, //control the axis
          children: <Widget>[
            Container(
                /*
              color: Color.fromARGB(255, 255, 153, 0),
              width: double
                  .infinity, // penuhkan saiz lebar kalau height untuk tinggi
              child: Card(
                color: Color.fromARGB(255, 0, 89, 255),
                child: Text('Welcome to Flutter!'),
              )*/
                ),
            //////////////////////////////////////////////////////////////////////////////////////////////////
            ///untuk new_data dan data_list
            /////////////////////////////////////////////////////////////////////////////////////////////////
            Visibility(
              // untuk bukak & tutup textfeld input
              visible: isVisible,
              child: NewData(_addNewData), //input
            ),

            DataList() // keluarkan lists

            ////////////////////////////////////////////////////////////////////////////////////////////////
            ///
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isVisible = !isVisible;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
